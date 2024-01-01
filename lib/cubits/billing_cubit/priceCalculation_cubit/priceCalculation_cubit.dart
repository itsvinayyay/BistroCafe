import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/billing_cubit/priceCalculation_cubit/priceCalculation_states.dart';

class BillingCubit extends Cubit<BillingState> {
  BillingCubit() : super(LoadingState());

  final _firestore = FirebaseFirestore.instance;
  int subTotal = 0;

  Future<void> calculateSubtotal(String userID, bool isDineInEnabled) async {
    subTotal = 0;
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

    int total = isDineInEnabled == true ? subTotal : subTotal + 10;
    emit(BillLoadedState(subTotal, total));
  }
}
