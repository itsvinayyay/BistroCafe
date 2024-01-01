import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_cafe/data/models/CartScreen_FoodCard.dart';

class FetchCartItems {
  final _firestore = FirebaseFirestore.instance;
  final _cartItemsController = StreamController<List<Cart_FoodCard_Model>>();

  Stream<List<Cart_FoodCard_Model>> get cartItemsStream =>
      _cartItemsController.stream;

  StreamSubscription<QuerySnapshot?>? _subscription;

  void startListening(String entryNo) {
    try {
      final collectionRef = _firestore
          .collection('Users')
          .doc('SMVDU$entryNo')
          .collection('cartitem');

      _subscription = collectionRef.snapshots().listen((querySnapshot) {
        final cartItems = querySnapshot.docs
            .map((doc) => Cart_FoodCard_Model.fromJson(doc.data()))
            .toList();

        _cartItemsController.add(cartItems);
      });
    } catch (e) {
      rethrow;
    }
  }

  void closeSubscription() {
    _subscription?.cancel();
    _cartItemsController.close();
  }
}
