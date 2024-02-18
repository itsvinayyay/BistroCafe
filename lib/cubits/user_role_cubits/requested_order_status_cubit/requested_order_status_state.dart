/// Abstract class representing the different states of requested order status.
abstract class RequestedOrderStatusStates {
  /// The current order status associated with the state.
  String orderStatus;

  // Constructor to initialize the order status for the state.
  RequestedOrderStatusStates(this.orderStatus);
}

/// Initial state of the requested order status.
class StatusInitialState extends RequestedOrderStatusStates {
// Constructor to create the initial state with an empty order status.
  StatusInitialState() : super('');
}

/// State representing the loading phase of the requested order status.
class StatusLoadingState extends RequestedOrderStatusStates {
  // Constructor to create a loading state with the provided order status.
  StatusLoadingState(super.orderStatus);
}

/// State representing the loaded phase with the current requested order status.
class StatusLoadedState extends RequestedOrderStatusStates {
// Constructor to create a loaded state with the provided order status.
  StatusLoadedState(super.orderStatus);
}

/// State representing an error condition with a specific error message.
class StatusErrorState extends RequestedOrderStatusStates {
  /// The error message associated with the error state.
  final String message;

  // Constructor to create an error state with the provided order status and error message.
  StatusErrorState(super.orderStatus, this.message);
}
