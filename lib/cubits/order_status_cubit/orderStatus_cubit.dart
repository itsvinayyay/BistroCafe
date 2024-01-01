import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/order_status_cubit/orderStatus_states.dart';
import 'package:food_cafe/data/repository/order_request_repository.dart';

class OrderStatusCubit extends Cubit<OrderStatus> {
  OrderStatusCubit() : super(StatusInitialState());

  OrderRequestRepository orderRequestRepository = OrderRequestRepository();

  void initialize({required String orderID, required String storeID}) {
    try {
      emit(StatusLoadingState(state.orderStatus));
      orderRequestRepository.startListening(orderID: orderID, storeID: storeID);

      orderRequestRepository.orderStatusStream.listen((String orderStatus) {
        emit(StatusLoadedState(orderStatus));
      });
    } catch (e) {
      log("Exception thrown at Order Status Cubit => $e");
      emit(StatusErrorState(state.orderStatus, e.toString()));
    }
  }
}
