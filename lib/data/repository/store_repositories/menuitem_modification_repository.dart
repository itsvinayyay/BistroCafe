import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:food_cafe/data/models/store_OrderCard_Models.dart';
import 'package:food_cafe/screens/store_screens/store_MenuItems.dart';

class MenuItemModification_Repository {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
    if (imageFile != null) {
      try {
        String imagePath = 'groceryStores/$storeID/menuItems/$itemID';
        Reference imageStorageReference =
            FirebaseStorage.instance.ref().child(imagePath);
        await imageStorageReference.putFile(imageFile);
        imageUrl = await imageStorageReference.getDownloadURL();
      } catch (e) {
        log("Exception called while uploading Image to Storage while Modifying MenuItem (Error from Menu Item Modification Repository)");
        rethrow;
      }
    }
    try {
      DocumentReference documentReference = _firestore
          .collection('groceryStores')
          .doc(storeID)
          .collection('menuItems')
          .doc(itemID);

      if (imageFile != null) {
        await documentReference.update({
          'Available': isavailable,
          'Category': category,
          'ImageURL': imageUrl,
          'Name': itemName,
          'Price': mrp,
        });
      } else {
        await documentReference.update({
          'Available': isavailable,
          'Category': category,
          'Name': itemName,
          'Price': mrp,
        });
      }
    } catch (e) {
      log("Exception while updating Menu Item (Error from MenuItem Modification Repository)");
      rethrow;
    }
  }
}
