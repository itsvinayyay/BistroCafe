/// Abstract class representing different states in the payment process.
abstract class PaymentState {}

/// Initial state for the payment process.
class PaymentInitialState extends PaymentState {}

/// State indicating that the payment operation is in progress.
class PaymentLoadingState extends PaymentState {}

/// State indicating that the payment operation has been successfully completed.
class PaymentLoadedState extends PaymentState {
  /// Boolean indicating the success status of the payment.
  final bool paymentStatus;

  /// Identifier associated with the successful payment (e.g., UPI ID).
  final String upiID;

  // Constructor for [PaymentLoadedState].
  PaymentLoadedState({required this.paymentStatus, required this.upiID});
}

/// State indicating that an error occurred during the payment process.
class PaymentErrorState extends PaymentState {
  /// Error message providing details about the payment failure.
  final String message;

  // Constructor for [PaymentErrorState].
  PaymentErrorState({required this.message});
}
