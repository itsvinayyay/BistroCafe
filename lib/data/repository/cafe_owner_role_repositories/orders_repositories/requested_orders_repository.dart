import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_cafe/data/models/store_order_model.dart';
import 'package:food_cafe/data/repository/common_repositories/get_formatted_date_repository.dart';
import 'package:food_cafe/utils/order_status.dart';

///Repository to handle all communications regarding Requested Orders
class RequestedOrdersRepository {
  /// Firestore instance used for database operations.
  final _firestore = FirebaseFirestore.instance;

  /// Utility class for formatting dates.
  final FormattedDate _formattedDate = FormattedDate();

  /// Controller for managing the stream of requested orders.
  final _requestedOrdersController = StreamController<List<OrderModel>>();

  /// Getter for accessing the stream of requested orders.
  Stream<List<OrderModel>> get getOrdersStream =>
      _requestedOrdersController.stream;

  /// Subscription for listening to changes in the requested orders collection.
  StreamSubscription<QuerySnapshot?>? _subscription;

  /// Fetches and streams the requested orders for a specific grocery store.
  ///
  /// Parameters:
  /// - [storeID]: The identifier for the grocery store.
  void getRequestedOrders(String storeID) {
    try {
      // Reference to the 'requestedOrders' collection with a filter for orders in 'requested' status
      final collectionRef = _firestore
          .collection('groceryStores')
          .doc(storeID)
          .collection('requestedOrders')
          .where('OrderStatus', isEqualTo: OrderStatus.requested);

      // Listen to snapshots of the collection and update the stream accordingly
      _subscription = collectionRef.snapshots().listen((querySnapshot) {
        // Convert each document in the snapshot to an Orders_Model object
        final orderItems = querySnapshot.docs
            .map((docs) => OrderModel.fromJson(docs.data()))
            .toList();

        // Add the list of Orders_Model to the stream
        _requestedOrdersController.add(orderItems);
      });
    } catch (e) {
      // Log and rethrow any errors that occur during the process
      log("Error while fetching Requested Orders (Error from Requested Orders Repository)=> $e");
      rethrow;
    }
  }

  /// Asynchronous function to accept a current order in a grocery store.
  /// This function updates the order status, transaction ID, and analytics based on payment status.
  ///
  /// Parameters:
  /// - [orderID]: The unique identifier for the order.
  /// - [isPaid]: A boolean indicating whether the order has been paid.
  /// - [storeID]: The identifier for the grocery store.
  /// - [price]: The total price of the order.
  /// - [orderedItems]: A list of maps representing the ordered items with their details.
  ///
  /// Returns: A Future<void> indicating the completion of the acceptance process.
  Future<void> acceptCurrentOrder({
    required String orderID,
    required bool isPaid,
    required String storeID,
    required int price,
    required List<Map<String, dynamic>> orderedItems,
  }) async {
    try {
      // Fetch the transaction ID from a private method
      String trxID = await _readTransactionID();

      // Reference to the specific order document in the 'requestedOrders' collection
      final collectionRef = _firestore
          .collection('groceryStores')
          .doc(storeID)
          .collection('requestedOrders')
          .doc(orderID);

      // Update order information based on payment status
      if (isPaid) {
        // If paid, update the transaction ID and set the order status to 'preparing'
        await collectionRef
            .update({'TRXID': trxID, 'OrderStatus': OrderStatus.preparing});

        // Update daily and monthly analytics for the store
        await _updateDailyAnalytics(storeID: storeID, price: price);
        await _updateMonthlyAnalytics(
            storeID: storeID,
            price: price,
            orderID: orderID,
            orderedItems: orderedItems);
      } else {
        // If unpaid, update the transaction ID and set the order status to 'unpaid'
        await collectionRef
            .update({'TRXID': trxID, 'OrderStatus': OrderStatus.unpaid});
      }
    } catch (e) {
      // Log and rethrow any errors that occur during the process
      log('Error while accepting the Requested Order (thrown at Requested Orders Repository)');
      rethrow;
    }
  }

  /// Rejects the requested order with the specified order ID.
  ///
  /// This asynchronous method updates the 'OrderStatus' field of the requested
  /// order document in Firestore to 'Rejected'. It uses the order ID to locate
  /// the specific document in the 'requestedOrders' collection for the grocery
  /// store with ID 'SMVDU101'. If successful, the order status is updated, and
  /// the rejection process is complete. If an error occurs during the update,
  /// the method logs an error and rethrows the exception.
  ///
  /// Parameters:
  /// - [orderID]: The unique identifier of the requested order to be rejected.
  ///
  /// Example:
  /// ```dart
  /// await rejectCurrentOrder('exampleOrderID');
  /// ```
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

