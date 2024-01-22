import 'package:food_cafe/data/models/All_Orders_Models.dart';

abstract class OrderHistoryStates {
  final List<Orders_Model> orders;
  OrderHistoryStates(this.orders);
}

class OrderHistoryInitialState extends OrderHistoryStates {
  OrderHistoryInitialState() : super([]);
}

class OrderHistoryLoadingState extends OrderHistoryStates {
  OrderHistoryLoadingState(super.orders);
}

class OrderHistoryLoadedState extends OrderHistoryStates {
  OrderHistoryLoadedState(super.orders);
}

class OrderHistoryErrorState extends OrderHistoryStates {
  final String error;
  OrderHistoryErrorState(super.orders, this.error);
}
