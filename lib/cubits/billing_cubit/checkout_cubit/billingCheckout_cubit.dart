import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/core/api.dart';
import 'package:food_cafe/cubits/billing_cubit/checkout_cubit/billingCheckout_state.dart';
import 'package:food_cafe/data/repository/billing_repository/billing_repository.dart';

class BillingCheckOutCubit extends Cubit<BillingCheckoutState> {
  BillingCheckOutCubit() : super(BillingCheckoutInitialState());
  final billingRepository = BillingRepository();
  late String receivedOrderID;

  Future<void> billingCheckout(
      {required String customerName,
      required String personID,
      required int totalMRP,
      required bool isDineIn,
      required bool isCash,
      required String storeID,
      required String hostelName,
      required String userTokenID}) async {
    emit(BillingCheckoutLoadingState());
    Api _api = Api();

    try {
      receivedOrderID = await billingRepository.billCheckOut(
        customerName: customerName,
        personID: personID,
        totalMRP: totalMRP,
        isDineIn: isDineIn,
        isCash: isCash,
        storeID: storeID,
        hostelName: hostelName,
        tokenID: userTokenID,
      );
      String tokenID = await billingRepository.extractCafeOwnerTokenID(storeID);
      await billingRepository.updateOrderHistory(
          orderID: receivedOrderID, personID: personID);

      // await billingRepository.updateCart(personID: personID);

      await _api.sendMessage(
          tokenID: tokenID,
          title: 'Order Request',
          description: 'An Order is Requested by the User');
      await billingRepository.updateDailyAnalytics(storeID: storeID);

      emit(BillingCheckoutLoadedState());
    } catch (e) {
      log("Exception thrown while Checkout in BillingCubit");
      emit(BillingCheckoutErrorState(e.toString()));
    }
  }
}
