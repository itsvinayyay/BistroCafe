import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:food_cafe/cubits/user_role_cubits/payment_cubit/payment_cubit.dart';
import 'package:food_cafe/cubits/user_role_cubits/payment_cubit/payment_states.dart';
import 'package:food_cafe/cubits/common_cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/core/theme/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/cubits/user_role_cubits/billing_cubit/checkout_cubit/billing_checkout_cubit.dart';
import 'package:food_cafe/widgets/custom_text_button.dart';
import 'package:food_cafe/widgets/custom_circular_progress_indicator.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // late PaymentAppCubit paymentAppCubit = PaymentAppCubit();
  late PaymentCubit _paymentCubit = PaymentCubit();
  late BillingCheckOutCubit billingCheckOutCubit;
  late String _orderID;
  @override
  void initState() {
    super.initState();
    // paymentAppCubit = BlocProvider.of(context);
    // paymentAppCubit.loadUpiApps();
    _paymentCubit = BlocProvider.of(context);
    billingCheckOutCubit = BlocProvider.of<BillingCheckOutCubit>(context);
    _orderID = billingCheckOutCubit.receivedOrderID;
    // paymentCubit.initiateTransaction(ordID: _orderID, storeID: 'SMVDU101');
  }

  @override
  void dispose() {
    super.dispose();
    _paymentCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;
    final ThemeData theme = themeMode == MyTheme.dark ? darkTheme : lightTheme;
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 15),
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Text(
                "Demo Payment Gateway",
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(
                height: 20,
              ),

              BlocConsumer<PaymentCubit, PaymentState>(
                listener: (context, state) {
                  if (state is PaymentLoadedState) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, Routes.orderPlaced, (route) => false,
                        arguments: true);
                  }
                  if (state is PaymentErrorState) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, Routes.orderPlaced, (route) => false,
                        arguments: false); //Mark it false if payment fails
                  }
                },
                builder: (context, state) {
                  if (state is PaymentLoadingState) {
                    return const CustomCircularProgress();
                  } else if (state is PaymentLoadedState) {
                    return const Text('Payment Made!');
                  }
                  return customButton(
                      context: context,
                      theme: theme,
                      onPressed: () {
                        _paymentCubit.makeTransactionSuccess(
                            orderID: _orderID, storeID: 'SMVDU101');
                      },
                      title: 'Make Payment');
                },
              ),

              const SizedBox(
                height: 20,
              ),
              BlocConsumer<PaymentCubit, PaymentState>(
                listener: (context, state) {
                  if (state is PaymentLoadedState) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, Routes.orderPlaced, (route) => false,
                        arguments: true);
                  }
                  if (state is PaymentErrorState) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, Routes.orderPlaced, (route) => false,
                        arguments: false); //Mark it false if payment fails
                  }
                },
                builder: (context, state) {
                  if (state is PaymentLoadingState) {
                    return const CustomCircularProgress();
                  } else if (state is PaymentLoadedState) {
                    return const Text('Payment Made!');
                  }
                  return customButton(
                      context: context,
                      theme: theme,
                      onPressed: () {
                        _paymentCubit.makeTransactionFailure(
                            orderID: _orderID, storeID: 'SMVDU101');
                      },
                      title: 'Reject Payment');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
