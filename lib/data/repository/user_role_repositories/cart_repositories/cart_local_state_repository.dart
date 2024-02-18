import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_cafe/data/models/user_cart_model.dart';

/// Repository class responsible for handling local state operations related to the cart.
class CartLocalStateRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Retrieves the initialized local state of the cart for a specific person.
  ///
  /// Parameters:
  /// - [personID]: The unique identifier of the person whose cart state is being retrieved.
  ///
  /// Returns:
  /// A [Future] with a [Map] containing item IDs as keys and corresponding quantities as values.
  Future<Map<String, int>> getLocalStateInitialized(
      {required String personID}) async {
    try {
      CollectionReference collectionReference = _firestore
          .collection('Users')
          .doc('SMVDU$personID')
          .collection('cartitem');

      QuerySnapshot querySnapshot = await collectionReference.get();
    

      Map<String, int> toBeReturned = Map<String, int>();

      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.map((doc) {
          String itemID = doc.id;
          int quantity = doc['Quantity'];

          toBeReturned[itemID] = quantity;
        }).toList();
      } else {
        log('No Cart Items Present!');
      }

      return toBeReturned;
    } catch (e) {
      log("Exception while initializing Local State (Error from Cart Local State Repository)");
      rethrow;
    }
  }

  /// Deletes an item from the cart for a specific person.
  ///
  /// Parameters:
  /// - [personID]: The unique identifier of the person whose cart is being modified.
  /// - [itemID]: The unique identifier of the item to be deleted.
  Future<void> deleteItemFromCart(
      {required String personID, required String itemID}) async {
    try {
      DocumentReference documentReference = _firestore
          .collection('Users')
          .doc('SMVDU$personID')
          .collection('cartitem')
          .doc(itemID);

      await documentReference.delete();
    } catch (e) {
      log("Exception while deleting an Item from Cart (Error from Cart Local State Repository) => $e");
      rethrow;
    }
  }

  /// Checks if an item exists in the cart for a specific person.
  ///
  /// Parameters:
  /// - [personID]: The unique identifier of the person whose cart is being checked.
  /// - [itemID]: The unique identifier of the item to check for existence.
  ///
  /// Returns:
  /// A [Future] with a [bool] indicating whether the item exists in the cart.
  Future<bool> checkItemExists(
      {required String personID, required String itemID}) async {
    try {
      DocumentReference documentReference = _firestore
          .collection('Users')
          .doc('SMVDU$personID')
          .collection('cartitem')
          .doc(itemID);
      DocumentSnapshot documentSnapshot = await documentReference.get();
      return documentSnapshot.exists;
    } catch (e) {
      log("Exception while checking Item's existence in Cart (Error from Cart Local State Repository) => $e");
      rethrow;
    }
  }

  /// Adds an item to the cart for a specific person.
  ///
  /// Parameters:
  /// - [personID]: The unique identifier of the person whose cart is being modified.
  /// - [item]: The item to be added to the cart.
  Future<void> addItemToCart(
      {required String personID, required CartModel item}) async {
    try {
      CollectionReference collectionReference = _firestore
          .collection('Users')
          .doc('SMVDU$personID')
          .collection('cartitem');

      await collectionReference.doc(item.itemID).set(item.toJson());
    } catch (e) {
      log("Exception while adding Item to Cart (Error from Cart Local State Repository) => $e");
      rethrow;
    }
  }

  /// Synchronizes the local state of the cart with Firestore for a specific person.
  ///
  /// Parameters:
  /// - [personID]: The unique identifier of the person whose cart is being synchronized.
  /// - [localState]: The local state to be synchronized with Firestore.
  Future<void> syncCartWithLocal(
      {required String personID, required Map<String, int> localState}) async {
    try {
      CollectionReference collectionReference = _firestore
          .collection('Users')
          .doc('SMVDU$personID')
          .collection('cartitem');

      localState.forEach((key, value) async {
        await collectionReference.doc(key).update({'Quantity': value});
      });
    } catch (e) {
      log("Exception while syncing local with cart (Error from Cart Local State Repository) => $e");
      rethrow;
    }
  }
}
