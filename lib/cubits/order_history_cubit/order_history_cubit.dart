import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/order_history_cubit/order_history_states.dart';
import 'package:food_cafe/data/models/All_Orders_Models.dart';
import 'package:food_cafe/data/repository/order_history_repository.dart';

class OrderHistoryCubit extends Cubit<OrderHistoryStates> {
  OrderHistoryCubit() : super(OrderHistoryInitialState());

  OrderHistoryRepository _orderHistoryRepository = OrderHistoryRepository();

  Future<void> initiateFetch({required String personID}) async {
    emit(OrderHistoryLoadingState(state.orders));

    try {
      List<Orders_Model> orders =
          await _orderHistoryRepository.getOrderHistory(personID: personID);
      log(orders.toString());
      emit(OrderHistoryLoadedState(orders));
    } catch (e) {
      log('Exception while fetching Order History (Error from Order History Cubit)');
      emit(OrderHistoryErrorState(state.orders, e.toString()));
    }
  }
}
