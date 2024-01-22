import 'dart:developer';


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/core/api.dart';
import 'package:food_cafe/cubits/store_orders_cubit/currentOrders_cubit/currentOrders_states.dart';
import 'package:food_cafe/data/models/All_Orders_Models.dart';
import 'package:food_cafe/data/repository/store_repositories/Orders_repository/currentOrders_repository.dart';

class CurrentOrdersCubit extends Cubit<CurrentOrdersState> {
  CurrentOrdersCubit() : super(CurrentInitialState());

  
  CurrentOrdersRepository currentOrdersRepository = CurrentOrdersRepository();
  final Api _api = Api();


  void initialize(String storeID) {
    emit(CurrentLoadingState(state.orders));

    try {
      currentOrdersRepository.getCurrentOrders(storeID);
      currentOrdersRepository.getOrdersStream
          .listen((List<Orders_Model> orders) {
        emit(CurrentLoadedState(orders));
      });
    } catch (e) {
      log("Started Listening for Current Orders");
      emit(CurrentErrorState(state.orders, e.toString()));
    }
  }



  Future<void> currentOrder_prepared({required String orderID, required String tokenID}) async {
    try {
      currentOrdersRepository.currentOrderPrepared(orderID);
      _api.sendMessage(
          tokenID: tokenID,
          title: 'Order Prepared! 🍽️',
          description: 'Your order is prepared and ready for you. Thank you for choosing us for your culinary delights!');
    } catch (e) {
      log("Exception Occured while Accpeting current Order => $e (thrown at Requested Orders Cubit)");
    }
  }

  @override
  Future<void> close() {
    currentOrdersRepository.closeSubscription();
    return super.close();
  }
}
