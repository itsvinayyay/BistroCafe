import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:food_cafe/data/models/store_OrderCard_Models.dart';

class MenuItemRepository {
  final _firestore = FirebaseFirestore.instance;
  final _menuItemsController =
      StreamController<List<store_MenuItemsCard_Model>>();
  Stream<List<store_MenuItemsCard_Model>> get getMenuItems =>
      _menuItemsController.stream;

  StreamSubscription<QuerySnapshot?>? _subscription;

  void getMenuItemsStream(String storeID) {
    try {
      final collectionRef = _firestore
          .collection('groceryStores')
          .doc(storeID)
          .collection('menuItems');

      _subscription = collectionRef.snapshots().listen((querySnapshot) {
        final menuItems = querySnapshot.docs
            .map((docs) => store_MenuItemsCard_Model.fromJson(docs.data()))
            .toList();
        _menuItemsController.add(menuItems);
      });
    } catch (e) {
      log("Error while fetching Menu Items (Error from MenuItemRepository) $e");
      rethrow;
    }
  }

  Future<void> deleteItemImage(
      {required String storeID, required String itemID}) async {
    Reference imageReference = FirebaseStorage.instance
        .ref()
        .child('groceryStores/$storeID/menuItems/$itemID');

    try {
      await imageReference.delete();
    } catch (e) {
      log("Exception caught while deleting Item's Image from Menu Item Repository");
      rethrow;
    }
  }

  Future<void> deleteItem(
      {required String storeID, required String itemID}) async {
    try {
      CollectionReference collectionReference = _firestore
          .collection('groceryStores')
          .doc(storeID)
          .collection('menuItems');
      await collectionReference.doc(itemID).delete();
    } catch (e) {
      log("Exception caught while Deleting the Menu Item (Error from MenuItem Repository)");
      rethrow;
    }
  }

  Future<void> modifyAvailability(
      {required String storeID,
      required String itemID,
      required bool newAvailability}) async {
    try {
      CollectionReference collectionReference = _firestore
          .collection('groceryStores')
          .doc(storeID)
          .collection('menuItems');
      await collectionReference
          .doc(itemID)
          .update({'Available': newAvailability});
    } catch (e) {
      log("Exception caught while Modifying the availability of the Menu Item (Error from MenuItem Repository)");
      rethrow;
    }
  }

  void closeSubscription() {
    _subscription?.cancel();
    _menuItemsController.close();
  }
}
