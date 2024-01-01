import 'dart:developer';
import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/billing_cubit/checkout_cubit/billingCheckout_cubit.dart';
import 'package:food_cafe/cubits/order_status_cubit/orderStatus_cubit.dart';
import 'package:food_cafe/cubits/order_status_cubit/orderStatus_states.dart';

import 'package:food_cafe/cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:food_cafe/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderRequestedScreen extends StatefulWidget {
  OrderRequestedScreen({Key? key}) : super(key: key);

  @override
  State<OrderRequestedScreen> createState() => _OrderRequestedScreenState();
}

class _OrderRequestedScreenState extends State<OrderRequestedScreen> {
  late BillingCheckOutCubit billingCheckOutCubit;
  late OrderStatusCubit orderStatusCubit;
  late String _orderID;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    billingCheckOutCubit = BlocProvider.of<BillingCheckOutCubit>(context);
    orderStatusCubit = BlocProvider.of<OrderStatusCubit>(context);
    _orderID = billingCheckOutCubit.receivedOrderID;
    log(_orderID);
    orderStatusCubit.initialize(orderID: _orderID, storeID: 'SMVDU101');
  }
  

  @override
  Widget build(BuildContext context) {
    final bool isCash = ModalRoute.of(context)!.settings.arguments as bool;
    final themeMode = context.watch<ThemeCubit>().state;
    final ThemeData theme = themeMode == MyTheme.dark ? darkTheme : lightTheme;
    return BlocListener<OrderStatusCubit, OrderStatus>(
      listener: (context, state) {
        if (state is StatusErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.toString(),
              ),
            ),
          );
        } else if (state is StatusLoadedState) {
          if (state.orderStatus == 'Preparing' && isCash == false) {
            //TODO isCash true
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.paymentScreen,
              (route) => false,
            );
          } else if (state.orderStatus == 'Preparing' && isCash == true) {
            //TODO isCash true
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.orderPlaced, (route) => false,
                arguments: true);
          }
          //TODO: Preparing and isCash false
          else if (state.orderStatus == 'Rejected') {
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.orderPlaced, (route) => false,
                arguments: false);
          }
        }
      },
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset("assets/images/requestOrder.gif")),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Please Wait!",
                    style: TextStyle(
                      fontSize: 30.sp,
                      fontFamily: "BentonSans_Bold",
                      fontWeight: FontWeight.w400,
                      color: theme.colorScheme.tertiary,
                    ),
                  ),
                  SizedBox(
                    width: 250.w,
                    child: Text(
                      "While the Cafe Owner confirms your Order...",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelSmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
