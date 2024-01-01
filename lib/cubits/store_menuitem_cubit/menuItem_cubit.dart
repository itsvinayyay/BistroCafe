import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:food_cafe/data/models/store_OrderCard_Models.dart';

class MenuItems extends Cubit<List<store_MenuItemsCard_Model>> {
  MenuItems() : super([]);

  final _fireStore = FirebaseFirestore.instance;
  StreamSubscription<QuerySnapshot>? _subscription;

  Future<void> toggleAvailability(String documentId, bool newAvailability, String storeNumber) async {
    try {
      print("STARTED!!!!");
      final collectionRef = _fireStore.collection('groceryStores').doc(storeNumber).collection('menuItems');

      // Update the "available" field in the specified document
      await collectionRef.doc(documentId).update({'Available': newAvailability});
    } catch (e) {
      // Handle any errors, e.g., connection issues or document not found
      print('Error toggling availability: $e');
    }
  }

  Future<void> deleteItem(String documentId, String storeNumber) async {
    String filePath = 'groceryStores/$storeNumber/menuItems/$documentId';
    Reference storageReference = FirebaseStorage.instance.ref().child(filePath);

    try {
      // Delete the file from Firebase Storage
      await storageReference.delete();
      print("Image deleted successfully!");
    } catch (e) {
      print("Error deleting image: $e");
    }
    try {
      // Remove the item with the specified documentId from the Firestore collection
      final collectionRef =
      _fireStore.collection('groceryStores').doc(storeNumber).collection('menuItems');
      await collectionRef.doc(documentId).delete();

      // Update the state to remove the deleted item
      // emit(state.where((item) => item.documentId != documentId).toList());
    } catch (e) {
      // Handle any errors, e.g., connection issues or document not found
      print('Error deleting item: $e');
    }
  }


  // int totalMRP = 0;


  void startListening(String storeID) {
    print(storeID);
    final collectionRef = _fireStore.collection('groceryStores').doc(storeID).collection(
        'menuItems');

    _subscription = collectionRef.snapshots().listen((snapshot) {
      final MenuItems = snapshot.docs.map((docs) =>
          store_MenuItemsCard_Model.fromJson(docs.data())).toList();
      emit(MenuItems);
    });
  }



  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

