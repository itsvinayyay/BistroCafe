import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_cafe/data/models/All_Orders_Models.dart';

class CurrentOrdersRepository{
  final _firestore = FirebaseFirestore.instance;
  final _currentOrdersController = StreamController<List<Orders_Model>>();

  Stream<List<Orders_Model>> get getOrdersStream =>
      _currentOrdersController.stream;

  StreamSubscription<QuerySnapshot?>? _subscription;

  void getCurrentOrders(String storeID) {
    try {
      final collectionRef = _firestore
          .collection('groceryStores')
          .doc(storeID)
          .collection('requestedOrders')
          .where('OrderStatus', isEqualTo: 'Preparing');

      _subscription = collectionRef.snapshots().listen((querySnapshot) {
        final orderItems = querySnapshot.docs
            .map((docs) => Orders_Model.fromJson(docs.data()))
            .toList();

        _currentOrdersController.add(orderItems);
      });
    } catch (e) {
      log("Error while fetching Current Orders (Error from Repository) $e");
      rethrow;
    }
  }

  Future<void> currentOrderPrepared(String trxID) async{

    try {
      final collectionRef = _firestore
          .collection('groceryStores')
          .doc('SMVDU101')
          .collection('requestedOrders')
          .doc(trxID);

      await collectionRef.update({'OrderStatus': 'Prepared'});
    } catch (e) {
      log('Error while markeing Current Order Prepared (thrown at Current Orders Repository)');
      rethrow;
    }

  }
  void closeSubscription() {
    _subscription?.cancel();
    _currentOrdersController.close();
  }
}