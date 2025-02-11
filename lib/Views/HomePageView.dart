import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:phone_rings/Services/redirectAuth.dart';
import 'package:phone_rings/Views/wishlistView.dart';
import 'package:phone_rings/categories.dart';
import 'package:phone_rings/Controllers/ringtoneController.dart';
import '../Controllers/wishlistController.dart';
import '../Widgets/ringtoneListTile.dart';
import 'package:get/get.dart';
import 'dart:math';

class HomePageView extends StatefulWidget {
  HomePageView({super.key});
  @override
  State<HomePageView> createState() => _HomePageViewState();
}
class _HomePageViewState extends State<HomePageView> {
  final WishlistController wishlistController = Get.put(WishlistController());

  Color getRandomColor() {
    Random random = Random();
    return Color.fromARGB(
      255, // Alpha (fully opaque)
      random.nextInt(220), // Red (0-255)
      random.nextInt(220), // Green (0-255)
      random.nextInt(220), // Blue (0-255)
    );
  }

  AppLinks applink = AppLinks();
  final RingtoneController ringtoneController = Get.put(RingtoneController());
  late List<Color> categoryColors;
  Timer? _debounce;
  @override
  void initState() {
    super.initState();
    categoryColors = List.generate(categories.length, (_) => getRandomColor());
      ringtoneController.fetchRingtones();
      print("ringtones fetch initialized");
      final redirectAuth = RedirectAuthHandler();
      print("redirect auth initialized");
      redirectAuth.initRedirectListener(context, applink);
      print("listener initialized initialized");
  }
    @override
    Widget build(BuildContext context) {
      List<dynamic> ringtones = ringtoneController.ringtones;
      final TextEditingController searchController = TextEditingController();
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF521f64),
          centerTitle: true,
          title: Text(
            'Phone Rings',
            style: Theme
                .of(context)
                .textTheme
                .displayMedium,
          ),
          actions: [
            IconButton(onPressed: (){Get.to(WishlistView());},
          icon: const Icon(
          Ionicons.heart,
          size: 28,
          color: Colors.white,
        ),)
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF521f64),
                Color(0xFF170f40)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 50,
                width: MediaQuery
                    .of(context)
                    .size
                    .width - 50,
                child: TextField(
                  controller: searchController,
                  style: Theme.of(context).textTheme.bodyMedium,

                  decoration: InputDecoration(
                    hintText: 'Search Text',
                    hintStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)
                    ),

                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          ringtoneController.fetchRingtones(
                              query: searchController.text);
                        });
                      },
                      child: Icon(Icons.search, color: Colors.white,),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Categories',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: SizedBox(
                  height: 80, // Constrain the height of the ListView
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            ringtoneController.fetchRingtones(
                                query: categories[index]);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: categoryColors[index],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.center,
                          width: 100,
                          child: Text(
                            categories[index],
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(width: 20);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              const Text('Trending',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20,),
              Expanded(
                  child: Obx(() {
                    if (ringtoneController.isLoading.value) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (ringtoneController.ringtones.isEmpty) {
                      return const Center(
                          child: Text('No ringtones available.'));
                    }
                    return ListView.separated(
                        itemBuilder: (context, index) {
                          return RingtoneListTile(ringtone: ringtones[index],);
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 10,);
                        },
                        itemCount: ringtones.length);
                  }

                  )
              )

            ],
          ),
        ),
      );
    }
  }