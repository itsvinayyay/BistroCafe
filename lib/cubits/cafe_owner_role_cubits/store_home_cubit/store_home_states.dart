import 'package:food_cafe/data/models/store_order_model.dart';

/// Abstract class representing the various states of past orders in the home screen.
abstract class HomePastOrdersState {
  /// List of past orders associated with the state.
  final List<OrderModel> pastOrders;

  /// Initializes the state with the provided list of past orders.
  HomePastOrdersState(this.pastOrders);
}

/// Initial state indicating that there are no past orders loaded yet.
class HomePastInitialState extends HomePastOrdersState {
  // Initializes the initial state with an empty list of past orders.
  HomePastInitialState() : super([]);
}

/// State indicating that past orders are successfully loaded.
class HomePastLoadedState extends HomePastOrdersState {
  // Initializes the loaded state with the provided list of past orders.
  HomePastLoadedState(super.pastOrders);
}

/// Loading state indicating that past orders data is currently being fetched.
class HomePastLoadingState extends HomePastOrdersState {
  // Initializes the loading state with the current list of past orders.
  HomePastLoadingState(super.pastOrders);
}

/// Error state indicating a failure in fetching past orders with an associated error message.
class HomePastErrorState extends HomePastOrdersState {
  /// Error message describing the cause of the failure.
  final String message;

  // Initializes the error state with the current list of past orders and the error message.
  HomePastErrorState(super.pastOrders, this.message);
}
