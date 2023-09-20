import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/data/models/CartScreen_FoodCard.dart';
import 'package:food_cafe/data/models/store_OrderCard_Models.dart';

class MenuItems extends Cubit<List<store_MenuItemsCard_Model>> {
  MenuItems() : super([]);

  final _fireStore = FirebaseFirestore.instance;
  StreamSubscription<QuerySnapshot>? _subscription;

  Future<void> toggleAvailability(String documentId, bool newAvailability, String storeNumber) async {
    try {
      print("STARTED!!!!");
      final collectionRef = _fireStore.collection('groceryStores').doc('SMVDU$storeNumber').collection('menuItems');

      // Update the "available" field in the specified document
      await collectionRef.doc(documentId).update({'Available': newAvailability});
    } catch (e) {
      // Handle any errors, e.g., connection issues or document not found
      print('Error toggling availability: $e');
    }
  }

  Future<void> deleteItem(String documentId, String storeNumber) async {
    try {
      // Remove the item with the specified documentId from the Firestore collection
      final collectionRef =
      _fireStore.collection('groceryStores').doc('SMVDU$storeNumber').collection('menuItems');
      await collectionRef.doc(documentId).delete();

      // Update the state to remove the deleted item
      // emit(state.where((item) => item.documentId != documentId).toList());
    } catch (e) {
      // Handle any errors, e.g., connection issues or document not found
      print('Error deleting item: $e');
    }
  }


  // int totalMRP = 0;


  void startListening(String storeNumber) {
    print(storeNumber);
    final collectionRef = _fireStore.collection('groceryStores').doc('SMVDU$storeNumber').collection(
        'menuItems');

    _subscription = collectionRef.snapshots().listen((snapshot) {
      final MenuItems = snapshot.docs.map((docs) =>
          store_MenuItemsCard_Model.fromJson(docs.data())).toList();
      emit(MenuItems);
    });
  }

  // void calculateTotal(){
  //   final itemList = state;
  //   int total = 0;
  //   for(var cartItem in itemList){
  //     total+= cartItem.mrp! * cartItem.quantity!;
  //   }
  //
  //   totalMRP = total;
  // }


  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

