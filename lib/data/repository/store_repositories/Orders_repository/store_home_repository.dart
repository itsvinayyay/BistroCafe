import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_cafe/data/models/All_Orders_Models.dart';

class StoreHomeRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<List<Orders_Model>> getPastOrders({required String storeID}) async {
    try {
      final querySnapshot = await _firestore
          .collection('groceryStores')
          .doc(storeID)
          .collection('requestedOrders')
          .where('OrderStatus', isEqualTo: 'Prepared')
          .orderBy('OrderID', descending: true)
          .get();

      List<Orders_Model> pastOrders =
          querySnapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
        final docs = doc.data() as Map<String, dynamic>;
        return Orders_Model.fromJson(docs);
      }).toList();

      return pastOrders;
    } catch (e) {
      log("Exception thrown while fetching Past Orders from Store Home Repository! => $e");
      rethrow;
    }
  }
}
