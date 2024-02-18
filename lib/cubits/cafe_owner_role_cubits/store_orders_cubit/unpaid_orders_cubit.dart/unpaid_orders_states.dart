import 'package:food_cafe/data/models/store_order_model.dart';

/// Abstract class representing the state of unpaid orders.
///
/// This abstract class serves as the base class for various states related to unpaid orders.
/// It contains a list of [OrderModel] representing the current state of unpaid orders.
abstract class UnpaidOrdersState {
  List<OrderModel> orders;
  UnpaidOrdersState(this.orders);
}

/// Initial state class indicating an empty list of unpaid orders.
class UnpaidOrdersInitialState extends UnpaidOrdersState {
  UnpaidOrdersInitialState() : super([]);
}

/// Loading state class indicating that unpaid orders are being fetched.
class UnpaidOrdersLoadingState extends UnpaidOrdersState {
  UnpaidOrdersLoadingState(super.orders);
}

/// Loaded state class indicating that unpaid orders have been successfully loaded.
class UnpaidOrdersLoadedState extends UnpaidOrdersState {
  UnpaidOrdersLoadedState(super.orders);
}

/// Error state class indicating an error while fetching unpaid orders.
class UnpaidOrdersErrorState extends UnpaidOrdersState {
  final String error;
  UnpaidOrdersErrorState(super.orders, this.error);
}
