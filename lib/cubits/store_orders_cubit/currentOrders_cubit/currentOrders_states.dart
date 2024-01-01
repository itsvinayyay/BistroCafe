

import 'package:food_cafe/data/models/All_Orders_Models.dart';

abstract class CurrentOrdersState {
  List<Orders_Model> orders;
  CurrentOrdersState(this.orders);
}

class CurrentInitialState extends CurrentOrdersState {
  CurrentInitialState() : super([]);
}

class CurrentLoadingState extends CurrentOrdersState {
  CurrentLoadingState(super.orders);
}

class CurrentLoadedState extends CurrentOrdersState {
  CurrentLoadedState(super.orders);
}

class CurrentErrorState extends CurrentOrdersState {
  final String message;
  CurrentErrorState(super.orders, this.message);
}
