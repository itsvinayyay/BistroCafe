

import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_cafe/data/models/All_Orders_Models.dart';

class PastOrdersRepository{
final _firestore = FirebaseFirestore.instance;
  final _pastOrdersController = StreamController<List<Orders_Model>>();

  Stream<List<Orders_Model>> get getOrdersStream =>
      _pastOrdersController.stream;

  StreamSubscription<QuerySnapshot?>? _subscription;

  

  void getPastOrders(String storeID) {
    log('Fetching Past Orders');
    try {
      final collectionRef = _firestore
          .collection('groceryStores')
          .doc(storeID)
          .collection('requestedOrders')
          .where('OrderStatus', isEqualTo: 'Prepared');

      _subscription = collectionRef.snapshots().listen((querySnapshot) {
        final orderItems = querySnapshot.docs
            .map((docs) => Orders_Model.fromJson(docs.data()))
            .toList();

        _pastOrdersController.add(orderItems);
      });
    } catch (e) {
      log("Error while fetching Past Orders (Error from Repository) $e");
      rethrow;
    }
  }


  void closeSubscription() {
    _subscription?.cancel();
    _pastOrdersController.close();
  }
}

