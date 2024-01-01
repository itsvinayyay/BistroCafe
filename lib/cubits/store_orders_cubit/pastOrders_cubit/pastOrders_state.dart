
import 'package:food_cafe/data/models/All_Orders_Models.dart';

abstract class PastOrdersState {
  List<Orders_Model> orders;
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
