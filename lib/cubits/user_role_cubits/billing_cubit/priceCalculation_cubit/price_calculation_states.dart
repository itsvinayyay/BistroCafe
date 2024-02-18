/// Abstract class representing different states in the billing process.
abstract class BillingState {}

/// Represents the state when the billing process is currently loading.
class BillingLoadingState extends BillingState {}

/// Represents the initial state of the billing process.
class BillingInitialState extends BillingState {}

/// Represents the state when the billing process has been successfully loaded.
class BillLoadedState extends BillingState {
  /// The subtotal amount calculated in the billing process.
  final int subTotal;

  /// The total amount in the billing process.
  final int total;

  /// Constructs a [BillLoadedState] with the specified [subTotal] and [total] amounts.
  BillLoadedState(this.subTotal, this.total);
}

/// Represents an error state in the billing process, providing details about the error.
class BillingErrorState extends BillingState {
  /// The error message associated with the error state.
  final String error;

  /// Constructs a [BillingErrorState] with the specified [error] message.
  BillingErrorState(this.error);
}
