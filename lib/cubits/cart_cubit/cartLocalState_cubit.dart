import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/data/models/CartScreen_FoodCard.dart';

class CartLocalState extends Cubit<Map<String, int>> {
  CartLocalState() : super({});

  int totalMRP = 0;
  //
  // Future<void> calculateTotal(String userID) async{
  //   final collectionRef = FirebaseFirestore.instance
  //       .collection('Users')
  //       .doc('SMVDU$userID')
  //       .collection('cartitem');
  //   try{
  //     log("Calculating");
  //     int total = 0;
  //     for(var entry in state.entries){
  //       String itemID = entry.key;
  //       int quantity = entry.value;
  //       final docRef = await collectionRef.doc(itemID).get();
  //       int mrp = docRef['Price'];
  //       total += quantity * mrp;
  //     }
  //     totalMRP = total;
  //     emit(state);
  //   } catch (e) {
  //     log('Error getting totalMRP with Firestore: $e');
  //   }
  //
  //   log(totalMRP);
  //
  // }

  Future<void> initializefromFirebase(String userID) async {
    try {
      final collectionRef = FirebaseFirestore.instance
          .collection('Users')
          .doc('SMVDU$userID')
          .collection('cartitem');
      final snapshot = await collectionRef.get();
      final initializedState = Map<String, int>();
      int total = 0;
      if (snapshot.docs.isNotEmpty) {
        for (var docs in snapshot.docs) {
          String itemID = docs.id;
          int quantity = docs['Quantity'];
          int mrp = docs['Price'];
          total += quantity * mrp;

          initializedState[itemID] = quantity;
        }
      }
      log(totalMRP.toString());

      emit(initializedState);

      // log(initializedState.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  void addItemsToLocal(String itemID, String userID) async {
    Map<String, int> updatedState = Map.from(state);
    if (updatedState.containsKey(itemID)) {
      updatedState[itemID] = updatedState[itemID]! + 1;
    }
    log('Quantity Increased!');

    emit(updatedState);
  }

  void removeItemsfromLocal(String userID, String itemID) async {
    Map<String, int> updatedState = Map.from(state);

    if (updatedState.containsKey(itemID)) {
      if (updatedState[itemID] == 1) {
        final collectionRef = FirebaseFirestore.instance
            .collection('Users')
            .doc('SMVDU$userID')
            .collection('cartitem');
        final query =
            await collectionRef.where('ItemID', isEqualTo: itemID).get();
        for (var doc in query.docs) {
          await doc.reference.delete();
        }
        updatedState.remove(itemID);
      } else {
        updatedState[itemID] = updatedState[itemID]! - 1;
      }
    }
    log('Quantity Decreased!');
    log(updatedState.toString());
    emit(updatedState);
  }

  void deleteItemfromCart(String userID, String itemID) async {
    Map<String, int> updatedState = Map.from(state);
    final collectionRef = FirebaseFirestore.instance
        .collection('Users')
        .doc('SMVDU$userID')
        .collection('cartitem');
    try {
      final query =
          await collectionRef.where('ItemID', isEqualTo: itemID).get();
      for (var doc in query.docs) {
        await doc.reference.delete();
      }
      updatedState.remove(itemID);
      log('Item removed!');
      log(updatedState.toString());
      emit(updatedState);
    } catch (e) {
      log(e.toString());
    }
  }

  void addItemstoCart(
      String userID, Cart_FoodCard_Model item, BuildContext context) async {
    Map<String, int> updatedState = Map.from(state);
    final collectionRef = FirebaseFirestore.instance
        .collection('Users')
        .doc('SMVDU$userID')
        .collection('cartitem');
    try {
      final query = await collectionRef
          .where('ItemID', isEqualTo: item.itemID)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        updatedState[item.itemID!] = updatedState[item.itemID]! + 1;
        log('Already Present!');
      } else {
        updatedState[item.itemID!] = 1;
        collectionRef.doc(item.itemID).set(item.toJson());
      }
      log('Item Added!');
      log(updatedState.toString());
      emit(updatedState);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Your Cart List is updated!"),
        duration: Duration(seconds: 1),
      ));
    } catch (e) {
      log(e.toString());
    }
  }

  Future syncLocalState(String userID) async {
    final collectionRef = FirebaseFirestore.instance
        .collection('Users')
        .doc('SMVDU$userID')
        .collection('cartitem');
    try {
      for (var entry in state.entries) {
        String itemID = entry.key;
        int quantity = entry.value;

        final docRef = collectionRef.doc(itemID);
        await docRef.update({'Quantity': quantity});
      }

      log("Items Synced!");
    } catch (e) {
      log('Error syncing with Firestore: $e');
    }
  }
}
