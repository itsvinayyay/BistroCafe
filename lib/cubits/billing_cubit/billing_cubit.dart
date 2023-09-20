import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/billing_cubit/billing_state.dart';

class BillingHostelCubit extends Cubit<int>{
  BillingHostelCubit() : super(0);

  void updateHostel(int x){
    emit(x);
  }
}

class BillingDineSelectionCubit extends Cubit<bool>{
  BillingDineSelectionCubit() : super(true);

  void toggleDineIn(bool isDineIn){
    emit(isDineIn);
  }
}

class BillingPaymentCubit extends Cubit<bool>{
  BillingPaymentCubit() : super(true);

  void togglePaymentMethod(bool isCOD){
    emit(isCOD);
  }
}


class BillingCubit extends Cubit<BillingState>{
  BillingCubit() : super(LoadingState());

  final _firestore = FirebaseFirestore.instance;
  int subTotal = 0;

  Future<void> calculateSubtotal(String userID, bool isDineInEnabled)async{
    if(subTotal == 0){
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