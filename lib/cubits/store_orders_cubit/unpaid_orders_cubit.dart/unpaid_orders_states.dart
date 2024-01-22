import 'package:food_cafe/data/models/All_Orders_Models.dart';

abstract class UnpaidOrdersState {
  List<Orders_Model> orders;
  UnpaidOrdersState(this.orders);
}

class UnpaidOrdersInitialState extends UnpaidOrdersState {
  UnpaidOrdersInitialState() : super([]);
}

class UnpaidOrdersLoadingState extends UnpaidOrdersState {
  UnpaidOrdersLoadingState(super.orders);
}

class UnpaidOrdersLoadedState extends UnpaidOrdersState {
  UnpaidOrdersLoadedState(super.orders);
}

class UnpaidOrdersErrorState extends UnpaidOrdersState {
  final String error;
  UnpaidOrdersErrorState(super.orders, this.error);
}
