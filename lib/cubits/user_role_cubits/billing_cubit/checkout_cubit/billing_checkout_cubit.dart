import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/core/api.dart';
import 'package:food_cafe/cubits/user_role_cubits/billing_cubit/checkout_cubit/billing_checkout_states.dart';
import 'package:food_cafe/data/repository/user_role_repositories/billing_repository.dart';

class BillingCheckOutCubit extends Cubit<BillingCheckoutState> {
  BillingCheckOutCubit() : super(BillingCheckoutInitialState());
  final BillingRepository _billingRepository = BillingRepository();
  late String receivedOrderID;

  /// Perform the checkout process for a cafe billing.
  ///
  /// This method initiates the billing checkout process, updating the state
  /// to [BillingCheckoutLoadingState] during the operation.
  ///
  /// Parameters:
  /// - [customerName]: The name of the customer placing the order.
  /// - [personID]: The ID of the person placing the order.
  /// - [totalMRP]: The total cost of the order in MRP (assuming it's a currency or pricing unit).
  /// - [isDineIn]: A boolean indicating whether the order is for dine-in.
  /// - [isCash]: A boolean indicating whether the payment is in cash.
  /// - [storeID]: The ID of the store or cafe where the order is being placed.
  /// - [hostelName]: The name of the hostel where the order is being placed.
  /// - [userTokenID]: The token ID of the user initiating the order.
  ///
  /// Throws an exception if any error occurs during the process, leading to an
  /// [BillingCheckoutErrorState]. Upon successful completion, updates the order history,
  /// sends a notification to the cafe owner, updates daily analytics, and sets the
  /// state to [BillingCheckoutLoadedState].
  ///
  /// Note: This method assumes the existence of the [_billingRepository], [Api], and other
  /// relevant objects used in the implementation.
  Future<void> billingCheckout({
    required String customerName,
    required String personID,
    required int totalMRP,
    required bool isDineIn,
    required bool isCash,
    required String storeID,
    required String hostelName,
    required String userTokenID,
  }) async {
    // Emitting the loading state to indicate the start of the checkout process.
    emit(BillingCheckoutLoadingState());

    // Initializing an instance of the Api class.
    Api api = Api();
    await api.initialize();

    try {
      // Performing the billing checkout using the billing repository.
      receivedOrderID = await _billingRepository.billCheckOut(
        customerName: customerName,
        personID: personID,
        totalMRP: totalMRP,
        isDineIn: isDineIn,
        isCash: isCash,
        storeID: storeID,
        hostelName: hostelName,
        tokenID: userTokenID,
      );

      // Extracting the cafe owner's token ID.
      String tokenID =
          await _billingRepository.extractCafeOwnerTokenID(storeID);

      // Sending a notification to the cafe owner about the order request.
      await api.sendMessage(
        tokenID: tokenID,
        title: 'Order Request',
        description: 'An Order is Requested by the User',
      );

      // Updating daily analytics for the cafe.
      await _billingRepository.updateDailyAnalytics(storeID: storeID);

      // Updating monthly analytics for the cafe.
      await _billingRepository.updateMonthlyAnalytics(storeID: storeID);

      // //Clearing User's Cart
      // await _billingRepository.updateCart(personID: personID);

      // Setting the state to indicate successful completion.
      emit(BillingCheckoutLoadedState());
    } catch (e) {
      // Logging and emitting an error state if an exception occurs.
      log("Exception thrown while Checkout in BillingCubit");
      emit(BillingCheckoutErrorState(e.toString()));
    }
  }
}
