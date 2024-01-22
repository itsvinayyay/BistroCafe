import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_cafe/data/models/All_Orders_Models.dart';
import 'package:food_cafe/data/repository/get_formatted_date_repository.dart';
import 'package:food_cafe/utils/payment_status.dart';

class RequestedOrdersRepository {
  final _firestore = FirebaseFirestore.instance;
  FormattedDate _formattedDate = FormattedDate();
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
          .where('OrderStatus', isEqualTo: OrderStatus.requested);

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

  Future<void> acceptCurrentOrder(
      {required String orderID,
      required bool isPaid,
      required String storeID,
      required int price,
      required List<Map<String, dynamic>> orderedItems}) async {
    try {
      String TRXID = await _readTransactionID();
      final collectionRef = _firestore
          .collection('groceryStores')
          .doc('SMVDU101')
          .collection('requestedOrders')
          .doc(orderID);

      if (isPaid) {
        await collectionRef
            .update({'TRXID': TRXID, 'OrderStatus': OrderStatus.preparing});
        await _updateDailyAnalytics(storeID: storeID, price: price);
        await _updateMonthlyAnalytics(
            storeID: storeID,
            price: price,
            orderID: orderID,
            orderedItems: orderedItems);
      } else {
        await collectionRef
            .update({'TRXID': TRXID, 'OrderStatus': OrderStatus.unpaid});
      }
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

  Future<void> _updateDailyAnalytics(
      {required String storeID, required int price}) async {
    try {
      String formattedDate = _formattedDate.getCurrentDate();
      DocumentReference documentReference = _firestore
          .collection('groceryStores')
          .doc(storeID)
          .collection('dailyStats')
          .doc(formattedDate);
      await documentReference.update({
        'TotalItemsAccepted': FieldValue.increment(1),
        'TotalSale': FieldValue.increment(price),
      });
    } catch (e) {
      log('Exception thrown while Updating Daily Analytics (Error from Requested Orders Repository)');
      rethrow;
    }
  }

  Future<void> _updateMonthlyAnalytics(
      {required String storeID,
      required int price,
      required String orderID,
      required List<Map<String, dynamic>> orderedItems}) async {
    try {
      String formattedDate = _formattedDate.getMonth();
      DocumentReference documentReference = _firestore
          .collection('groceryStores')
          .doc(storeID)
          .collection('monthlyStats')
          .doc(formattedDate);
      await documentReference.update({
        'TotalItemsAccepted': FieldValue.increment(1),
        'TotalSales': FieldValue.increment(price),
      });

      List<MapEntry<String, int>> menuItemIDs =
          _getMenuItemIDs(orderedItems: orderedItems);

      await Future.wait(menuItemIDs.map((entry) async {
        String fieldToUpdate = entry.key;
        int quantity = entry.value;

        await documentReference.set({
          'ProductsSold': {fieldToUpdate: FieldValue.increment(quantity)}
        }, SetOptions(merge: true));
      }));
    } catch (e) {
      log('Exception thrown while Updating Monthly Analytics (Error from Requested Orders Repository)');
      rethrow;
    }
  }

  List<MapEntry<String, int>> _getMenuItemIDs(
      {required List<Map<String, dynamic>> orderedItems}) {
    List<MapEntry<String, int>> menuItemID = [];
    orderedItems.map((map) {
      menuItemID.add(MapEntry(map['ItemID'], map['Quantity']));
    }).toList();

    

    return menuItemID;
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
