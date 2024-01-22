import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_cafe/data/models/All_Orders_Models.dart';
import 'package:food_cafe/data/repository/get_formatted_date_repository.dart';
import 'package:food_cafe/utils/payment_status.dart';

class UnpaidOrdersRepository {
  final _firestore = FirebaseFirestore.instance;
  FormattedDate _formattedDate = FormattedDate();
  final _unpaidOrdersController = StreamController<List<Orders_Model>>();

  Stream<List<Orders_Model>> get getOrdersStream =>
      _unpaidOrdersController.stream;

  StreamSubscription<QuerySnapshot?>? _subscription;

  void getUnpaidOrders(String storeID) {
    log('Fetching Unpaid Orders');
    try {
      final collectionRef = _firestore
          .collection('groceryStores')
          .doc(storeID)
          .collection('requestedOrders')
          .where('OrderStatus', isEqualTo: OrderStatus.unpaid);

      _subscription = collectionRef.snapshots().listen((querySnapshot) {
        final orderItems = querySnapshot.docs
            .map((docs) => Orders_Model.fromJson(docs.data()))
            .toList();

        _unpaidOrdersController.add(orderItems);
      });
    } catch (e) {
      log("Error while fetching Past Orders (Error from Repository) $e");
      rethrow;
    }
  }

  Future<void> orderSuccess(
      {required String orderID,
      required String storeID,
      required int price,
      required List<Map<String, dynamic>> orderedItems}) async {
    try {
      DocumentReference documentReference = _firestore
          .collection('groceryStores')
          .doc(storeID)
          .collection('requestedOrders')
          .doc(orderID);

      await documentReference
          .update({'IsPaid': true, 'OrderStatus': OrderStatus.preparing});
      await _updateDailyAnalytics(storeID: storeID, price: price);
      await _updateMonthlyAnalytics(
          storeID: storeID,
          price: price,
          orderID: orderID,
          orderedItems: orderedItems);
    } catch (e) {
      log("Exception thrown while marking Unpaid Order as Successful (Error from Unpaid Repository)");
      rethrow;
    }
  }

  Future<void> orderFailure(
      {required String storeID, required String orderID}) async {
    try {
      DocumentReference documentReference = _firestore
          .collection('groceryStores')
          .doc(storeID)
          .collection('requestedOrders')
          .doc(orderID);

      await documentReference.update({'OrderStatus': OrderStatus.rejected});
    } catch (e) {
      log("Exception thrown while marking Unpaid Order as Failure (Error from Unpaid Repository)");
      rethrow;
    }
  }

  Future<void> _updateDailyAnalytics(
      {required String storeID, required int price}) async {
    try {
      String formattedDate = _formattedDate.getCurrentDate();
      DocumentReference documentReference = _firestore
          .collection('groceryStores')
          .doc(storeID)
          .collection('dailyStats')
          .doc(formattedDate);
      await documentReference.update({
        'TotalItemsAccepted': FieldValue.increment(1),
        'TotalSale': FieldValue.increment(price),
      });
    } catch (e) {
      log('Exception thrown while Updating Daily Analytics (Error from Requested Orders Repository)');
      rethrow;
    }
  }

  Future<void> _updateMonthlyAnalytics(
      {required String storeID,
      required int price,
      required String orderID,
      required List<Map<String, dynamic>> orderedItems}) async {
    try {
      String formattedDate = _formattedDate.getMonth();
      DocumentReference documentReference = _firestore
          .collection('groceryStores')
          .doc(storeID)
          .collection('monthlyStats')
          .doc(formattedDate);
      await documentReference.update({
        'TotalItemsAccepted': FieldValue.increment(1),
        'TotalSales': FieldValue.increment(price),
      });

      List<MapEntry<String, int>> menuItemIDs =
          _getMenuItemIDs(orderedItems: orderedItems);

      await Future.wait(menuItemIDs.map((entry) async {
        String fieldToUpdate = entry.key;
        int quantity = entry.value;

        await documentReference.set({
          'ProductsSold': {fieldToUpdate: FieldValue.increment(quantity)}
        }, SetOptions(merge: true));
      }));
    } catch (e) {
      log('Exception thrown while Updating Monthly Analytics (Error from Requested Orders Repository)');
      rethrow;
    }
  }

  List<MapEntry<String, int>> _getMenuItemIDs(
      {required List<Map<String, dynamic>> orderedItems}) {
    List<MapEntry<String, int>> menuItemID = [];
    orderedItems.map((map) {
      menuItemID.add(MapEntry(map['ItemID'], map['Quantity']));
    }).toList();

    return menuItemID;
  }

  void closeSubscription() {
    _subscription?.cancel();
    _unpaidOrdersController.close();
  }
}
