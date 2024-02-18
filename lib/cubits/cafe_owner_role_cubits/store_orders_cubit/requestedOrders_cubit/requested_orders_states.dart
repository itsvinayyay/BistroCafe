import 'package:food_cafe/data/models/store_order_model.dart';

/// Represents the different states of requested orders.
abstract class RequestedOrdersState {
  /// The list of orders associated with this state.
  List<OrderModel> orders;

  /// Constructs a requested orders state with the given list of orders.
  RequestedOrdersState(this.orders);
}

/// Represents the initial state of requested orders with an empty order list.
class RequestedInitialState extends RequestedOrdersState {
  // Constructs the initial state with an empty list of orders.
  RequestedInitialState() : super([]);
}

/// Represents the state when requested orders are being loaded.
class RequestedLoadingState extends RequestedOrdersState {
  // Constructs the loading state with the given list of orders.
  RequestedLoadingState(super.orders);
}

/// Represents the state when requested orders have been successfully loaded.
class RequestedLoadedState extends RequestedOrdersState {
  // Constructs the loaded state with the given list of orders.
  RequestedLoadedState(super.orders);
}

/// Represents the state when an error occurs while fetching requested orders.
class RequestedErrorState extends RequestedOrdersState {
  /// The error message associated with the error state.
  final String message;

  // Constructs the error state with the given list of orders and error message.
  RequestedErrorState(super.orders, this.message);
}
