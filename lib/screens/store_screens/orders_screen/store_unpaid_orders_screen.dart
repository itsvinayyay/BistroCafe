import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/login_cubit/login_cubit.dart';
import 'package:food_cafe/cubits/login_cubit/login_state.dart';
import 'package:food_cafe/cubits/store_orders_cubit/unpaid_orders_cubit.dart/unpaid_orders_cubit.dart';
import 'package:food_cafe/cubits/store_orders_cubit/unpaid_orders_cubit.dart/unpaid_orders_states.dart';
import 'package:food_cafe/cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/data/models/All_Orders_Models.dart';
import 'package:food_cafe/screens/store_screens/store_OrdersScreen.dart';
import 'package:food_cafe/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class UnpaidOrdersScreen extends StatefulWidget {
  const UnpaidOrdersScreen({Key? key}) : super(key: key);

  @override
  State<UnpaidOrdersScreen> createState() => _UnpaidOrdersScreenState();
}

class _UnpaidOrdersScreenState extends State<UnpaidOrdersScreen> {
  late UnpaidOrdersCubit unpaidOrdersCubit;
  late String storeID;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final state = context.read<LoginCubit>().state;
    if (state is CafeLoginLoadedState) {
      storeID = state.storeID;
    } else {
      log("Some State Error Occured in Past Orders Screen");

      storeID = "error";
    }
    unpaidOrdersCubit = BlocProvider.of<UnpaidOrdersCubit>(context);
    unpaidOrdersCubit.initialize(storeID: storeID);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    unpaidOrdersCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;
    final ThemeData theme = themeMode == MyTheme.dark ? darkTheme : lightTheme;
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 25,
                ),
                Text(
                  "Unpaid Orders!",
                  style: theme.textTheme.headlineLarge,
                ),
                SizedBox(
                  height: 10,
                ),
                BlocBuilder<UnpaidOrdersCubit, UnpaidOrdersState>(
                    builder: (context, state) {
                  if (state is UnpaidOrdersLoadingState) {
                    return Center(
                      child: CircularProgressIndicator(color: Colors.black),
                    );
                  } else if (state is UnpaidOrdersErrorState) {
                    return Center(
                      child: Text(state.error),
                    );
                  }
                  return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: state.orders.length,
                      itemBuilder: (context, index) {
                        return unpaidOrders_Card(
                            theme: theme,
                            context: context,
                            requestedOrders_Model: state.orders[index],
                            paymentSuccess: () {
                              unpaidOrdersCubit.markAsSuccess(
                                  orderID: state.orders[index].orderID!,
                                  storeID: state.orders[index].storeID!,
                                  tokenID: state.orders[index].tokenID!,
                                  price: state.orders[index].totalMRP!,
                                  orderedItems: state.orders[index].orderItems!,
                                  );
                            },
                            paymentFailure: () {
                              unpaidOrdersCubit.markAsFailure(
                                  orderID: state.orders[index].orderID!,
                                  storeID: state.orders[index].storeID!,
                                  tokenID: state.orders[index].tokenID!);
                            });
                      });
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Card unpaidOrders_Card(
    {required ThemeData theme,
    required BuildContext context,
    required Orders_Model requestedOrders_Model,
    required VoidCallback paymentSuccess,
    required VoidCallback paymentFailure}) {
  String time =
      DateFormat('hh:mm a').format(requestedOrders_Model.time!.toDate());
  String date =
      DateFormat('d MMM y').format(requestedOrders_Model.time!.toDate());
  return Card(
    elevation: 8,
    shadowColor: theme.colorScheme.secondary,
    color: theme.colorScheme.primary,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20.sp,
                    child: Icon(
                      Icons.person,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        requestedOrders_Model.customerName!,
                        style: theme.textTheme.titleSmall,
                        textAlign: TextAlign.right,
                      ),
                      Text(
                        requestedOrders_Model.entryNo!,
                        style: theme.textTheme.bodySmall,
                        // textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    requestedOrders_Model.isDineIn == true
                        ? "Dine-In"
                        : "Dine-Out",
                    style: theme.textTheme.titleSmall,
                    // textAlign: TextAlign.right,
                  ),
                  if (requestedOrders_Model.isDineIn == false)
                    Text(
                      requestedOrders_Model.hostelName!,
                      style: theme.textTheme.titleSmall,
                      // textAlign: TextAlign.right,
                    ),
                  Text(
                    "$date | $time",
                    style: theme.textTheme.bodySmall,
                    // textAlign: TextAlign.right,
                  ),
                ],
              ),
            ],
          ),
          Divider(
            thickness: 1,
            color: Colors.grey.shade600,
          ),
          Column(children: [
            ...List.generate(
              requestedOrders_Model.orderItems!.length,
              (index) => foodRow(
                theme: theme,
                foodItem: requestedOrders_Model.orderItems![index],
              ),
            ),
          ]),
          Divider(
            thickness: 1,
            color: Colors.grey.shade600,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "₹ ${requestedOrders_Model.totalMRP}",
                    style: theme.textTheme.labelLarge,
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          width: 2,
                          color: requestedOrders_Model.isPaid == false
                              ? Colors.red
                              : Colors.blue),
                    ),
                    child: Text(
                      requestedOrders_Model.isPaid == false ? "Online" : "Cash",
                      style: TextStyle(
                        color: requestedOrders_Model.isPaid == false
                            ? Colors.red
                            : Colors.blue,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'BentonSans_Bold',
                      ),
                      // textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: paymentFailure,
                    child: Text(
                      "Payment Failed",
                      style: theme.textTheme.titleSmall,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                    ),
                  ),
                  TextButton(
                    onPressed: paymentSuccess,
                    child: Text(
                      "Payment Success",
                      style: theme.textTheme.titleSmall,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: [
              Row(
                children: [
                  Text(
                    "Transaction ID: ",
                    style: theme.textTheme.labelMedium,
                    // textAlign: TextAlign.right,
                  ),
                  Text(
                    requestedOrders_Model.trxID!,
                    style: theme.textTheme.bodyLarge,
                    // textAlign: TextAlign.right,
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Order ID: ",
                    style: theme.textTheme.labelMedium,
                    // textAlign: TextAlign.right,
                  ),
                  Text(
                    requestedOrders_Model.orderID!,
                    style: theme.textTheme.bodyLarge,
                    // textAlign: TextAlign.right,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
