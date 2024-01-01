import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:food_cafe/cubits/billing_cubit/checkout_cubit/billingCheckout_cubit.dart';
import 'package:food_cafe/cubits/payment_cubit/payment_app_cubit/payment_app_cubit.dart';
import 'package:food_cafe/cubits/payment_cubit/payment_app_cubit/payment_app_states.dart';
import 'package:food_cafe/cubits/payment_cubit/payment_cubit/payment_cubit.dart';
import 'package:food_cafe/cubits/payment_cubit/payment_cubit/payment_states.dart';
import 'package:food_cafe/cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late PaymentAppCubit paymentAppCubit = PaymentAppCubit();
  late PaymentCubit paymentCubit = PaymentCubit();
  late BillingCheckOutCubit billingCheckOutCubit;
  late String _orderID;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    paymentAppCubit = BlocProvider.of(context);
    paymentAppCubit.loadUpiApps();
    paymentCubit = BlocProvider.of(context);
    billingCheckOutCubit = BlocProvider.of<BillingCheckOutCubit>(context);
    _orderID = billingCheckOutCubit.receivedOrderID;
    // paymentCubit.initiateTransaction(ordID: _orderID, storeID: 'SMVDU101');
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;
    final ThemeData theme = themeMode == MyTheme.dark ? darkTheme : lightTheme;
    return BlocListener<PaymentCubit, PaymentState>(
      listener: (context, state) {
        if (state is PaymentLoadedState) {
          Navigator.pushNamedAndRemoveUntil(
              context, Routes.orderPlaced, (route) => false,
              arguments: true);
        }
        if (state is PaymentErrorState) {
          Navigator.pushNamedAndRemoveUntil(
              context, Routes.orderPlaced, (route) => false,
              arguments: true);//Mark it false if payment fails
        }
      },
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 15),
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Text(
                  "UPI Apps Available",
                  style: theme.textTheme.titleMedium,
                ),
                SizedBox(
                  height: 20,
                ),
                BlocBuilder<PaymentAppCubit, PaymentAppsState>(
                    builder: (context, state) {
                  if (state is PaymentAppLoadingState) {
                    return Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  } else if (state is PaymentAppErrorState) {
                    Center(
                      child: Text(state.message),
                    );
                  }
                  return SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Wrap(
                      children: [
                        ...List.generate(state.upiApps.length, (index) {
                          final app = state.upiApps[index];
                          return GestureDetector(
                            onTap: () {
                              paymentCubit.initiateTransaction(
                                  app: app,
                                  ordID: _orderID,
                                  storeID: 'SMVDU101');
                            },
                            child: Container(
                              height: 100,
                              width: 100,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.memory(
                                    app.icon,
                                    height: 60,
                                    width: 60,
                                  ),
                                  Text(app.name),
                                ],
                              ),
                            ),
                          );
                        })
                      ],
                    ),
                  );
                })
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
