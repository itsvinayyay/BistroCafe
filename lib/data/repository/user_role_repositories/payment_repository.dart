import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_cafe/utils/order_status.dart';

/// Repository responsible for handling payment-related operations.
class PaymentRepository {
  // Instance of Firestore for database operations.
  final _firestore = FirebaseFirestore.instance;

  /// Retrieves payment details for a specific order.
  ///
  /// Parameters:
  /// - [ordID]: The ID of the order.
  /// - [storeID]: The ID of the grocery store.
  ///
  /// Returns a Future containing a Map with transaction ID ('trxID') and total amount ('total').
  Future<Map<String, dynamic>> getDetails({
    required String ordID,
    required String storeID,
  }) async {
    try {
      // Reference to the document for the requested order.
      final collectionRef = _firestore
          .collection('groceryStores')
          .doc(storeID)
          .collection('requestedOrders')
          .doc(ordID);

      // Retrieve the document snapshot.
      DocumentSnapshot doc = await collectionRef.get();

      // Create a Map with transaction ID and total amount.
      Map<String, dynamic> tobeReturned = {
        'trxID': doc['TRXID'],
        'total': doc['Total'],
      };

      // Return the Map.
      return tobeReturned;
    } catch (e) {
      // Log and rethrow any exceptions that occur during the operation.
      log("Exception thrown while getting Transaction ID");
      rethrow;
    }
  }

  /// Marks the order status based on payment status.
  ///
  /// Parameters:
  /// - [storeID]: The ID of the grocery store.
  /// - [orderID]: The ID of the order.
  /// - [isPaid]: Boolean indicating whether the order is paid or not.
  Future<void> markOrderStatus({
    required String storeID,
    required String orderID,
    required bool isPaid,
  }) async {
    try {
      // Reference to the document for the requested order.
      DocumentReference documentReference = _firestore
          .collection('groceryStores')
          .doc(storeID)
          .collection('requestedOrders')
          .doc(orderID);

      // Update the document with the new order status and payment status.
      await documentReference.update({
        'OrderStatus': isPaid ? OrderStatus.preparing : OrderStatus.unpaid,
        'IsPaid': isPaid,
      });
    } catch (e) {
      // Log and rethrow any exceptions that occur during the operation.
      log("Exception while marking OrderStatus (Error from Payment Repository)");
      rethrow;
    }
  }
}
