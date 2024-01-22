import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_cafe/data/models/All_Orders_Models.dart';

class OrderHistoryRepository {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Orders_Model>> getOrderHistory({required String personID}) async {
    try {
      List<String> orderIDs = await _getOrderIDList(personID: personID);
      List<Orders_Model> orders = [];
      if (orderIDs.isEmpty) {
        log('No Order IDs found');
        return orders;
      }

      await Future.wait(orderIDs.map((orderID) async {
        String storeID = _getStoreID(orderID: orderID);

        Orders_Model orderModel =
            await _getOrderDetails(orderID: orderID, storeID: storeID);
        orders.add(orderModel);
      }));

      log(orders.toString());

      return orders;
    } catch (e) {
      log('Exception while fetching Order History (Error from Order History Repository)');
      rethrow;
    }
  }

  Future<Orders_Model> _getOrderDetails(
      {required String orderID, required String storeID}) async {
    try {
      DocumentReference documentReference = _firestore
          .collection('groceryStores')
          .doc(storeID)
          .collection('requestedOrders')
          .doc(orderID);
      DocumentSnapshot documentSnapshot = await documentReference.get();
      if (!documentSnapshot.exists) {
        log("It exists");
      }

      Map<String, dynamic> json =
          documentSnapshot.data() as Map<String, dynamic>;

      Orders_Model orders_model = Orders_Model.fromJson(json);
      return orders_model;
    } catch (e) {
      log('Exception while fetching Order Details (Error from Order History Repository)');
      rethrow;
    }
  }

  // Future<List<MapEntry<String, String>>> _getOrderIDs(
  //     {required String personID}) async {
  //   try {
  //     CollectionReference collectionReference = _firestore
  //         .collection('Users')
  //         .doc('SMVDU$personID')
  //         .collection('ordersPlaced');

  //     QuerySnapshot querySnapshot = await collectionReference.get();
  //     List<MapEntry<String, String>> ordersList = [];

  //     if (querySnapshot.docs.isNotEmpty) {
  //       log('docs not empty');
  //       await Future.wait(querySnapshot.docs.map((doc) async {
  //         String orderID = doc.id;
  //         String storeID = (doc.data() as Map<String, dynamic>)['StoreID'];
  //         log(orderID);
  //         log(storeID);
  //         ordersList.add(MapEntry(orderID, storeID));
  //       }));
  //     } else {
  //       log('ordersPlaced sub-Collection is empty (Warning from Order History Repository)');
  //     }

  //     return ordersList;
  //   } catch (e) {
  //     log('Exception while fetching Order IDs (Error from Order History Repository)');
  //     rethrow;
  //   }
  // }

  String _getStoreID({required String orderID}) {
    List<String> parts = orderID.split('ORD');
    if (parts.length != 2) {
      log("Error with the previous Order ID");
    }
    return parts[0];
  }

  Future<List<String>> _getOrderIDList({required String personID}) async {
    try {
      DocumentReference documentReference =
          _firestore.collection('Users').doc('SMVDU$personID');

      DocumentSnapshot documentSnapshot = await documentReference.get();
      List<String> orderIDs = [];

      if (documentSnapshot.exists) {
        // Check if the document exists before attempting to access its data
        var data = documentSnapshot.data() as Map<String, dynamic>?;

        if (data != null && data['OrderIDs'] != null) {
          // Ensure that 'OrderIDs' is not null before attempting to cast
          orderIDs = List<String>.from(data['OrderIDs']);
        } else {
          log('OrderIDs array is empty (Warning from Order History Repository)');
        }
      } else {
        log('Document does not exist for ID: $personID');
        throw 'Document does not exist for ID: $personID';
      }

      return orderIDs;
    } catch (e) {
      log('Exception while fetching Order IDs (Error from Order History Repository)');
      rethrow;
    }
  }
}
