import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_cafe/data/models/All_Orders_Models.dart';

class RequestedOrdersRepository {
  final _firestore = FirebaseFirestore.instance;
  final _requestedOrdersController = StreamController<List<Orders_Model>>();

  Stream<List<Orders_Model>> get getOrdersStream =>
      _requestedOrdersController.stream;

  StreamSubscription<QuerySnapshot?>? _subscription;

  void getRequestedOrders(String storeID) {
    try {
      final collectionRef = _firestore
          .collection('groceryStores')
          .doc(storeID)
          .collection('requestedOrders')
          .where('OrderStatus', isEqualTo: 'Requested');

      _subscription = collectionRef.snapshots().listen((querySnapshot) {
        final orderItems = querySnapshot.docs
            .map((docs) => Orders_Model.fromJson(docs.data()))
            .toList();

        _requestedOrdersController.add(orderItems);
      });
    } catch (e) {
      log("Error while fetching Orders (Error from Repository) $e");
      rethrow;
    }
  }

  Future<void> acceptCurrentOrder(String orderID) async {
    try {
      String TRXID = await _readTransactionID();
      final collectionRef = _firestore
          .collection('groceryStores')
          .doc('SMVDU101')
          .collection('requestedOrders')
          .doc(orderID);

      await collectionRef.update({'TRXID': TRXID, 'OrderStatus': 'Preparing'});
    } catch (e) {
      log('Error while accepting the Requested Order (thrown at Requested Orders Repository)');
      rethrow;
    }
  }

  Future<void> rejectCurrentOrder(String orderID) async {
    try {
      final collectionRef = _firestore
          .collection('groceryStores')
          .doc('SMVDU101')
          .collection('requestedOrders')
          .doc(orderID);

      await collectionRef.update({'OrderStatus': 'Rejected'});
    } catch (e) {
      log('Error while Rejecting the Requested Order (thrown at Requested Orders Repository)');
      rethrow;
    }
  }

  Future<String> _readTransactionID() async {
    try {
      final docRef = _firestore.collection('groceryStores').doc('SMVDU101');
      final snapshots = await docRef.get();
      if (snapshots.exists) {
        String? lastTRX_ID = await snapshots.data()!['LastTRX_ID'];
        if (lastTRX_ID == null) {
          //TODO: Make the Store ID Dynamic here not Constant!
          lastTRX_ID = "SMVDU101TRX0";
        }
        String newTRX_ID = _generateNextTransactionID(lastTRX_ID);
        await docRef.update({'LastTRX_ID': newTRX_ID});
        return newTRX_ID;
      } else {
        log("The last Transaction containing document doesn't exists!");
        return "";
      }
    } catch (e) {
      log("Exception thrown while reading last Transaction ID!!! $e");
      rethrow;
    }
  }

  String _generateNextTransactionID(String previousTransactionID) {
    // Split the previous transaction ID
    List<String> parts = previousTransactionID.split('TRX');
    if (parts.length != 2) {
      // Handle invalid input
      log("Error with the previous Transaction ID");
    }

    String prefix = parts[0]; // e.g., "SMVDU101"
    String numericPart = parts[1]; // e.g., "1"

    // Convert the numeric part to an integer and increment it
    int? numericValue = int.tryParse(numericPart);
    if (numericValue == null) {
      // Handle invalid input
      log("Error while parsing numeric part of the Last Transaction ID!!!");
    }

    // Increment the numeric value
    numericValue = numericValue! + 1;

    // Format the numeric part with leading zeros (if needed)
    String incrementedNumericPart = numericValue.toString();

    // Create the new transaction ID
    String newTransactionID = '${prefix}TRX$incrementedNumericPart';

    return newTransactionID;
  }

  void closeSubscription() {
    _subscription?.cancel();
    _requestedOrdersController.close();
  }
}
