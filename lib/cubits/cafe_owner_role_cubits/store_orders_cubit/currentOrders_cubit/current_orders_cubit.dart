import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/core/api.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_orders_cubit/currentOrders_cubit/current_orders_states.dart';
import 'package:food_cafe/data/models/store_order_model.dart';
import 'package:food_cafe/data/repository/cafe_owner_role_repositories/orders_repositories/current_orders_repository.dart';
import 'package:food_cafe/data/services/connectivity_service.dart';

/// Cubit responsible for managing the state of current orders.
class CurrentOrdersCubit extends Cubit<CurrentOrdersState> {
  // Initialize the cubit with the initial state.
  CurrentOrdersCubit() : super(CurrentInitialState());

  // Repository for handling current orders data.
  final CurrentOrdersRepository _currentOrdersRepository =
      CurrentOrdersRepository();

  // API instance for sending messages.
  final Api _api = Api();

  /// Initializes the cubit by loading current orders for a specific store.
  ///
  /// Parameters:
  /// - [storeID]: The identifier for the store.
  Future<void> initialize(String storeID) async {
    await _api.initialize();
    // Emit the loading state to update the UI.
    emit(CurrentLoadingState(state.orders));

    try {
      // Check connectivity before fetching orders.
      await checkConnectivityForCubits(
        onDisconnected: () {
          emit(CurrentErrorState(state.orders, 'internetError'));
        },
        onConnected: () {
          // Fetch current orders from the repository and listen for changes in the stream.
          _currentOrdersRepository.getCurrentOrders(storeID);
          _currentOrdersRepository.getOrdersStream
              .listen((List<OrderModel> orders) {
            emit(CurrentLoadedState(orders));
          });
        },
      );
    } catch (e) {
      // Handle exceptions and emit an error state.
      log("Exception while retrieving Current Orders (Error from Current Orders Repository)");
      emit(CurrentErrorState(state.orders, e.toString()));
    }
  }

  /// Marks a current order as prepared and notifies the user.
  ///
  /// Parameters:
  /// - [orderID]: The identifier for the order.
  /// - [tokenID]: The token identifier for sending notifications.
  Future<void> markCurrentOrderPrepared(
      {required String orderID, required String tokenID}) async {
    try {
      // Update the order as prepared in the repository.
      _currentOrdersRepository.currentOrderPrepared(orderID);

      // Send a notification to the user indicating that the order is prepared.
      _api.sendMessage(
          tokenID: tokenID,
          title: 'Order Prepared! 🍽️',
          description:
              'Your order is prepared and ready for you. Thank you for choosing us for your culinary delights!');
    } catch (e) {
      // Handle exceptions during the process.
      log("Exception Occurred while Accepting current Order => $e (thrown at Requested Orders Cubit)");
    }
  }

  @override
  Future<void> close() {
    // Close the subscription to avoid memory leaks.
    _currentOrdersRepository.closeSubscription();
    return super.close();
  }
}
