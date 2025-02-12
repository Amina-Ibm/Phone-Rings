import 'dart:convert';
import 'package:app_links/app_links.dart';
import 'package:phone_rings/Controllers/ringtoneController.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:async';


class RedirectAuthHandler {
  RingtoneController ringtoneControl = Get.put(RingtoneController());
  void initRedirectListener(BuildContext context, AppLinks appLinks) {
    appLinks.uriLinkStream.listen((Uri? uri) async {
      if (uri != null) {
        print("Raw URI String: ${uri.toString()}");
        print("Query Parameters: ${uri.query}");

        if (uri.queryParameters.isEmpty) {
          print("No query parameters found!");
        } else {
          uri.queryParameters.forEach((key, value) {
            print("Key: $key, Value: $value");
          });
        }
        final String? code = uri.queryParameters['code'];
        if (code != null) {
          print("Authorization Code Found: $code");
          ringtoneControl.authorizationCode = code;
          exchangeCodeForToken(code);
        } else {
          print("Authorization Code NOT found.");
        }

        }
    });
  }


  Future<void> exchangeCodeForToken(String code) async {
    const String tokenUrl = 'https://freesound.org/apiv2/oauth2/access_token/';
    const String clientId = 'sVFVjOZKw8DoDY3jEXvx';
    const String clientSecret = 'lOMmS3wRHdF8yMwmv7I3O0qdYT8s6JpS3hiU3esO';
    const String redirectUri = 'https://redirect-page-e4v5.vercel.app/';

    try {
      final response = await http.post(
        Uri.parse(tokenUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'client_id': clientId,
          'client_secret': clientSecret,
          'grant_type': 'authorization_code',
          'code': code,
          'redirect_uri': redirectUri, // Important for OAuth flow
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String accessToken = responseData['access_token'];
        final String refreshToken = responseData['refresh_token'];
        final int expiresIn = responseData['expires_in'];
        ringtoneControl.accessToken = accessToken;
        print("✅ Access Token: $accessToken");
        print("🔄 Refresh Token: $refreshToken");
        print("⏳ Expires In: $expiresIn seconds");

      } else {
        print("❌ Error: ${response.statusCode}, ${response.body}");
      }
    } catch (e) {
      print("⚠️ Exception: $e");
    }
  }


}
