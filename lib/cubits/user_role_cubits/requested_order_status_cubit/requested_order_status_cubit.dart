import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/user_role_cubits/requested_order_status_cubit/requested_order_status_state.dart';
import 'package:food_cafe/data/repository/user_role_repositories/order_request_repository.dart';

/// Cubit responsible for managing the status of a requested order.
///
/// This cubit handles the initialization of order status monitoring and provides
/// real-time updates on the order status through its state.
class RequestedOrderStatusCubit extends Cubit<RequestedOrderStatusStates> {
  // Constructor for the cubit, initializing it with the initial state.
  RequestedOrderStatusCubit() : super(StatusInitialState());

  // The repository responsible for handling order request-related operations.
  final OrderRequestRepository _orderRequestRepository =
      OrderRequestRepository();

  /// Initializes the cubit by starting the monitoring of the order status for a specific order.
  ///
  /// Parameters:
  /// - [orderID]: The unique identifier of the order being monitored.
  /// - [storeID]: The unique identifier of the store associated with the order.
  void initialize({required String orderID, required String storeID}) {
    try {
      // Emitting the loading state with the current order status.
      emit(StatusLoadingState(state.orderStatus));

      // Starting the subscription to listen for real-time order status updates.
      _orderRequestRepository.startListening(
        orderID: orderID,
        storeID: storeID,
      );

      // Listening to the order status stream and emitting loaded state on updates.
      _orderRequestRepository.orderStatusStream.listen((String orderStatus) {
        emit(StatusLoadedState(orderStatus));
      });
    } catch (e) {
      // Handling exceptions by emitting an error state with the current order status.
      log("Exception thrown at Order Status Cubit => $e");
      emit(StatusErrorState(state.orderStatus, e.toString()));
    }
  }

  @override
  Future<void> close() {
    // Closing the subscription to stop listening for order status updates.
    _orderRequestRepository.closeSubscription();
    return super.close();
  }
}
