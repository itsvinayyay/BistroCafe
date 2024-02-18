import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/core/api.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_orders_cubit/requestedOrders_cubit/requested_orders_states.dart';

import 'package:food_cafe/data/models/store_order_model.dart';
import 'package:food_cafe/data/repository/cafe_owner_role_repositories/orders_repositories/requested_orders_repository.dart';
import 'package:food_cafe/data/services/connectivity_service.dart';

class RequestedOrdersCubit extends Cubit<RequestedOrdersState> {
  RequestedOrdersCubit() : super(RequestedInitialState());

  final RequestedOrdersRepository _requestedOrdersRepository =
      RequestedOrdersRepository();
  final Api _api = Api();

  /// Initializes the requested orders and sets the appropriate states in the cubit.
  ///
  /// It emits a loading state, then tries to fetch requested orders and listen to updates.
  /// If successful, it emits a loaded state with the retrieved orders.
  /// If an exception occurs during the process, it emits an error state with the error message.
  ///
  /// @param storeID The identifier of the store for which requested orders are fetched.
  Future<void> initialize(String storeID) async {
    emit(RequestedLoadingState(state.orders));

    try {
      await checkConnectivityForCubits(onDisconnected: () {
        emit(RequestedErrorState(state.orders, 'internetError'));
      }, onConnected: () {
        // Fetch requested orders for the specified storeID
        _requestedOrdersRepository.getRequestedOrders(storeID);

        // Listen to updates in the orders stream
        _requestedOrdersRepository.getOrdersStream
            .listen((List<OrderModel> orders) {
          // Emit a loaded state with the retrieved orders
          emit(RequestedLoadedState(orders));
        });
      });
    } catch (e) {
      // Handle any exceptions that occur during the process
      log("Error occurred while retrieving Requested Orders (Error from Requested Orders Cubit)=> $e");
      emit(RequestedErrorState(state.orders, e.toString()));
    }
  }

  /// Accepts a requested order, updates its status, and notifies the customer.
  ///
  /// This method is responsible for accepting a requested order, updating its status, and
  /// notifying the customer with a custom message. It interacts with the [_requestedOrdersRepository]
  /// to perform the necessary actions.
  ///
  /// - [orderID] The identifier of the order to be accepted.
  /// - [tokenID] The unique identifier for the customer's device token for sending push notifications.
  /// - [isPaid] A boolean indicating whether the order has been paid for.
  /// - [storeID] The identifier of the store accepting the order.
  /// - [price] The total price of the accepted order.
  /// - [orderedItems] A list of maps representing the items in the accepted order.
  ///
  /// @throws Exception if any error occurs during the process.
  Future<void> acceptRequestedOrder({
    required String orderID,
    required String tokenID,
    required bool isPaid,
    required String storeID,
    required int price,
    required List<Map<String, dynamic>> orderedItems,
  }) async {
    try {
      // Accept the current order using the repository
      await _requestedOrdersRepository.acceptCurrentOrder(
        isPaid: isPaid,
        orderID: orderID,
        storeID: storeID,
        price: price,
        orderedItems: orderedItems,
      );

      // Send a notification to the customer about the order acceptance
      await _api.sendMessage(
        tokenID: tokenID,
        title: 'Order Accepted!',
        description: 'Your Order has been accepted by the Cafe Owner',
      );
    } catch (e) {
      // Handle any exceptions that occur during the process
      log("Exception occurred while accepting current Order: $e (Error from Requested Orders Cubit)");
    }
  }

  /// Rejects a requested order and notifies the customer.
  ///
  /// - [orderID]: The unique identifier of the order to be rejected.
  /// - [tokenID]: The unique identifier for the customer's device token for sending push notifications.
  ///
  /// This method rejects a requested order identified by [orderID] and sends a notification
  /// to the customer using their device token [tokenID] to inform them about the rejection.
  ///
  /// If the rejection process encounters any errors, it logs an error message.
  ///
  /// Throws [Exception] if any error occurs during the rejection process.
  Future<void> rejectRequestedOrder({
    required String orderID,
    required String tokenID,
  }) async {
    try {
      // Reject the current order using the repository
      await _requestedOrdersRepository.rejectCurrentOrder(orderID);

      // Send a notification to the customer about the order rejection
      _api.sendMessage(
        tokenID: tokenID,
        title: 'Order Rejected',
        description: 'Your Order has been Rejected by the Cafe Owner',
      );
    } catch (e) {
      // Handle any exceptions that occur during the rejection process
      log("Exception occurred while rejecting current Order: $e (Error from Requested Orders Cubit)");
    }
  }

  @override
  Future<void> close() {
    //Closes the stream
    _requestedOrdersRepository.closeSubscription();
    return super.close();
  }
}
