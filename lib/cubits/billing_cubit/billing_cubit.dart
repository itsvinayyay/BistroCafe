import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/billing_cubit/billing_state.dart';
import 'package:food_cafe/data/models/All_Orders_Models.dart';
import 'package:food_cafe/screens/store_screens/store_AddMenuItems.dart';

class BillingHostelCubit extends Cubit<int> {
  BillingHostelCubit() : super(0);

  void updateHostel(int x) {
    emit(x);
  }
}

class BillingDineSelectionCubit extends Cubit<bool> {
  BillingDineSelectionCubit() : super(true);

  void toggleDineIn(bool isDineIn) {
    emit(isDineIn);
  }
}

class BillingPaymentCubit extends Cubit<bool> {
  BillingPaymentCubit() : super(true);

  void togglePaymentMethod(bool isCOD) {
    emit(isCOD);
  }
}

class BillingCubit extends Cubit<BillingState> {
  BillingCubit() : super(LoadingState());

  final _firestore = FirebaseFirestore.instance;
  int subTotal = 0;

  Future<void> calculateSubtotal(String userID, bool isDineInEnabled) async {
    if (subTotal == 0) {
      final collectionRef = _firestore
          .collection('Users')
          .doc('SMVDU$userID')
          .collection('cartitem');
      final snapshot = await collectionRef.get();

      try {
        for (var docs in snapshot.docs) {
          int mrp = docs['Price'];
          int quantity = docs['Quantity'];
          subTotal += mrp * quantity;
        }
      } catch (e) {
        print("Error fetching subTotal $e");
      }
    }

    int total = isDineInEnabled == true ? subTotal : subTotal + 10;
    emit(BillLoadedState(subTotal, total));
  }
}

class BillingCheckOutCubit extends Cubit<BillingCheckoutState> {
  BillingCheckOutCubit() : super(BillingCheckoutInitialState());

  final _firestore = FirebaseFirestore.instance;

  void billingCheckout(
      {required String customerName, required String personID, required int totalMRP, required bool isDineIn, required bool isCash, required String storeID, required String hostelName}) async {
    emit(BillingCheckoutLoadingState());


    try {
      List<Map<String, dynamic>> orderedItems = await getOrders(personID);
      String? ordID = await readOrderID(storeID);

      Timestamp mytimeStamp = Timestamp.now();

      RequestedOrders_Model requestedOrders_Model = RequestedOrders_Model(
        orderID: ordID,
        customerName: customerName,
        entryNo: personID,
        totalMRP: totalMRP,
        orderItems: orderedItems,
        time: mytimeStamp,
        isDineIn: isDineIn,
        isCash: isCash,
        storeID: storeID,
          hostelName: hostelName,
      );

      if (ordID != null) {
        await _firestore
            .collection('groceryStores')
            .doc(storeID)
            .collection('requestedOrders')
            .doc(ordID)
            .set(requestedOrders_Model.toJson());

        emit(BillingCheckoutLoadedState());
      }
      else{
        print("Order ID is NULL");
      }
    }
    catch (e) {
      print("Exception thrown while checking out Items");
      emit(BillingCheckoutErrorState(e.toString()));
    }
  }

  Future<String?> readOrderID(String storeID) async {
    try {
      final docRef = _firestore.collection('groceryStores').doc(storeID);
      final snapshots = await docRef.get();
      if (snapshots.exists) {
        String? lastORD_ID = await snapshots.data()!['LastORD_ID'];
        if(lastORD_ID == null){
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
      print("Error with the previous Transaction ID");
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


  Future<List<Map<String, dynamic>>> getOrders(String personID) async {
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
    }
    catch (e) {
      print("Error fetching data: $e");
      return [];
    }
  }
}
