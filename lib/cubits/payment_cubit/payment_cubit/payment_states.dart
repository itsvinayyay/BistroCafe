abstract class PaymentState {}

class PaymentInitialState extends PaymentState {}

class PaymentLoadingState extends PaymentState {}

class PaymentLoadedState extends PaymentState {
  final bool paymentStatus;
  final String upiID;
  PaymentLoadedState({required this.paymentStatus, required this.upiID});
}

class PaymentErrorState extends PaymentState {
  final String message;
  PaymentErrorState({required this.message});
}
