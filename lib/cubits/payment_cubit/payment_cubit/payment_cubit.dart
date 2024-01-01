import 'dart:developer';

import 'package:easy_upi_payment/easy_upi_payment.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/payment_cubit/payment_cubit/payment_states.dart';
import 'package:food_cafe/data/repository/payment_repository/payment_repository.dart';
import 'package:upi_india/upi_india.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentInitialState());

  final _upiIndia = UpiIndia();
  Future<UpiResponse>? _transaction;
  PaymentRepository _paymentRepository = PaymentRepository();
  final easyUPIPayment = EasyUpiPaymentPlatform.instance;

  Future<void> initiateTransaction(
      {required UpiApp app,
      required String ordID,
      required String storeID}) async {
    try {
      emit(PaymentLoadingState());

      Map<String, dynamic> impDetails =
          await _paymentRepository.getDetails(ordID: ordID, storeID: storeID);
      String trxID = impDetails['trxID'];
      int amount = impDetails['total'];
      _transaction = _upiIndia.startTransaction(
          app: app,
          receiverUpiId: '7048900990@paytm',
          receiverName: 'Vinay Vashist',
          transactionRefId: trxID,
          amount: amount.toDouble(),
          transactionNote: 'Purchase of an Order');
      
      // final response = await easyUPIPayment.startPayment(EasyUpiPaymentModel(
      //     payeeVpa: '7048900990@paytm',
      //     payeeName: 'Vinay Vashist',
      //     amount: amount.toDouble(),
      //     description: 'Purchase of an Order',
      //     transactionRefId: trxID));

      if (_transaction == null) {
        throw Exception('The transaction Initiated is NULL');
      }
      // if (response == null) {
      //   throw Exception('The transaction Initiated is NULL');
      // }

      UpiResponse upiResponse = await _transaction!;
      bool isTransactionSuccessful =
          upiResponse.status == UpiPaymentStatus.SUCCESS;
      String receivedUPIID = upiResponse.transactionId!;

      emit(PaymentLoadedState(
          paymentStatus: isTransactionSuccessful,
          upiID: receivedUPIID)); //Need to pass the payment status in the state.
    } catch (e) {
      log("Error while Initiating Payment from Payment Cubit => $e");
      emit(PaymentErrorState(message: e.toString()));
    }
  }
}