  /// Updates the daily analytics in Firestore for the specified store.
  ///
  /// This method increments the total items accepted and total sale fields for the given store
  /// on the current date.
  ///
  /// Throws an exception if there is an error during the update process.
  Future<void> _updateDailyAnalytics({
    required String storeID,
    required int price,
  }) async {
    try {
      // Get the formatted current date
      String formattedDate = _formattedDate.getCurrentDate();

      // Create a reference to the dailyStats document for the current date
      DocumentReference documentReference = _firestore
          .collection('groceryStores')
          .doc(storeID)
          .collection('dailyStats')
          .doc(formattedDate);

      // Update the document with increments for total items accepted and total sale
      await documentReference.update({
        'TotalItemsAccepted': FieldValue.increment(1),
        'TotalSale': FieldValue.increment(price),
      });
    } catch (e) {
      log('Exception thrown while updating Daily Analytics (Error from Requested Orders Repository)');
      rethrow;
    }
  }

  /// Updates the monthly analytics in Firestore for the specified store.
  ///
  /// This method increments the total items accepted, total sales, and individual product
  /// quantities sold fields for the given store on the current month.
  ///
  /// Throws an exception if there is an error during the update process.
  Future<void> _updateMonthlyAnalytics({
    required String storeID,
    required int price,
    required String orderID,
    required List<Map<String, dynamic>> orderedItems,
  }) async {
    try {
      // Get the formatted current month
      String formattedDate = _formattedDate.getMonth();

      // Create a reference to the monthlyStats document for the current month
      DocumentReference documentReference = _firestore
          .collection('groceryStores')
          .doc(storeID)
          .collection('monthlyStats')
          .doc(formattedDate);

      // Update the document with increments for total items accepted and total sales
      await documentReference.update({
        'TotalItemsAccepted': FieldValue.increment(1),
        'TotalSales': FieldValue.increment(price),
      });

      // Get a list of product IDs and their quantities from the ordered items
      List<MapEntry<String, int>> menuItemIDs =
          _getMenuItemIDs(orderedItems: orderedItems);

      // Update the document with increments for individual product quantities sold
      await Future.wait(menuItemIDs.map((entry) async {
        String fieldToUpdate = entry.key;
        int quantity = entry.value;

        await documentReference.set({
          'ProductsSold': {fieldToUpdate: FieldValue.increment(quantity)}
        }, SetOptions(merge: true));
      }));
    } catch (e) {
      log('Exception thrown while updating Monthly Analytics (Error from Requested Orders Repository)');
      rethrow;
    }
  }

  /// Extracts the item IDs and their corresponding quantities from a list of ordered items.
  ///
  /// This method takes a list of ordered items, where each item is represented as a map
  /// containing 'ItemID' and 'Quantity', and returns a list of map entries with the item ID
  /// as the key and the quantity as the value.
  ///
  /// Example:
  /// ```
  /// List<Map<String, dynamic>> orderedItems = [
  ///   {'ItemID': '123', 'Quantity': 2},
  ///   {'ItemID': '456', 'Quantity': 1},
  /// ];
  /// List<MapEntry<String, int>> result = _getMenuItemIDs(orderedItems: orderedItems); // Result: [MapEntry('123', 2), MapEntry('456', 1)]
  /// ```
  List<MapEntry<String, int>> _getMenuItemIDs(
      {required List<Map<String, dynamic>> orderedItems}) {
    List<MapEntry<String, int>> menuItemID = [];
    orderedItems.map((map) {
      menuItemID.add(MapEntry(map['ItemID'], map['Quantity']));
    }).toList();

    return menuItemID;
  }

  /// Reads and generates the next transaction ID for a grocery store.
  ///
  /// This asynchronous method retrieves the document reference for the specified
  /// grocery store ('SMVDU101') from the 'groceryStores' collection in Firestore.
  /// It checks if the document exists, and if it does, it retrieves the last
  /// transaction ID ('LastTRX_ID') from the document data. If the last transaction
  /// ID is null, it initializes it to 'SMVDU101TRX0'. The method then generates the
  /// next transaction ID using the helper method '_generateNextTransactionID'.
  /// After generating the new transaction ID, it updates the Firestore document
  /// with the new value. If the document doesn't exist, it logs an error and
  /// returns an empty string.
  ///
  /// Returns the generated transaction ID.
  ///
  /// Example:
  /// ```dart
  /// String result = await _readTransactionID();
  /// print(result); // Result: 'SMVDU101TRX1' (or the next available transaction ID)
  /// ```
  Future<String> _readTransactionID() async {
    try {
      final docRef = _firestore.collection('groceryStores').doc('SMVDU101');
      final snapshots = await docRef.get();
      if (snapshots.exists) {
        String? lastTrxID = await snapshots.data()!['LastTRX_ID'];
        lastTrxID ??= "SMVDU101TRX0";
        String newTrxID = _generateNextTransactionID(lastTrxID);
        await docRef.update({'LastTRX_ID': newTrxID});
        return newTrxID;
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
