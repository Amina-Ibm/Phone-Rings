import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_rings/Widgets/ringtoneListTile.dart';
import '../Controllers/wishlistController.dart';

class WishlistView extends StatelessWidget {
  WishlistView({super.key});
  final WishlistController wishlistController = Get.find<WishlistController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Wishlist", style: TextStyle(color: Colors.white),),
      centerTitle: true,
        backgroundColor: const Color(0xFF521f64),
      ),
      body: Container(
        color: Color(0xFF521f64),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
          child: Obx(() {
            if (wishlistController.wishlist.isEmpty) {
              return const Center(
                child: Text("No ringtones in wishlist"),
              );
            }
            return ListView.builder(
              itemCount: wishlistController.wishlist.length,
              itemBuilder: (context, index) {
                final ringtone = wishlistController.wishlist[index];
                return RingtoneListTile(ringtone: ringtone);
              },
            );
          }),
        ),
      )
    );
  }
}
