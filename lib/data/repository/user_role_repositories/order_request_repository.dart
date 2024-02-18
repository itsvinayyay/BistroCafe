import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';



/// Repository responsible for handling the order status requests and updates.
class OrderRequestRepository {
  final _firestore = FirebaseFirestore.instance;
  final _orderStatusController = StreamController<String>();
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _subscription;

  /// Stream providing the order status updates.
  Stream<String> get orderStatusStream => _orderStatusController.stream;

  /// Start listening for order status updates.
  /// - [orderID]: The unique identifier for the order.
  /// - [storeID]: The unique identifier for the store associated with the order.
  void startListening({required String orderID, required String storeID}) {
    try {
      final collectionRef = _firestore
          .collection('groceryStores')
          .doc(storeID)
          .collection('requestedOrders')
          .doc(orderID);

      _subscription = collectionRef.snapshots().listen((documentSnapshot) {
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

  /// Close the subscription and stream controller.
  void closeSubscription() {
    _subscription?.cancel();
    _orderStatusController.close();
  }
}

