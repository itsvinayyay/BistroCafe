import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit responsible for managing the selected hostel in the billing process.
class BillingHostelCubit extends Cubit<int> {
  BillingHostelCubit() : super(0);

  /// Updates the selected hostel with the provided value [x].
  ///
  /// Parameters:
  /// - [x]: The new value representing the selected hostel.
  void updateHostel(int x) {
    emit(x);
  }
}

/// Cubit responsible for managing the dine-in selection in the billing process.
class BillingDineSelectionCubit extends Cubit<bool> {
  BillingDineSelectionCubit() : super(true);

  /// Toggles the dine-in selection based on the provided boolean value [isDineIn].
  ///
  /// Parameters:
  /// - [isDineIn]: A boolean indicating whether it's a dine-in scenario.
  void toggleDineIn(bool isDineIn) {
    isDineIn ? emit(false) : emit(true);
  }
}

/// Cubit responsible for managing the payment method selection in the billing process.
class BillingPaymentCubit extends Cubit<bool> {
  BillingPaymentCubit() : super(true);

  /// Toggles the payment method selection based on the provided boolean value [isCOD].
  ///
  /// Parameters:
  /// - [isCOD]: A boolean indicating whether Cash on Delivery (COD) is selected as the payment method.
  void togglePaymentMethod(bool isCOD) {
    emit(isCOD);
  }
}
