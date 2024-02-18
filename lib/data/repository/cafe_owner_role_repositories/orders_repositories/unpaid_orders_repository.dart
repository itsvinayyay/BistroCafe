import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_cafe/data/models/store_order_model.dart';
import 'package:food_cafe/data/repository/common_repositories/get_formatted_date_repository.dart';
import 'package:food_cafe/utils/order_status.dart';

class UnpaidOrdersRepository {
  /// Firestore instance used for database operations.
  final _firestore = FirebaseFirestore.instance;

  /// Utility class for formatting dates.
  final FormattedDate _formattedDate = FormattedDate();

  /// Controller for managing the stream of unpaid orders.
  final _unpaidOrdersController = StreamController<List<OrderModel>>();

  /// Getter for accessing the stream of unpaid orders.
  Stream<List<OrderModel>> get getOrdersStream =>
      _unpaidOrdersController.stream;

  /// Subscription for listening to changes in the unpaid orders collection.
  StreamSubscription<QuerySnapshot?>? _subscription;

  /// Fetches and streams the unpaid orders for a specific grocery store.
  ///
  /// Parameters:
  /// - [storeID]: The identifier for the grocery store.
  void getUnpaidOrders(String storeID) {
    try {
      // Reference to the 'requestedOrders' collection with a filter for unpaid orders
      final collectionRef = _firestore
          .collection('groceryStores')
          .doc(storeID)
          .collection('requestedOrders')
          .where('OrderStatus', isEqualTo: OrderStatus.unpaid);

      // Listen to snapshots of the collection and update the stream accordingly
      _subscription = collectionRef.snapshots().listen((querySnapshot) {
        // Convert each document in the snapshot to an Orders_Model object
        final orderItems = querySnapshot.docs
            .map((docs) => OrderModel.fromJson(docs.data()))
            .toList();

        // Add the list of Orders_Model to the stream
        _unpaidOrdersController.add(orderItems);
      });
    } catch (e) {
      // Log and rethrow any errors that occur during the process
      log("Error while fetching Past Orders (Error from Repository) $e");
      rethrow;
    }
  }

  /// Marks an unpaid order as successful in the database and updates analytics.
  ///
  /// Parameters:
  /// - [orderID]: The identifier for the order.
  /// - [storeID]: The identifier for the grocery store.
  /// - [price]: The total price of the successful order.
  /// - [orderedItems]: List of ordered items with their details.
  Future<void> orderSuccess({
    required String orderID,
    required String storeID,
    required int price,
    required List<Map<String, dynamic>> orderedItems,
  }) async {
    try {
      // Reference to the specific order document in the 'requestedOrders' collection
      DocumentReference documentReference = _firestore
          .collection('groceryStores')
          .doc(storeID)
          .collection('requestedOrders')
          .doc(orderID);

      // Update order status to 'preparing' and set IsPaid to true indicating successful payment
      await documentReference
          .update({'IsPaid': true, 'OrderStatus': OrderStatus.preparing});

      // Update daily analytics for the store
      await _updateDailyAnalytics(storeID: storeID, price: price);

      // Update monthly analytics for the store based on the successful order
      await _updateMonthlyAnalytics(
          storeID: storeID,
          price: price,
          orderID: orderID,
          orderedItems: orderedItems);
    } catch (e) {
      // Log and rethrow any errors that occur during the process
      log("Exception thrown while marking Unpaid Order as Successful (Error from Unpaid Repository)");
      rethrow;
    }
  }

  /// Marks an unpaid order as failed in the database.
  ///
  /// Parameters:
  /// - [storeID]: The identifier for the grocery store.
  /// - [orderID]: The identifier for the order.
  Future<void> orderFailure(
      {required String storeID, required String orderID}) async {
    try {
      // Reference to the specific order document in the 'requestedOrders' collection
      DocumentReference documentReference = _firestore
          .collection('groceryStores')
          .doc(storeID)
          .collection('requestedOrders')
          .doc(orderID);

      // Update the order status to 'rejected' indicating payment failure
      await documentReference.update({'OrderStatus': OrderStatus.rejected});
    } catch (e) {
      // Log and rethrow any errors that occur during the process
      log("Exception thrown while marking Unpaid Order as Failure (Error from Unpaid Repository)");
      rethrow;
    }
  }

