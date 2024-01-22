import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/login_cubit/login_cubit.dart';
import 'package:food_cafe/cubits/login_cubit/login_state.dart';
import 'package:food_cafe/cubits/order_history_cubit/order_history_cubit.dart';
import 'package:food_cafe/cubits/order_history_cubit/order_history_states.dart';
import 'package:food_cafe/cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/data/models/All_Orders_Models.dart';
import 'package:food_cafe/screens/store_screens/store_OrdersScreen.dart';
import 'package:food_cafe/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/widgets/custom_BackButton.dart';
import 'package:intl/intl.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  late OrderHistoryCubit orderHistoryCubit;
  late String personID;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    super.initState();
    final state = context.read<LoginCubit>().state;
    if (state is LoginLoggedInState) {
      personID = state.personID;
    } else {
      log("Some State Error Occured in Order History Screen");
      personID = "error";
    }
    orderHistoryCubit = BlocProvider.of<OrderHistoryCubit>(context);
    orderHistoryCubit.initiateFetch(personID: personID);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    orderHistoryCubit.close();
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
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customBackButton(context, theme),
                Text(
                  "Order History",
                  style: theme.textTheme.titleLarge,
                ),
                SizedBox(
                  height: 20,
                ),
                BlocBuilder<OrderHistoryCubit, OrderHistoryStates>(
                  builder: (context, state) {
                    if (state is OrderHistoryLoadingState) {
                      return Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    } else if (state is OrderHistoryErrorState) {
                      return Center(
                        child: Text(state.error),
                      );
                    }
                    return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: state.orders.length,
                        itemBuilder: (context, index) {
                          return _buildOrderHistoryCard(
                              theme: theme,
                              context: context,
                              orderModel: state.orders[index]);
                        });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Card _buildOrderHistoryCard({
    required ThemeData theme,
    required BuildContext context,
    required Orders_Model orderModel,
  }) {
    String time = DateFormat('hh:mm a').format(orderModel.time!.toDate());
    String date = DateFormat('d MMM y').format(orderModel.time!.toDate());
    return Card(
      elevation: 8,
      shadowColor: theme.colorScheme.secondary,
      color: theme.colorScheme.primary,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              orderModel.isDineIn == true ? "Dine-In" : "Dine-Out",
              style: theme.textTheme.titleSmall,
            ),
            if (orderModel.isDineIn == false)
              Row(
                children: [
                  Text(
                    "Hostel Name: ",
                    style: theme.textTheme.labelMedium,
                    // textAlign: TextAlign.right,
                  ),
                  Text(
                    orderModel.hostelName!,
                    style: theme.textTheme.bodyLarge,
                    // textAlign: TextAlign.right,
                  ),
                ],
              ),
            Text(
              "$date | $time",
              style: theme.textTheme.bodySmall,
            ),
            Divider(
              thickness: 1,
              color: Colors.grey.shade600,
            ),
            Column(children: [
              ...List.generate(
                orderModel.orderItems!.length,
                (index) => foodRow(
                  theme: theme,
                  foodItem: orderModel.orderItems![index],
                ),
              ),
            ]),
            Divider(
              thickness: 1,
              color: Colors.grey.shade600,
            ),
            Row(
              children: [
                Text(
                  "Transaction ID: ",
                  style: theme.textTheme.labelMedium,
                  // textAlign: TextAlign.right,
                ),
                Text(
                  orderModel.trxID!,
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
                  orderModel.orderID!,
                  style: theme.textTheme.bodyLarge,
                  // textAlign: TextAlign.right,
                ),
              ],
            ),
            Text(
              "₹ ${orderModel.totalMRP}",
              style: theme.textTheme.labelLarge,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    width: 2,
                    color:
                        orderModel.isCash == true ? Colors.blue : Colors.red),
              ),
              child: Text(
                orderModel.isCash == true ? "Cash" : "Online",
                style: TextStyle(
                  color: orderModel.isCash == true ? Colors.blue : Colors.red,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'BentonSans_Bold',
                ),
                // textAlign: TextAlign.right,
              ),
            ),
            if (orderModel.isCash == false)
              Row(
                children: [
                  Text(
                    "Payment Status: ",
                    style: theme.textTheme.labelMedium,
                    // textAlign: TextAlign.right,
                  ),
                  Text(
                    orderModel.isPaid! ? 'Done' : ' Not Done',
                    style: theme.textTheme.bodyLarge!.copyWith(
                        color: Colors.green, fontWeight: FontWeight.w900),
                    // textAlign: TextAlign.right,
                  ),
                ],
              ),
            Row(
              children: [
                Text(
                  "Order Status: ",
                  style: theme.textTheme.labelMedium,
                  // textAlign: TextAlign.right,
                ),
                Text(
                  '${orderModel.orderStatus}',
                  style: theme.textTheme.bodyLarge!.copyWith(
                      color: Colors.green, fontWeight: FontWeight.w900),
                  // textAlign: TextAlign.right,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
