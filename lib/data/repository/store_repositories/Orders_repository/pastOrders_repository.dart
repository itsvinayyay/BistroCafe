import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_cafe/data/models/All_Orders_Models.dart';
import 'package:food_cafe/utils/payment_status.dart';

class PastOrdersRepository {
  final _firestore = FirebaseFirestore.instance;
  

  Future<List<Orders_Model>> getPastOrders({required String storeID}) async {
    log('Fetching Past Orders');
    try {
      final collectionRef = _firestore
          .collection('groceryStores')
          .doc(storeID)
          .collection('requestedOrders')
          .where('OrderStatus',
              whereIn: [OrderStatus.prepared, OrderStatus.rejected]);

      QuerySnapshot querySnapshot = await collectionRef.get();

      return querySnapshot.docs
          .map((docs) => Orders_Model.fromJson(docs.data() as Map<String, dynamic>))
          .toList();

          
    } catch (e) {
      log("Error while fetching Past Orders (Error from Repository) $e");
      rethrow;
    }
  }

  
}
