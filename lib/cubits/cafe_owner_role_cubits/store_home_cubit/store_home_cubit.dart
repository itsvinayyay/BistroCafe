import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_home_cubit/store_home_states.dart';
import 'package:food_cafe/data/models/store_order_model.dart';
import 'package:food_cafe/data/repository/cafe_owner_role_repositories/store_home_repository.dart';
import 'package:food_cafe/data/services/connectivity_service.dart';

/// A Cubit responsible for managing the state of past orders in the home screen.
class HomePastOrdersCubit extends Cubit<HomePastOrdersState> {
  /// Initializes the cubit with the initial state.
  HomePastOrdersCubit() : super(HomePastInitialState());

  /// Repository instance for accessing store home-related data.
  final StoreHomeRepository _storeHomeRepository = StoreHomeRepository();

  /// Fetches past orders for the specified store and updates the state accordingly.
  ///
  /// Parameters:
  ///   - storeID: The unique identifier of the store for which past orders are requested.
  ///
  /// Behavior:
  ///   - Emits a loading state to indicate that the data retrieval is in progress.
  ///   - Checks internet connectivity and emits an error state if disconnected.
  ///   - Calls the repository to get the list of past orders for the specified store.
  ///   - Emits a loaded state with the retrieved past orders.
  ///
  /// Throws an exception if there's an issue during the retrieval process, logging an error message.
  void getPastOrders({required String storeID}) async {
    try {
      // Emit a loading state to indicate that data retrieval is in progress
      emit(HomePastLoadingState(state.pastOrders));

      // Check internet connectivity and handle accordingly
      await checkConnectivityForCubits(onDisconnected: () {
        emit(HomePastErrorState(state.pastOrders, 'internetError'));
      }, onConnected: () async {
        // Fetch past orders from the repository
        List<OrderModel> pastOrders =
            await _storeHomeRepository.getPastOrders(storeID: storeID);

        // Emit a loaded state with the retrieved past orders
        emit(HomePastLoadedState(pastOrders));
      });
    } catch (e) {
      // Log an error and emit an error state if there's an exception during the retrieval process
      log("Exception thrown while fetching Past Orders (Exception thrown from Home Past Orders Cubit) => $e");
      emit(HomePastErrorState(state.pastOrders, e.toString()));
    }
  }
}
