
import 'package:food_cafe/data/models/All_Orders_Models.dart';

abstract class RequestedOrdersState {
  List<Orders_Model> orders;
  RequestedOrdersState(this.orders);
}

class RequestedInitialState extends RequestedOrdersState {
  RequestedInitialState() : super([]);
}

class RequestedLoadingState extends RequestedOrdersState {
  RequestedLoadingState(super.orders);
}

class RequestedLoadedState extends RequestedOrdersState {
  RequestedLoadedState(super.orders);
}

class RequestedErrorState extends RequestedOrdersState {
  final String message;
  RequestedErrorState(super.orders, this.message);
}
