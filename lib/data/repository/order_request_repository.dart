import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class OrderRequestRepository {
  final _firestore = FirebaseFirestore.instance;
  final _orderStatusController = StreamController<String>();
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _subscription;

  Stream<String> get orderStatusStream => _orderStatusController.stream;

  void startListening({required String orderID, required String storeID}) {
    try {
      final collectionref = _firestore
          .collection('groceryStores')
          .doc(storeID)
          .collection('requestedOrders')
          .doc(orderID);

      _subscription = collectionref.snapshots().listen((documentSnapshot) {
        if (documentSnapshot.exists) {
          final orderStatus = documentSnapshot.get('OrderStatus') as String;
          _orderStatusController.add(orderStatus);
        }
      });
    } catch (e) {
      log("Exception thrown while listening for Order Status (thrown from Order Request Repository!)");
      rethrow;
    }
  }

  void closeSubscription() {
    _subscription?.cancel();
    _orderStatusController.close();
  }
}
