import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:food_cafe/data/models/All_Orders_Models.dart';
import 'package:food_cafe/data/repository/get_formatted_date_repository.dart';

class BillingRepository {
  final _firestore = FirebaseFirestore.instance;
  FormattedDate _formattedDate = FormattedDate();
  Future<String> extractCafeOwnerTokenID(String storeID) async {
    try {
      final docRef = _firestore.collection('groceryStores').doc(storeID);
      final snapshots = await docRef.get();
      String deviceToken = "";

      if (snapshots.exists) {
        deviceToken = snapshots.data()!['TokenID'];
      }

      return deviceToken;
    } catch (e) {
      log("Issue while fetching the Token ID of Cafe Owner (Error from Billing Repository)");
      rethrow;
    }
  }

  Future<String> billCheckOut({
    required String customerName,
    required String personID,
    required int totalMRP,
    required bool isDineIn,
    required bool isCash,
    required String storeID,
    required String hostelName,
    required String tokenID,
  }) async {
    try {
      List<Map<String, dynamic>> orderedItems = await _getOrders(personID);
      String? ordID = await _readOrderID(storeID);

      Timestamp mytimeStamp = Timestamp.now();

      Orders_Model requestedOrders_Model = Orders_Model(
        orderID: ordID,
        customerName: customerName,
        entryNo: personID,
        totalMRP: totalMRP,
        orderItems: orderedItems,
        time: mytimeStamp,
        isDineIn: isDineIn,
        isCash: isCash,
        isPaid: isCash ? true : false,
        storeID: storeID,
        hostelName: hostelName,
        tokenID: tokenID,
        orderStatus: 'Requested',
        trxID:
            'Null', //Since it is Requested Orders Model. Therefore, No Transaction ID is required.
      );

      if (ordID != null) {
        await _firestore
            .collection('groceryStores')
            .doc(storeID)
            .collection('requestedOrders')
            .doc(ordID)
            .set(requestedOrders_Model.toJson());
        return ordID;
      } else {
        log("Order ID is NULL!");
        return ordID.toString();
      }
    } catch (e) {
      log("Exception thrown while checking out Items (Error from Billing Repository)");
      rethrow;
    }
  }

  Future<void> updateOrderHistory(
      {required String personID, required String orderID}) async {
    try {
      DocumentReference documentReference =
          _firestore.collection('Users').doc('SMVDU$personID');

      await documentReference.update({
        'OrderIDs': FieldValue.arrayUnion([orderID])
      });
    } catch (e) {
      log("Exception thrown while updating Order History of the User (Error from Billing Repository)");
      rethrow;
    }
  }

//TODO: Work in Progress!!!
  Future<void> updateCart({required String personID}) async {
    try {
      CollectionReference collectionReference = _firestore
          .collection('Users')
          .doc('SMVDU$personID')
          .collection('carttem');

      QuerySnapshot querySnapshot = await collectionReference.get();

      WriteBatch batch = FirebaseFirestore.instance.batch();

      querySnapshot.docs.forEach((document) {
        batch.delete(document.reference);
      });
    } catch (e) {
      log("Exception thrown while updating User's Cart (Error from Billing Repository)");
      rethrow;
    }
  }

  Future<void> updateDailyAnalytics({required String storeID}) async {
    try {
      String formattedDate = _formattedDate.getCurrentDate();
      DocumentReference documentReference = _firestore
          .collection('groceryStores')
          .doc(storeID)
          .collection('dailyStats')
          .doc(formattedDate);
      DocumentSnapshot documentSnapshot = await documentReference.get();

      if (!documentSnapshot.exists) {
        documentReference.set({
          'TotalItemsAccepted': 0,
          'TotalItemsRequested': 1,
          'TotalSale': 0
        });
      } else {
        documentReference.update({
          'TotalItemsRequested': FieldValue.increment(1),
        });
      }
      log("Daily Analytics Updated!");
    } catch (e) {
      log("Exception thrown while updating Daily Analytics (Error from Billing Repository)");
      rethrow;
    }
  }


  Future<void> updateMonthlyAnalytics({required String storeID}) async {
    try {
      String formattedMonth = _formattedDate.getMonth();
      DocumentReference documentReference = _firestore
          .collection('groceryStores')
          .doc(storeID)
          .collection('monthlyStats')
          .doc(formattedMonth);
      DocumentSnapshot documentSnapshot = await documentReference.get();

      if (!documentSnapshot.exists) {
        documentReference.set({
          'ProductsSold' : [],
          'TotalItemsAccepted': 0,
          'TotalItemsRequested': 1,
          'TotalSales': 0
        });
      } else {
        documentReference.update({
          'TotalItemsRequested': FieldValue.increment(1),
        });
      }
      log("Monthly Analytics Updated!");
    } catch (e) {
      log("Exception thrown while updating Monthly Analytics (Error from Billing Repository)");
      rethrow;
    }
  }

  Future<String?> _readOrderID(String storeID) async {
    try {
      final docRef = _firestore.collection('groceryStores').doc(storeID);
      final snapshots = await docRef.get();
      if (snapshots.exists) {
        String? lastORD_ID = await snapshots.data()!['LastORD_ID'];
        if (lastORD_ID == null) {
          lastORD_ID = "SMVDU101ORD0";
        }
        String newORD_ID = _generateNextOrderID(lastORD_ID);
        await docRef.update({'LastORD_ID': newORD_ID});
        return newORD_ID;
      } else {
        print("The last Transaction containing document doesn't exists!");
        return null;
      }
    } catch (e) {
      print("Exception thrown while reading last Transaction ID!!! $e");
      return null;
    }
  }

  String _generateNextOrderID(String previousOrderID) {
    // Split the previous transaction ID
    List<String> parts = previousOrderID.split('ORD');
    if (parts.length != 2) {
      // Handle invalid input
      print("Error with the previous Order ID");
    }

    String prefix = parts[0]; // e.g., "SMVDU101"
    String numericPart = parts[1]; // e.g., "1"

    // Convert the numeric part to an integer and increment it
    int? numericValue = int.tryParse(numericPart);
    if (numericValue == null) {
      // Handle invalid input
      print("Error while parsing numeric part of the Last Order ID!!!");
    }

    // Increment the numeric value
    numericValue = numericValue! + 1;

    // Format the numeric part with leading zeros (if needed)
    String incrementedNumericPart = numericValue.toString();

    // Create the new transaction ID
    String newOrderID = '${prefix}ORD$incrementedNumericPart';

    return newOrderID;
  }

  Future<List<Map<String, dynamic>>> _getOrders(String personID) async {
    try {
      List<Map<String, dynamic>> returnedList = [];
      final querySnapShot = await _firestore
          .collection('Users')
          .doc('SMVDU$personID')
          .collection('cartitem')
          .get();
      querySnapShot.docs.forEach((doc) {
        returnedList.add(doc.data() as Map<String, dynamic>);
      });

      return returnedList;
    } catch (e) {
      print("Error fetching data: $e");
      return [];
    }
  }
}
