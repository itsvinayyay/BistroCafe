import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/store_home_cubit/store_home_states.dart';
import 'package:food_cafe/data/models/All_Orders_Models.dart';
import 'package:food_cafe/data/repository/store_repositories/Orders_repository/store_home_repository.dart';

class HomePastOrders extends Cubit<HomePastOrdersState> {
  HomePastOrders() : super(HomePastInitialState());

  StoreHomeRepository storeHomeRepository = StoreHomeRepository();

  void getPastOrders({required String storeID}) async {
    try {
      emit(HomePastLoadingState(state.pastOrders));
      List<Orders_Model> pastOrders =
          await storeHomeRepository.getPastOrders(storeID: storeID);

      emit(HomePastLoadedState(pastOrders));
    } catch (e) {
      log("Exception thrown while fetching Past Orders (Expcetion thrown from Home Past Orders Cubit) => $e");
      emit(HomePastErrorState(state.pastOrders, e.toString()));
    }
  }
}
