import 'package:food_cafe/data/models/store_order_model.dart';

abstract class PastOrdersState {
  List<OrderModel> orders;
  PastOrdersState(this.orders);
}

class PastInitialState extends PastOrdersState {
  PastInitialState() : super([]);
}

class PastLoadingState extends PastOrdersState {
  PastLoadingState(super.orders);
}

class PastLoadedState extends PastOrdersState {
  PastLoadedState(super.orders);
}

class PastErrorState extends PastOrdersState {
  final String message;
  PastErrorState(super.orders, this.message);
}
