import 'package:food_cafe/data/models/store_order_model.dart';

/// Abstract class representing the various states for the order history.
abstract class OrderHistoryStates {
  /// List of order models associated with the state.
  final List<OrderModel> orders;

  // Constructor initializing the state with a list of orders.
  OrderHistoryStates(this.orders);
}

/// Initial state for the order history, representing no orders.
class OrderHistoryInitialState extends OrderHistoryStates {
  // Constructor initializing the initial state with an empty list of orders.
  OrderHistoryInitialState() : super([]);
}

/// Loading state for the order history, representing ongoing data retrieval.
class OrderHistoryLoadingState extends OrderHistoryStates {
  // Constructor initializing the loading state with the current list of orders.
  OrderHistoryLoadingState(super.orders);
}

/// Loaded state for the order history, representing successfully retrieved orders.
class OrderHistoryLoadedState extends OrderHistoryStates {
  // Constructor initializing the loaded state with the updated list of orders.
  OrderHistoryLoadedState(super.orders);
}

/// Error state for the order history, representing a failure in data retrieval.
class OrderHistoryErrorState extends OrderHistoryStates {
  /// Error message associated with the error state.
  final String error;

// Constructor initializing the error state with the current list of orders and an error message.
  OrderHistoryErrorState(super.orders, this.error);
}
