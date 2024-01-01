import 'dart:developer';


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/core/api.dart';
import 'package:food_cafe/cubits/store_orders_cubit/requestedOrders_cubit/requestedOrders_states.dart';

import 'package:food_cafe/data/models/All_Orders_Models.dart';
import 'package:food_cafe/data/repository/store_repositories/Orders_repository/requestedOrders_repository.dart';

class RequestedOrdersCubit extends Cubit<RequestedOrdersState> {
  RequestedOrdersCubit() : super(RequestedInitialState());

  
  RequestedOrdersRepository requestedOrdersRepository =
      RequestedOrdersRepository();
  Api _api = Api();

  // void startListening(String storeID) {
  //   print("Started Listening for requestOrders!");
  //   final collectionRef = _firestore
  //       .collection('groceryStores')
  //       .doc(storeID)
  //       .collection('requestedOrders');
  //   _subscription = collectionRef.snapshots().listen((snapshots) {
  //     final requestedOrders = snapshots.docs
  //         .map((doc) => RequestedOrders_Model.fromJson(doc.data()))
  //         .toList();
  //     print(requestedOrders.toString());
  //     emit(requestedOrders);
  //   });
  // }

  void initialize(String storeID) {
    emit(RequestedLoadingState(state.orders));

    try {
      requestedOrdersRepository.getRequestedOrders(storeID);
      requestedOrdersRepository.getOrdersStream
          .listen((List<Orders_Model> orders) {
        emit(RequestedLoadedState(orders));
      });
    } catch (e) {
      log("Started Listening for Requested Orders");
      emit(RequestedErrorState(state.orders, e.toString()));
    }
  }

  Future<void> accept_requested_Order(
      {required String orderID, required String tokenID}) async {
    try {
      requestedOrdersRepository.acceptCurrentOrder(orderID);
      _api.sendMessage(
          tokenID: tokenID,
          title: 'Order Accpeted',
          description: 'Your Order has been accepted by the Cafe Owner!');
    } catch (e) {
      log("Exception Occured while Accpeting current Order => $e (thrown at Requested Orders Cubit)");
    }
  }

  Future<void> reject_requested_Order({required String orderID, required String tokenID}) async {
    try {
      requestedOrdersRepository.rejectCurrentOrder(orderID);
      _api.sendMessage(
          tokenID: tokenID,
          title: 'Order Rejected',
          description: 'Your Order has been Rejected by the Cafe Owner');
    } catch (e) {
      log("Exception Occured while Rejecting current Order => $e (thrown at Requested Orders Cubit)");
    }
  }

 

  void closeStream() {
    requestedOrdersRepository.closeSubscription();
  }

  @override
  Future<void> close() {
    requestedOrdersRepository.closeSubscription();
    return super.close();
  }
}
