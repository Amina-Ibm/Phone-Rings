import 'package:get/get.dart';
import '../Models/ringtoneModel.dart';

class WishlistController extends GetxController {
  var wishlist = <Ringtone>[].obs; // Observable list of liked ringtones

  void toggleWishlist(Ringtone ringtone) {
    if (wishlist.contains(ringtone)) {
      wishlist.remove(ringtone); // Remove if already in the list
    } else {
      wishlist.add(ringtone); // Add if not in the list
    }
  }

  bool isInWishlist(Ringtone ringtone) {
    return wishlist.contains(ringtone);
  }
}
