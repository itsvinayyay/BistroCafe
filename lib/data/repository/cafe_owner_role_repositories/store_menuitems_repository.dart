import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:food_cafe/data/models/store_menu_item_model.dart';

class MenuItemRepository {
  final _firestore = FirebaseFirestore.instance;
  final _menuItemsController =
      StreamController<List<StoreMenuItemModel>>();

  /// Getter for accessing the menu items stream.
  Stream<List<StoreMenuItemModel>> get getMenuItems =>
      _menuItemsController.stream;

  StreamSubscription<QuerySnapshot?>? _subscription;

  /// Initiates the stream of menu items for a specified store.
  ///
  /// This method sets up a stream subscription on the Firestore collection
  /// corresponding to the menu items of the given store. Whenever the collection
  /// is updated, the stream emits a list of menu items converted from the Firestore documents.
  ///
  /// Parameters:
  /// - `storeID`: The identifier of the store for which the menu items stream is requested.
  ///
  /// Throws an exception if there's an issue during the stream setup or listening process.
  void getMenuItemsStream(String storeID) {
    try {
      final collectionRef = _firestore
          .collection('groceryStores')
          .doc(storeID)
          .collection('menuItems');

      _subscription = collectionRef.snapshots().listen((querySnapshot) {
        final menuItems = querySnapshot.docs
            .map((docs) => StoreMenuItemModel.fromJson(docs.data()))
            .toList();
        _menuItemsController.add(menuItems);
      });
    } catch (e) {
      log("Error while fetching Menu Items (Error from Menu Item Repository)=> $e");
      rethrow;
    }
  }

  /// Deletes the image associated with a menu item from Firebase Storage.
  ///
  /// This method takes the `storeID` and `itemID` as parameters to construct the
  /// path to the image in Firebase Storage and attempts to delete it.
  ///
  /// Parameters:
  /// - `storeID`: The identifier of the store to which the menu item belongs.
  /// - `itemID`: The identifier of the menu item for which the image should be deleted.
  ///
  /// Throws an exception if there's an issue during the deletion process.
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

  /// Deletes a menu item from Firestore.
  ///
  /// This method takes the `storeID` and `itemID` as parameters to construct the
  /// path to the menu item in Firestore and attempts to delete it.
  ///
  /// Parameters:
  /// - `storeID`: The identifier of the store from which the menu item should be deleted.
  /// - `itemID`: The identifier of the menu item to be deleted.
  ///
  /// Throws an exception if there's an issue during the deletion process.
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

  /// Modifies the availability of a menu item in Firestore.
  ///
  /// This method takes the `storeID`, `itemID`, and `newAvailability` as parameters
  /// to locate the menu item in Firestore and update its availability status.
  ///
  /// Parameters:
  /// - `storeID`: The identifier of the store where the menu item is located.
  /// - `itemID`: The identifier of the menu item to be modified.
  /// - `newAvailability`: The new availability status for the menu item.
  ///
  /// Throws an exception if there's an issue during the modification process.
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

  /// Closes the subscription to the menu items stream.
  ///
  /// This method cancels the subscription and closes the stream controller
  /// to release resources associated with listening to menu item updates.
  void closeSubscription() {
    _subscription?.cancel();
    _menuItemsController.close();
  }
}
