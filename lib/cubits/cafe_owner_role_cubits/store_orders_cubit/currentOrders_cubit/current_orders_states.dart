import 'package:food_cafe/data/models/store_order_model.dart';

/// Abstract class representing the state of current orders.
///
/// This abstract class serves as the base class for various states related to current orders.
/// It contains a list of [OrderModel] representing the current state of orders.
abstract class CurrentOrdersState {
  List<OrderModel> orders;
  CurrentOrdersState(this.orders);
}

/// Initial state class indicating an empty list of current orders.
class CurrentInitialState extends CurrentOrdersState {
  CurrentInitialState() : super([]);
}

/// Loading state class indicating that current orders are being fetched.
class CurrentLoadingState extends CurrentOrdersState {
  CurrentLoadingState(super.orders);
}

/// Loaded state class indicating that current orders have been successfully loaded.
class CurrentLoadedState extends CurrentOrdersState {
  CurrentLoadedState(super.orders);
}

/// Error state class indicating an error while fetching current orders.
class CurrentErrorState extends CurrentOrdersState {
  final String message;
  CurrentErrorState(super.orders, this.message);
}
