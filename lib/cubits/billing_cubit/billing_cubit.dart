import 'package:flutter_bloc/flutter_bloc.dart';

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

