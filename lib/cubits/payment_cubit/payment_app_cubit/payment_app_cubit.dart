import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/payment_cubit/payment_app_cubit/payment_app_states.dart';
import 'package:upi_india/upi_india.dart';



class PaymentAppCubit extends Cubit<PaymentAppsState> {
  PaymentAppCubit() : super(PaymentAppInitialState());

  late List<UpiApp> apps;
  final _upiIndia = UpiIndia();

  void loadUpiApps() async {
    emit(PaymentAppLoadingState(state.upiApps));
    try {
      apps = await _upiIndia.getAllUpiApps(mandatoryTransactionId: false);
      emit(PaymentAppLoadedState(apps));
    } catch (e) {
      log("Error thrown while displaying Apps from Payment App Cubit ");
      emit(PaymentAppErrorState(state.upiApps, e.toString()));
    }
  }
}
