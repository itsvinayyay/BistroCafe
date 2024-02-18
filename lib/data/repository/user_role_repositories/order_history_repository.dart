import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_cafe/data/models/store_order_model.dart';

///Repository to handle all interactions with Order History.
class OrderHistoryRepository {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Retrieves the order history for a specific person identified by their unique [personID].
  ///
  /// Parameters:
  /// - [personID]: The unique identifier for the person whose order history is to be retrieved.
  ///
  /// Returns:
  /// A [Future] containing a [List] of [OrderModel] representing the order history of the person.
  Future<List<OrderModel>> getOrderHistory(
      {required String personID, required String storeID}) async {
    try {
      // Reference to the collection of requested orders for a specific grocery store.
      CollectionReference collectionReference = _firestore
          .collection('groceryStores')
          .doc(storeID)
          .collection('requestedOrders');

      // Retrieve documents from the collection where 'EntryNo' is equal to 'personID'.
      QuerySnapshot querySnapshot =
          await collectionReference.where('EntryNo', isEqualTo: personID).get();

      // Initialize an empty list to store OrderModel instances.
      List<OrderModel> orderModelList = [];

      // Map each document to an OrderModel and add it to the list.
      querySnapshot.docs.map((doc) {
        orderModelList
            .add(OrderModel.fromJson(doc.data() as Map<String, dynamic>));
      }).toList();

      // Return the list of OrderModel instances.
      return orderModelList;
    } catch (e) {
      // Log and rethrow any exceptions that occur during the order history retrieval.
      log('Exception while fetching Order History (Error from Order History Repository)');
      rethrow;
    }
  }
}