  /// Updates the daily analytics for a grocery store based on an accepted order.
  ///
  /// Parameters:
  /// - [storeID]: The identifier for the grocery store.
  /// - [price]: The total price of the accepted order.
  Future<void> _updateDailyAnalytics(
      {required String storeID, required int price}) async {
    try {
      // Get the current formatted date
      String formattedDate = _formattedDate.getCurrentDate();

      // Reference to the dailyStats document for the current date
      DocumentReference documentReference = _firestore
          .collection('groceryStores')
          .doc(storeID)
          .collection('dailyStats')
          .doc(formattedDate);

      // Update daily analytics with incremented total items and total sale
      await documentReference.update({
        'TotalItemsAccepted': FieldValue.increment(1),
        'TotalSale': FieldValue.increment(price),
      });
    } catch (e) {
      // Log and rethrow any errors that occur during the process
      log('Exception thrown while Updating Daily Analytics (Error from Requested Orders Repository)');
      rethrow;
    }
  }

  /// Updates the monthly analytics for a grocery store based on an accepted order.
  ///
  /// Parameters:
  /// - [storeID]: The identifier for the grocery store.
  /// - [price]: The total price of the accepted order.
  /// - [orderID]: The identifier for the accepted order.
  /// - [orderedItems]: List of ordered items with their details.
  Future<void> _updateMonthlyAnalytics({
    required String storeID,
    required int price,
    required String orderID,
    required List<Map<String, dynamic>> orderedItems,
  }) async {
    try {
      // Get the formatted month from the current date
      String formattedDate = _formattedDate.getMonth();

      // Reference to the monthlyStats document for the current month
      DocumentReference documentReference = _firestore
          .collection('groceryStores')
          .doc(storeID)
          .collection('monthlyStats')
          .doc(formattedDate);

      // Update monthly analytics with incremented total items and total sales
      await documentReference.update({
        'TotalItemsAccepted': FieldValue.increment(1),
        'TotalSales': FieldValue.increment(price),
      });

      // Get a list of menu item IDs and their quantities from ordered items
      List<MapEntry<String, int>> menuItemIDs =
          _getMenuItemIDs(orderedItems: orderedItems);

      // Update the ProductsSold field with the quantity for each menu item
      await Future.wait(menuItemIDs.map((entry) async {
        String fieldToUpdate = entry.key;
        int quantity = entry.value;

        await documentReference.set({
          'ProductsSold': {fieldToUpdate: FieldValue.increment(quantity)}
        }, SetOptions(merge: true));
      }));
    } catch (e) {
      // Log and rethrow any errors that occur during the process
      log('Exception thrown while Updating Monthly Analytics (Error from Requested Orders Repository)');
      rethrow;
    }
  }

  /// Extracts menu item IDs and their corresponding quantities from a list of ordered items.
  ///
  /// Parameters:
  /// - [orderedItems]: List of ordered items with their details.
  ///
  /// Returns:
  /// List of MapEntry<String, int> representing menu item IDs and quantities.
  List<MapEntry<String, int>> _getMenuItemIDs(
      {required List<Map<String, dynamic>> orderedItems}) {
    // Initialize an empty list to store menu item IDs and quantities
    List<MapEntry<String, int>> menuItemID = [];

    // Extract ItemID and Quantity from each ordered item and add to the list
    orderedItems.map((map) {
      menuItemID.add(MapEntry(map['ItemID'], map['Quantity']));
    }).toList();

    return menuItemID;
  }

  /// Closes the stream subscription and the controller to avoid memory leaks.
  void closeSubscription() {
    // Cancel the subscription to stop listening to stream updates
    _subscription?.cancel();

    // Close the stream controller
    _unpaidOrdersController.close();
  }
}
