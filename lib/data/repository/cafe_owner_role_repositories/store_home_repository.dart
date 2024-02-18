import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_cafe/data/models/store_order_model.dart';

/// Repository class responsible for handling data related to past orders in the store's home screen.
class StoreHomeRepository {
  final _firestore = FirebaseFirestore.instance;

  /// Fetches a list of past orders for the specified store ID with 'Prepared' status, limiting to the latest 5 orders.
  /// Throws an exception in case of any issues during the retrieval process.
  Future<List<OrderModel>> getPastOrders({required String storeID}) async {
    try {
      // Query to retrieve past orders with 'Prepared' status, ordered by OrderID in descending order, limited to 5.
      final querySnapshot = await _firestore
          .collection('groceryStores')
          .doc(storeID)
          .collection('requestedOrders')
          .where('OrderStatus', isEqualTo: 'Prepared')
          .orderBy('OrderID', descending: true)
          .limit(5)
          .get();

      // Mapping retrieved documents to Orders_Model objects.
      List<OrderModel> pastOrders =
          querySnapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
        final docs = doc.data() as Map<String, dynamic>;
        return OrderModel.fromJson(docs);
      }).toList();

      return pastOrders;
    } catch (e) {
      log("Exception thrown while fetching Past Orders from Store Home Repository! => $e");
      rethrow; // Re-throwing the exception to propagate it to the calling code.
    }
  }
}
