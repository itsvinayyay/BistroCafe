import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_cafe/data/models/user_cart_model.dart';

/// Repository class responsible for managing cart display-related operations.
class CartDisplayRepository {
  final _firestore = FirebaseFirestore.instance;
  final _cartItemsController = StreamController<List<CartModel>>();

  /// Stream that emits a list of cart items.
  Stream<List<CartModel>> get cartItemsStream => _cartItemsController.stream;

  StreamSubscription<QuerySnapshot?>? _subscription;

  /// Starts listening for changes in the user's cart items.
  ///
  /// Parameters:
  /// - [entryNo]: The unique identifier of the user whose cart items are being listened to.
  void startListening(String entryNo) {
    try {
      final collectionRef = _firestore
          .collection('Users')
          .doc('SMVDU$entryNo')
          .collection('cartitem');

      _subscription = collectionRef.snapshots().listen((querySnapshot) {
        final cartItems = querySnapshot.docs
            .map(
                (doc) => CartModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList();

        _cartItemsController.add(cartItems);
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Closes the subscription to stop listening for cart item changes.
  void closeSubscription() {
    _subscription?.cancel();
    _cartItemsController.close();
  }
}
