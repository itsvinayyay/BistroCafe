import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_orders_cubit/pastOrders_cubit/pastOrders_state.dart';
import 'package:food_cafe/data/models/store_order_model.dart';
import 'package:food_cafe/data/repository/cafe_owner_role_repositories/orders_repositories/past_orders_repository.dart';
import 'package:food_cafe/data/services/connectivity_service.dart';

/// Cubit responsible for managing the state of past orders.
class PastOrdersCubit extends Cubit<PastOrdersState> {
  // Initialize the cubit with the initial state.
  PastOrdersCubit() : super(PastInitialState());

  // Repository for handling past orders data.
  final PastOrdersRepository _pastOrdersRepository = PastOrdersRepository();

  /// Initializes the cubit by loading past orders for a specific store.
  ///
  /// Parameters:
  /// - [storeID]: The identifier for the store.
  Future<void> initialize(String storeID) async {
    // Emit the loading state to update the UI.
    emit(PastLoadingState(state.orders));

    try {
      // Check connectivity before fetching past orders.
      await checkConnectivityForCubits(
        onDisconnected: () {
          emit(PastErrorState(state.orders, 'internetError'));
        },
        onConnected: () async {
          // Fetch past orders from the repository.
          List<OrderModel> orders =
              await _pastOrdersRepository.getPastOrders(storeID: storeID);

          // Emit the loaded state with the fetched orders.
          emit(PastLoadedState(orders));
        },
      );
    } catch (e) {
      // Handle exceptions and emit an error state.
      log("Exception thrown while fetching Past Orders (Error from Past Orders Repository)");
      emit(PastErrorState(state.orders, e.toString()));
    }
  }
}
