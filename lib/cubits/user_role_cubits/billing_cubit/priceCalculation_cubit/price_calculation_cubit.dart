import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/user_role_cubits/billing_cubit/priceCalculation_cubit/price_calculation_states.dart';
import 'package:food_cafe/data/repository/user_role_repositories/billing_repository.dart';

/// Cubit responsible for handling billing-related state and price calculations.
///
/// This cubit manages the billing state and provides functionality for calculating
/// the subtotal amount based on the provided person ID and dine-in status.
class BillingPriceCalculationCubit extends Cubit<BillingState> {
  /// Initializes the [BillingPriceCalculationCubit] with the initial state.
  BillingPriceCalculationCubit() : super(BillingInitialState());

  /// Repository instance for handling billing-related operations.
  final BillingRepository _billingRepository = BillingRepository();

  /// Variable to store the calculated subtotal.
  int subTotal = 0;

  /// Calculates the subtotal amount based on the provided person ID and dine-in status.
  ///
  /// Parameters:
  /// - [personID]: The ID of the person for whom the subtotal is calculated.
  /// - [isDineIn]: A boolean indicating whether it's a dine-in scenario.
  ///
  /// Throws an exception if any error occurs during the calculation,
  /// leading to a [BillingErrorState]. Upon successful completion,
  /// emits a [BillLoadedState] with the calculated subtotal and total amounts.
  Future<void> calculateSubtotal({
    required String personID,
    required bool isDineIn,
  }) async {
    // Emitting the loading state to indicate the start of the subtotal calculation.
    emit(BillingLoadingState());

    try {
      // Retrieving the subtotal amount from the billing repository.
      subTotal = await _billingRepository.getSubTotalAmount(
        personID: personID,
        isDineIn: isDineIn,
      );

      // Calculating the total amount based on dine-in status.
      int total = isDineIn ? subTotal : subTotal + 10;

      // Emitting the loaded state with the calculated subtotal and total amounts.
      emit(BillLoadedState(subTotal, total));
    } catch (e) {
      // Logging and emitting an error state if an exception occurs.
      log("Exception while sending OTP (Error from Billing Price Calculation Cubit )");
      emit(BillingErrorState(e.toString()));
    }
  }
}

