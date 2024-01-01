import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/cubits/store_orders_cubit/requestedOrders_cubit/requestedOrders_cubit.dart';
import 'package:food_cafe/cubits/store_orders_cubit/requestedOrders_cubit/requestedOrders_states.dart';
import 'package:food_cafe/cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/data/models/All_Orders_Models.dart';
import 'package:food_cafe/screens/store_screens/store_OrdersScreen.dart';
import 'package:food_cafe/theme.dart';
import 'package:intl/intl.dart';

class RequestedOrdersScreen extends StatefulWidget {
  const RequestedOrdersScreen({super.key});

  @override
  State<RequestedOrdersScreen> createState() => _RequestedOrdersScreenState();
}

class _RequestedOrdersScreenState extends State<RequestedOrdersScreen> {
  late RequestedOrdersCubit requestedOrdersCubit = RequestedOrdersCubit();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestedOrdersCubit = BlocProvider.of<RequestedOrdersCubit>(context);
    requestedOrdersCubit.initialize('SMVDU101');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    requestedOrdersCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;
    final ThemeData theme = themeMode == MyTheme.dark ? darkTheme : lightTheme;
    return SafeArea(
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
              "Requested Orders!",
              style: theme.textTheme.headlineLarge,
            ),
            SizedBox(
              height: 10,
            ),
            BlocBuilder<RequestedOrdersCubit, RequestedOrdersState>(
                builder: (context, state) {
              if (state is RequestedLoadingState) {
                return Center(
                  child: CircularProgressIndicator(color: Colors.black),
                );
              } else if (state is RequestedErrorState) {
                return Center(
                  child: Text(state.message),
                );
              }
              return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: state.orders.length,
                  itemBuilder: (context, index) {
                    return requestedOrders_Card(
                        theme: theme,
                        context: context,
                        requestedOrders_Model: state.orders[index],
                        accept: () {
                          //TODO Add Notification functionlity to inform the user
                          //TODO Change the hardcoded SMVDU101TRX1!
                          requestedOrdersCubit.accept_requested_Order(
                              orderID: state.orders[index].orderID!,
                              tokenID: state.orders[index].tokenID!);
                        },
                        reject: () {
                          //TODO Add Notification functionlity to inform the user
                          requestedOrdersCubit.reject_requested_Order(
                              orderID: state.orders[index].orderID!,
                              tokenID: state.orders[index].tokenID!);
                        });
                  });
            })
          ],
        ),
      ),
    ));
  }
}

Card requestedOrders_Card(
    {required ThemeData theme,
    required BuildContext context,
    required Orders_Model requestedOrders_Model,
    required VoidCallback accept,
    required VoidCallback reject}) {
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
                          color: requestedOrders_Model.isCash == false
                              ? Colors.red
                              : Colors.blue),
                    ),
                    child: Text(
                      requestedOrders_Model.isCash == false ? "Online" : "Cash",
                      style: TextStyle(
                        color: requestedOrders_Model.isCash == false
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
                  Row(
                    children: [
                      TextButton(
                        onPressed: reject,
                        child: Text(
                          "Reject",
                          style: theme.textTheme.titleSmall,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 5.h),
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      TextButton(
                        onPressed: accept,
                        child: Text(
                          "Accept",
                          style: theme.textTheme.titleSmall,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 5.h),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    requestedOrders_Model.orderID!,
                    style: theme.textTheme.bodySmall,
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
