import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

///Repository to handle all modification in an already available Menu Item.
class ModifyMenuItemRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Modifies menu items in the Firestore database.
  ///
  /// [storeID] represents the unique identifier for the store.
  /// [itemName] is the name of the menu item.
  /// [category] is the category to which the menu item belongs.
  /// [mrp] is the maximum retail price of the menu item.
  /// [isavailable] indicates whether the menu item is available.
  /// [imageFile] is an optional parameter representing the image file of the menu item.
  /// [itemID] is the unique identifier for the menu item to be modified.
  Future<void> modifyMenuItems({
    required String storeID,
    required String itemName,
    required String category,
    required int mrp,
    required bool isavailable,
    File? imageFile,
    required String itemID,
  }) async {
    String imageUrl = "";

    // If an image file is provided, upload it to Firebase Storage
    if (imageFile != null) {
      try {
        String imagePath = 'groceryStores/$storeID/menuItems/$itemID';
        Reference imageStorageReference =
            FirebaseStorage.instance.ref().child(imagePath);
        await imageStorageReference.putFile(imageFile);
        imageUrl = await imageStorageReference.getDownloadURL();
      } catch (e) {
        log("Exception occurred while uploading Image to Storage while Modifying MenuItem (Error from Menu Item Modification Repository)");
        rethrow;
      }
    }

    try {
      // Update the menu item document in Firestore
      DocumentReference documentReference = _firestore
          .collection('groceryStores')
          .doc(storeID)
          .collection('menuItems')
          .doc(itemID);

      if (imageFile != null) {
        // Update with image URL if an image is provided
        await documentReference.update({
          'Available': isavailable,
          'Category': category,
          'ImageURL': imageUrl,
          'Name': itemName,
          'Price': mrp,
        });
      } else {
        // Update without image URL if no image is provided
        await documentReference.update({
          'Available': isavailable,
          'Category': category,
          'Name': itemName,
          'Price': mrp,
        });
      }
    } catch (e) {
      log("Exception occurred while updating Menu Item (Error from MenuItem Modification Repository)");
      rethrow;
    }
  }
}
