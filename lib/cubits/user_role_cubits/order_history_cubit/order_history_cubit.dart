import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/user_role_cubits/order_history_cubit/order_history_states.dart';
import 'package:food_cafe/data/models/store_order_model.dart';
import 'package:food_cafe/data/repository/user_role_repositories/order_history_repository.dart';
import 'package:food_cafe/data/services/connectivity_service.dart';

/// Cubit class responsible for managing the state of order history.
class OrderHistoryCubit extends Cubit<OrderHistoryStates> {
  // Constructor initializing the cubit with the initial state.
  OrderHistoryCubit() : super(OrderHistoryInitialState());

  // Instance of OrderHistoryRepository for data retrieval.
  final OrderHistoryRepository _orderHistoryRepository =
      OrderHistoryRepository();

  /// Initiates the fetching of order history for a specified person.
  ///
  /// Parameters:
  /// - [personID]: The unique identifier of the person associated with the order history.
  Future<void> initiateFetch({required String personID, required String storeID}) async {
    // Emitting the loading state with the current list of orders.
    emit(OrderHistoryLoadingState(state.orders));

    try {
      // Checking connectivity before making the request.
      await checkConnectivityForCubits(
        onDisconnected: () {
          emit(OrderHistoryErrorState(state.orders, 'internetError'));
        },
        onConnected: () async {
          // Fetching the order history for the specified person.
          List<OrderModel> orders =
              await _orderHistoryRepository.getOrderHistory(personID: personID, storeID: storeID);

          // Emitting the loaded state with the updated list of orders.
          emit(OrderHistoryLoadedState(orders));
        },
      );
    } catch (e) {
      // Logging and emitting an error state in case of an exception.
      log('Exception while fetching Order History (Error from Order History Cubit)');
      emit(OrderHistoryErrorState(state.orders, e.toString()));
    }
  }
}
