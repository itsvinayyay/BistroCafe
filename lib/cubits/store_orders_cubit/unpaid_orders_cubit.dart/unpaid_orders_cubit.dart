import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/core/api.dart';
import 'package:food_cafe/cubits/store_orders_cubit/unpaid_orders_cubit.dart/unpaid_orders_states.dart';
import 'package:food_cafe/data/models/All_Orders_Models.dart';
import 'package:food_cafe/data/repository/store_repositories/Orders_repository/unpaid_orders_repository.dart';

class UnpaidOrdersCubit extends Cubit<UnpaidOrdersState> {
  UnpaidOrdersCubit() : super(UnpaidOrdersInitialState());

  UnpaidOrdersRepository unpaidOrdersRepository = UnpaidOrdersRepository();
  Api _api = Api();

  void initialize({required String storeID}) {
    emit(UnpaidOrdersLoadingState(state.orders));
    try {
      unpaidOrdersRepository.getUnpaidOrders(storeID);
      unpaidOrdersRepository.getOrdersStream
          .listen((List<Orders_Model> orders) {
        emit(UnpaidOrdersLoadedState(orders));
      });
    } catch (e) {
      log("Exception thrown while fetching Past Orders (Error from Past Orders Repository)");
      emit(UnpaidOrdersErrorState(state.orders, e.toString()));
    }
  }

  Future<void> markAsSuccess(
      {required String orderID,
      required String storeID,
      required String tokenID, required int price, required List<Map<String, dynamic>> orderedItems}) async {
    try {
      unpaidOrdersRepository.orderSuccess(orderID: orderID, storeID: storeID, price: price, orderedItems: orderedItems);
      _api.sendMessage(
          tokenID: tokenID,
          title: 'Payment Success!',
          description:
              "The cafe owner has marked your payment as successful. Your order is in progress, and we're getting it ready for you.");
    } catch (e) {
      log("Exception thrown while marking Unpaid Order as Successful (Error from Unpaid Order Cubit) => $e");
    }
  }

  Future<void> markAsFailure(
      {required String orderID,
      required String storeID,
      required String tokenID}) async {
    try {
      unpaidOrdersRepository.orderFailure(storeID: storeID, orderID: orderID);
      _api.sendMessage(
          tokenID: tokenID,
          title: 'Payment Failed!',
          description:
              'The cafe owner has flagged your order as Rejected due to the issue with your payment. Reach out for assistance. Apologies for any inconvenience.');
    } catch (e) {
       log("Exception thrown while marking Unpaid Order as Failed (Error from Unpaid Order Cubit) => $e");
    }
  }

  @override
  Future<void> close() {
    unpaidOrdersRepository.closeSubscription();
    return super.close();
  }
}
