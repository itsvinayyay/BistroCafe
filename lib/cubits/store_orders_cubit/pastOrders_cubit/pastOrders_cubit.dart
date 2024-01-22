import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/store_orders_cubit/pastOrders_cubit/pastOrders_state.dart';
import 'package:food_cafe/data/models/All_Orders_Models.dart';
import 'package:food_cafe/data/repository/store_repositories/Orders_repository/pastOrders_repository.dart';

class PastOrdersCubit extends Cubit<PastOrdersState> {
  PastOrdersCubit() : super(PastInitialState());

  PastOrdersRepository pastOrdersRepository = PastOrdersRepository();

  Future<void> initialize(String storeID) async {
    emit(PastLoadingState(state.orders));

    try {
      List<Orders_Model> orders =
          await pastOrdersRepository.getPastOrders(storeID: storeID);
      emit(PastLoadedState(orders));
    } catch (e) {
      log("Exception thrown while fetching Past Orders (Error from Past Orders Repository)");
      emit(PastErrorState(state.orders, e.toString()));
    }
  }
}
