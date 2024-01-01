import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:upi_india/upi_india.dart';

class PaymentRepository {
  final _firestore = FirebaseFirestore.instance;
  final _upiIndia = UpiIndia();
  // Future<UpiResponse> initiateTransaction(
  //     {required UpiApp app,
  //     required String ordID,
  //     required String storeID}) async {
  //   try {
  //     final receivedMap = await _getDetails(ordID: ordID, storeID: storeID);
  //     String trxID = receivedMap['trxID'];
  //     int totalAmt = receivedMap['total'];
  //     //TODO: Make the receiver fields dynamic!
  //     Future<UpiResponse> _transaction =  _upiIndia.startTransaction(
  //       app: app,
  //       receiverUpiId: '7048900990@paytm',
  //       receiverName: 'Vinay Vashist',
  //       transactionRefId: trxID,
  //       transactionNote: 'Purchase of an Order',
  //       amount: totalAmt.toDouble(),
  //     );
  //   } catch (e) {
  //     log("Exception thrown while Inititaing Transaction in Payment repository");
  //     rethrow;
  //   }
  // }

  Future<Map<String, dynamic>> getDetails(
      {required String ordID, required String storeID}) async {
    try {
      final collectionRef = _firestore
          .collection('groceryStores')
          .doc(storeID)
          .collection('requestedOrders')
          .doc(ordID);
      DocumentSnapshot doc = await collectionRef.get();
      Map<String, dynamic> tobeReturned = {
        'trxID': doc['TRXID'],
        'total': doc['Total'],
      };
      return tobeReturned;
    } catch (e) {
      log("Exception thrown while getting Transaction ID");
      rethrow;
    }
  }
}
