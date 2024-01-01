import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/store_orders_cubit/pastOrders_cubit/pastOrders_state.dart';
import 'package:food_cafe/data/models/All_Orders_Models.dart';
import 'package:food_cafe/data/repository/store_repositories/Orders_repository/pastOrders_repository.dart';

class PastOrdersCubit extends Cubit<PastOrdersState> {
  PastOrdersCubit() : super(PastInitialState());

  PastOrdersRepository pastOrdersRepository = PastOrdersRepository();

  void initialize(String storeID) {
    emit(PastLoadingState(state.orders));

    try {
      pastOrdersRepository.getPastOrders(storeID);
      pastOrdersRepository.getOrdersStream.listen((List<Orders_Model> orders) {
        emit(PastLoadedState(orders));
      });
    } catch (e) {
      log("Started Listening for Requested Orders");
      emit(PastErrorState(state.orders, e.toString()));
    }
  }

  @override
  Future<void> close() {
    pastOrdersRepository.closeSubscription();
    return super.close();
  }
}
