import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';
import 'package:phone_rings/Services/freesoundAuth.dart';
import '../Models/ringtoneModel.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:toastification/toastification.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
class RingtoneController extends GetxController {
  var isLoading = false.obs;
  var ringtones = <Ringtone>[].obs;
  var authorizationCode = '';
  var accessToken = '';
  final String apiKey = "lOMmS3wRHdF8yMwmv7I3O0qdYT8s6JpS3hiU3esO";
  Future<void> fetchRingtones( {int page = 1, int pageSize = 15, String? query}) async {
    const String baseUrl = "https://freesound.org/apiv2/search/text/";
    final searchQuery = query ?? 'trending';
    try {
      isLoading.value = true;
      final queryParams = {
        'query': {searchQuery},
        'fields': 'id,url,name,analysis_frames,tags,type,duration,username,download,previews',
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };

      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);
      print(uri);
      final response = await http.get(
        uri,
        headers: {
          "Authorization": "Token $apiKey",
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        print(jsonData);
        final List<Ringtone> fetchedRingtones = (jsonData['results'] as List)
            .map((item) => Ringtone.fromJson(item))
            .toList();
        ringtones.value = fetchedRingtones;
      } else {
        Get.snackbar(
          "Error",
          "Failed to fetch ringtones. Status Code: ${response.statusCode}",
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load ringtones. Error: $e");
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getAuthenticated() async {
    //Navigator.pop(context);
    final authServ = FreeSoundAuthService();
    final authUrl = await authServ.getAuthorizationUrl();
  }
  Future<void> downloadRingtone(String downloadUrl, String fileName, int songId) async {
    await getAuthenticated();
    Future.delayed(const Duration(seconds: 12), () async {
      try {
        downloadmp3(downloadUrl, fileName, songId);
      }
      catch (e) {
        print("Couldnt download the ringtone : $e");
      }
    }
    );
  }


  Future<void> downloadmp3(String downloadUrl, String fileName, int songId) async {
    try {
      final directory = await getExternalStorageDirectory();
      final savePath = "${directory?.path}/$fileName";
      String baseUrl = "https://freesound.org/apiv2/sounds/${songId}/download/";
      final headers = {
        "Authorization": "Bearer $accessToken",
      };
      print('Access token in download header: $accessToken');
      final uri = Uri.parse(baseUrl);
      final response = await http.get(
          uri,
          headers: headers
      );
      final dio = Dio(BaseOptions(headers: headers));
      toastification.show(
        type: ToastificationType.info,
        style: ToastificationStyle.fillColored,
        title: Text("Download in Progress"),
        alignment: Alignment.bottomCenter,
        autoCloseDuration: const Duration(seconds: 4),
        primaryColor: Color(0xffffffff),
        backgroundColor: Color(0xffffffff),
        foregroundColor: Color(0xff521f64),
      );
      await dio.download(
        downloadUrl,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            print("Download progress: ${(received / total * 100).toStringAsFixed(0)}%");
          }
        },
      );


      toastification.show(
        type: ToastificationType.success,
        style: ToastificationStyle.fillColored,
        title: Text("Ringtone Downloaded Successfully!"),
        alignment: Alignment.bottomCenter,
        autoCloseDuration: const Duration(seconds: 4),
        primaryColor: Color(0xffffffff),
        backgroundColor: Color(0xffffffff),
        foregroundColor: Color(0xff521f64),
        showProgressBar: true,
      );
      print("Ringtone downloaded successfully: $savePath");
    } catch (e) {
      // Handle errors
      print("Error downloading ringtone: $e");
      Get.snackbar("Error", "Failed to download ringtone. Error: $e");

    }
  }


}

