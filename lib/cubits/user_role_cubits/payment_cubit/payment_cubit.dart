import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/user_role_cubits/payment_cubit/payment_states.dart';
import 'package:food_cafe/data/repository/user_role_repositories/payment_repository.dart';

/// A Cubit responsible for managing the payment state during a transaction.
class PaymentCubit extends Cubit<PaymentState> {
  /// The repository handling payment-related operations.
  final PaymentRepository _paymentRepository = PaymentRepository();

  /// Default constructor initializing the cubit with the initial state.
  PaymentCubit() : super(PaymentInitialState());

  /// Initiates a successful payment transaction.
  Future<void> makeTransactionSuccess({
    required String orderID,
    required String storeID,
  }) async {
    emit(PaymentLoadingState());
    try {
      // Mark the order status as paid and update the state accordingly.
      await _paymentRepository.markOrderStatus(
          storeID: storeID, orderID: orderID, isPaid: true);
      emit(PaymentLoadedState(paymentStatus: true, upiID: 'XX2024XX2024'));
    } catch (e) {
      // Handle any exceptions and transition to the error state.
      log("Exception while marking OrderStatus (Error from Payment Cubit)");
      emit(PaymentErrorState(message: e.toString()));
    }
  }

  /// Initiates a failed payment transaction.
  Future<void> makeTransactionFailure({
    required String orderID,
    required String storeID,
  }) async {
    emit(PaymentLoadingState());
    try {
      // Mark the order status as unpaid and update the state accordingly.
      await _paymentRepository.markOrderStatus(
          storeID: storeID, orderID: orderID, isPaid: false);
      emit(PaymentErrorState(message: 'Payment Failed!'));
    } catch (e) {
      // Handle any exceptions and transition to the error state.
      log("Exception while marking OrderStatus (Error from Payment Cubit)");
      emit(PaymentErrorState(message: e.toString()));
    }
  }
}
