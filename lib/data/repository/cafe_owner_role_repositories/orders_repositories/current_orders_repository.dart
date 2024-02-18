import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_cafe/data/models/store_order_model.dart';

/// Repository responsible for managing and retrieving current orders data.
class CurrentOrdersRepository {
  // Firestore instance used for database operations.
  final _firestore = FirebaseFirestore.instance;

  // Controller for managing the stream of current orders.
  final _currentOrdersController = StreamController<List<OrderModel>>();

  // Getter for accessing the stream of current orders.
  Stream<List<OrderModel>> get getOrdersStream =>
      _currentOrdersController.stream;

  // Subscription for listening to changes in the current orders collection.
  StreamSubscription<QuerySnapshot?>? _subscription;

  /// Fetches and streams the current orders for a specific grocery store.
  ///
  /// Parameters:
  /// - [storeID]: The identifier for the grocery store.
  void getCurrentOrders(String storeID) {
    try {
      // Reference to the 'requestedOrders' collection with a filter for orders being prepared.
      final collectionRef = _firestore
          .collection('groceryStores')
          .doc(storeID)
          .collection('requestedOrders')
          .where('OrderStatus', isEqualTo: 'Preparing');

      // Listen to snapshots of the collection and update the stream accordingly.
      _subscription = collectionRef.snapshots().listen((querySnapshot) {
        // Convert each document in the snapshot to an Orders_Model object.
        final orderItems = querySnapshot.docs
            .map((docs) => OrderModel.fromJson(docs.data()))
            .toList();

        // Add the list of Orders_Model to the stream.
        _currentOrdersController.add(orderItems);
      });
    } catch (e) {
      // Log and rethrow any errors that occur during the process.
      log("Error while fetching Current Orders (Error from Repository) $e");
      rethrow;
    }
  }

  /// Marks a current order as prepared in the database.
  ///
  /// Parameters:
  /// - [trxID]: The identifier for the current order.
  Future<void> currentOrderPrepared(String trxID) async {
    try {
      // Reference to the specific order document in the 'requestedOrders' collection.
      final collectionRef = _firestore
          .collection('groceryStores')
          .doc('SMVDU101')
          .collection('requestedOrders')
          .doc(trxID);

      // Update the order status to 'Prepared'.
      await collectionRef.update({'OrderStatus': 'Prepared'});
    } catch (e) {
      // Log and rethrow any errors that occur during the process.
      log('Error while marking Current Order Prepared (thrown at Current Orders Repository)');
      rethrow;
    }
  }

  /// Closes the stream subscription and the controller to avoid memory leaks.
  void closeSubscription() {
    // Cancel the subscription to stop listening to stream updates.
    _subscription?.cancel();

    // Close the stream controller.
    _currentOrdersController.close();
  }
}
