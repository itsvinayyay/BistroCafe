import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/data/models/All_Orders_Models.dart';


class OrdersTabCubit extends Cubit<int>{
  OrdersTabCubit() : super(0);

  void toggleTab(int tabNumber){
    emit(tabNumber);
  }
}

class PastOrdersCubit extends Cubit<List<PastOrders_Model>>{
  PastOrdersCubit() : super([]);

  final _firestore = FirebaseFirestore.instance;
  StreamSubscription<QuerySnapshot>? _subscription;

  void startListening(String storeID) {
    final collectionRef = _firestore
        .collection('groceryStores')
        .doc(storeID)
        .collection('pastOrders');
    _subscription = collectionRef.snapshots().listen((snapshots) {
      final pastOrders = snapshots.docs
          .map((doc) => PastOrders_Model.fromJson(doc.data()))
          .toList();
      emit(pastOrders);
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

}

class CurrentOrdersCubit extends Cubit<List<CurrentOrders_Model>>{
  CurrentOrdersCubit() : super([]);

  final _firestore = FirebaseFirestore.instance;
  StreamSubscription<QuerySnapshot>? _subscription;

  void startListening(String storeID) {
    final collectionRef = _firestore
        .collection('groceryStores')
        .doc(storeID)
        .collection('currentOrders');
    _subscription = collectionRef.snapshots().listen((snapshots) {
      final currentOrders = snapshots.docs
          .map((doc) => CurrentOrders_Model.fromJson(doc.data()))
          .toList();
      emit(currentOrders);
    });



  }

  Future<void> currentOrder_prepared(String trxID)async{
    final currentOrderRef = _firestore.collection('groceryStores').doc('SMVDU101').collection('currentOrders').doc(trxID);
    final pastOrderRef = _firestore.collection('groceryStores').doc('SMVDU101').collection('pastOrders').doc(trxID);

    try{
      final currentOrderSnapshots = await currentOrderRef.get();

      if(currentOrderSnapshots.exists){
        final currentOrderData = currentOrderSnapshots.data();

        //Adding the Array of maps as a new subcollection in PastOrders collection
        final orderedItemsRef = pastOrderRef.collection('orderedItems');
        for(final menuItems in currentOrderData!['MenuItems']){
          final itemID = menuItems['ItemID'];
          await orderedItemsRef.doc(itemID).set(menuItems);
        }

        //Removing MenuItems (Array of maps) and copying all the fields

        currentOrderData.remove('MenuItems');
        await pastOrderRef.set(currentOrderData);

        //Deleting the document from currentOrders collection

        await currentOrderRef.delete();

      }
      else{
        print("The document do not exists in currentOrder!!!!");
      }

    }
    catch(e){
      print("Exception thrown while pressing PREPARED button!!!! $e");
    }
  }



  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

}

class RequestedOrdersCubit extends Cubit<List<RequestedOrders_Model>> {
  RequestedOrdersCubit() : super([]);

  final _firestore = FirebaseFirestore.instance;
  StreamSubscription<QuerySnapshot>? _subscription;

  void startListening(String storeID) {
    print("Started Listening for requestOrders!");
    final collectionRef = _firestore
        .collection('groceryStores')
        .doc(storeID)
        .collection('requestedOrders');
    _subscription = collectionRef.snapshots().listen((snapshots) {
      final requestedOrders = snapshots.docs
          .map((doc) => RequestedOrders_Model.fromJson(doc.data()))
          .toList();
      print(requestedOrders.toString());
      emit(requestedOrders);
    });
  }

  Future<void> accept_requested_Order(String orderID) async {
    String? TRXID = await readTransactionID();
    if (TRXID != null) {
      final requestedRef = _firestore
          .collection('groceryStores')
          .doc('SMVDU101')
          .collection('requestedOrders')
          .doc(orderID);
      final currentRef = _firestore
          .collection('groceryStores')
          .doc('SMVDU101')
          .collection('currentOrders')
          .doc(TRXID);

      try {
        DocumentSnapshot snapshot = await requestedRef.get();
        if (snapshot.exists) {
          await currentRef.set(snapshot.data() as Map<String, dynamic>);

          await currentRef.update({'TRXID' : TRXID});

          await requestedRef.delete();
        } else {
          print("No such document exists in requested Orders subcollection!!!");
        }
      } catch (e) {
        print(
            "Exception thrown while getting documnets from Requested Orders Subcollection!! $e");
      }
    }
  }

  Future<void> reject_requested_order(String orderID) async{
    final requestedRef = _firestore
        .collection('groceryStores')
        .doc('SMVDU101')
        .collection('requestedOrders')
        .doc(orderID);
    try{
      await requestedRef.delete();
    }
    catch(e){
      print("exception thrown while rejecting the order!!!! $e");
    }
  }

  Future<String?> readTransactionID() async {
    try {
      final docRef = _firestore.collection('groceryStores').doc('SMVDU101');
      final snapshots = await docRef.get();
      if (snapshots.exists) {
        String? lastTRX_ID = await snapshots.data()!['LastTRX_ID'];
        if(lastTRX_ID == null){
          //TODO: Make the Store ID Dynamic here not Constant!
          lastTRX_ID = "SMVDU101TRX0";
        }
        String newTRX_ID = _generateNextTransactionID(lastTRX_ID!);
        await docRef.update({'LastTRX_ID': newTRX_ID});
        return newTRX_ID;
      } else {
        print("The last Transaction containing document doesn't exists!");
        return null;
      }
    } catch (e) {
      print("Exception thrown while reading last Transaction ID!!! $e");
      return null;
    }
  }

  String _generateNextTransactionID(String previousTransactionID) {
    // Split the previous transaction ID
    List<String> parts = previousTransactionID.split('TRX');
    if (parts.length != 2) {
      // Handle invalid input
      print("Error with the previous Transaction ID");
    }

    String prefix = parts[0]; // e.g., "SMVDU101"
    String numericPart = parts[1]; // e.g., "1"

    // Convert the numeric part to an integer and increment it
    int? numericValue = int.tryParse(numericPart);
    if (numericValue == null) {
      // Handle invalid input
      print("Error while parsing numeric part of the Last Transaction ID!!!");
    }

    // Increment the numeric value
    numericValue = numericValue! + 1;

    // Format the numeric part with leading zeros (if needed)
    String incrementedNumericPart = numericValue.toString();

    // Create the new transaction ID
    String newTransactionID = '${prefix}TRX$incrementedNumericPart';

    return newTransactionID;
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
