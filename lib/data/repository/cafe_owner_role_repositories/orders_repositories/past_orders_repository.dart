import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_cafe/data/models/store_order_model.dart';
import 'package:food_cafe/utils/order_status.dart';

/// Repository responsible for managing and retrieving past orders data.
class PastOrdersRepository {
  // Firestore instance used for database operations.
  final _firestore = FirebaseFirestore.instance;

  /// Retrieves past orders for a specific grocery store.
  ///
  /// Parameters:
  /// - [storeID]: The identifier for the grocery store.
  Future<List<OrderModel>> getPastOrders({required String storeID}) async {
    try {
      // Reference to the 'requestedOrders' collection with a filter for prepared and rejected orders.
      final collectionRef = _firestore
          .collection('groceryStores')
          .doc(storeID)
          .collection('requestedOrders')
          .where('OrderStatus', whereIn: [
        OrderStatus.prepared,
        OrderStatus.rejected
      ]).orderBy('OrderID', descending: true);

      // Get the query snapshot from the collection.
      QuerySnapshot querySnapshot = await collectionRef.get();

      // Map each document in the snapshot to an Orders_Model object and return the list.
      return querySnapshot.docs
          .map((docs) =>
              OrderModel.fromJson(docs.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Log and rethrow any errors that occur during the process.
      log("Error while fetching Past Orders (Error from Repository) $e");
      rethrow;
    }
  }
}
