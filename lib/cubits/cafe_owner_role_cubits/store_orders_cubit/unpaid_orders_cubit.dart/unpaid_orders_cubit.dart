import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/core/api.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_orders_cubit/unpaid_orders_cubit.dart/unpaid_orders_states.dart';
import 'package:food_cafe/data/models/store_order_model.dart';
import 'package:food_cafe/data/repository/cafe_owner_role_repositories/orders_repositories/unpaid_orders_repository.dart';
import 'package:food_cafe/data/services/connectivity_service.dart';

/// Cubit responsible for managing the state of unpaid orders.
class UnpaidOrdersCubit extends Cubit<UnpaidOrdersState> {
  // Initialize the cubit with the initial state.
  UnpaidOrdersCubit() : super(UnpaidOrdersInitialState());

  // Repository for handling unpaid orders data.
  final UnpaidOrdersRepository _unpaidOrdersRepository =
      UnpaidOrdersRepository();

  // API instance for sending messages.
  final Api _api = Api();

  /// Initializes the cubit by loading unpaid orders for a specific store.
  ///
  /// Parameters:
  /// - [storeID]: The identifier for the store.
  Future<void> initialize({required String storeID}) async {
    // Emit the loading state to update the UI.
    emit(UnpaidOrdersLoadingState(state.orders));

    try {
      // Check connectivity before fetching orders.
      checkConnectivityForCubits(
        onDisconnected: () {
          emit(UnpaidOrdersErrorState(state.orders, 'internetError'));
        },
        onConnected: () {
          // Fetch unpaid orders from the repository and listen for changes in the stream.
          _unpaidOrdersRepository.getUnpaidOrders(storeID);
          _unpaidOrdersRepository.getOrdersStream
              .listen((List<OrderModel> orders) {
            emit(UnpaidOrdersLoadedState(orders));
          });
        },
      );
    } catch (e) {
      // Handle exceptions and emit an error state.
      log("Exception thrown while fetching Past Orders (Error from Past Orders Repository)");
      emit(UnpaidOrdersErrorState(state.orders, e.toString()));
    }
  }

  /// Marks an unpaid order as successful and notifies the user.
  ///
  /// Parameters:
  /// - [orderID]: The identifier for the order.
  /// - [storeID]: The identifier for the store.
  /// - [tokenID]: The token identifier for sending notifications.
  /// - [price]: The total price of the order.
  /// - [orderedItems]: List of ordered items with their details.
  Future<void> markAsSuccess(
      {required String orderID,
      required String storeID,
      required String tokenID,
      required int price,
      required List<Map<String, dynamic>> orderedItems}) async {
    try {
      // Update the order as successful in the repository.
      _unpaidOrdersRepository.orderSuccess(
          orderID: orderID,
          storeID: storeID,
          price: price,
          orderedItems: orderedItems);

      // Send a success notification to the user.
      _api.sendMessage(
          tokenID: tokenID,
          title: 'Payment Success!',
          description:
              "The cafe owner has marked your payment as successful. Your order is in progress, and we're getting it ready for you.");
    } catch (e) {
      // Handle exceptions during the process.
      log("Exception thrown while marking Unpaid Order as Successful (Error from Unpaid Order Cubit) => $e");
    }
  }

  /// Marks an unpaid order as failed and notifies the user.
  ///
  /// Parameters:
  /// - [orderID]: The identifier for the order.
  /// - [storeID]: The identifier for the store.
  /// - [tokenID]: The token identifier for sending notifications.
  Future<void> markAsFailure(
      {required String orderID,
      required String storeID,
      required String tokenID}) async {
    try {
      // Update the order as failed in the repository.
      _unpaidOrdersRepository.orderFailure(storeID: storeID, orderID: orderID);

      // Send a failure notification to the user.
      _api.sendMessage(
          tokenID: tokenID,
          title: 'Payment Failed!',
          description:
              'The cafe owner has flagged your order as Rejected due to the issue with your payment. Reach out for assistance. Apologies for any inconvenience.');
    } catch (e) {
      // Handle exceptions during the process.
      log("Exception thrown while marking Unpaid Order as Failed (Error from Unpaid Order Cubit) => $e");
    }
  }

  @override
  Future<void> close() {
    // Close the subscription to avoid memory leaks.
    _unpaidOrdersRepository.closeSubscription();
    return super.close();
  }
}
