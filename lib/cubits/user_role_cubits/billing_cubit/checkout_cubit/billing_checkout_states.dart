/// Abstract class representing different states in the billing checkout process.
abstract class BillingCheckoutState {}

/// Represents the initial state of the billing checkout process.
class BillingCheckoutInitialState extends BillingCheckoutState {}

/// Represents the state when the billing checkout process has been successfully loaded.
class BillingCheckoutLoadedState extends BillingCheckoutState {}

/// Represents the state indicating that the billing checkout process is currently loading.
class BillingCheckoutLoadingState extends BillingCheckoutState {}

/// Represents an error state in the billing checkout process, providing details about the error.
class BillingCheckoutErrorState extends BillingCheckoutState {
  /// The error message associated with the error state.
  final String error;

  /// Constructs a [BillingCheckoutErrorState] with the specified [error] message.
  BillingCheckoutErrorState(this.error);
}
