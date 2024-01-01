import 'package:food_cafe/data/models/All_Orders_Models.dart';

abstract class HomePastOrdersState {
  List<Orders_Model> pastOrders;
  HomePastOrdersState(this.pastOrders);
}

class HomePastInitialState extends HomePastOrdersState {
  HomePastInitialState() : super([]);
}

class HomePastLoadedState extends HomePastOrdersState {
  HomePastLoadedState(super.pastOrders);
}

class HomePastLoadingState extends HomePastOrdersState {
  HomePastLoadingState(super.pastOrders);
}

class HomePastErrorState extends HomePastOrdersState {
  final String message;
  HomePastErrorState(super.pastOrders, this.message);
}
