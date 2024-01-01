abstract class OrderStatus {
  String orderStatus;
  OrderStatus(this.orderStatus);
}

class StatusInitialState extends OrderStatus {
  StatusInitialState() : super('');
}

class StatusLoadingState extends OrderStatus {
  StatusLoadingState(super.orderStatus);
}

class StatusLoadedState extends OrderStatus {
  StatusLoadedState(super.orderStatus);
}

class StatusErrorState extends OrderStatus {
  final String message;
  StatusErrorState(super.orderStatus, this.message);
}
