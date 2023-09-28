import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/store_orders_cubit/store_orders_cubit.dart';
import 'package:food_cafe/cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/data/models/All_Orders_Models.dart';
import 'package:food_cafe/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/widgets/headings.dart';
import 'package:intl/intl.dart';

class store_OrdersScreen extends StatefulWidget {
  store_OrdersScreen({Key? key}) : super(key: key);

  @override
  State<store_OrdersScreen> createState() => _store_OrdersScreenState();
}

class _store_OrdersScreenState extends State<store_OrdersScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //TODO Initialize the stream again for Requested Orders!
    context.read<CurrentOrdersCubit>().startListening("SMVDU101");
    context.read<PastOrdersCubit>().startListening("SMVDU101");
    context.read<RequestedOrdersCubit>().startListening("SMVDU101");
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    context.read<RequestedOrdersCubit>().close();
    context.read<PastOrdersCubit>().close();
    context.read<CurrentOrdersCubit>().close();
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
                  "Your Orders!",
                  style: theme.textTheme.headlineLarge,
                ),
                SizedBox(
                  height: 20,
                ),
                BlocBuilder<OrdersTabCubit, int>(
                  builder: (context, state) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          ...List.generate(
                            Tabs.length,
                            (index) => tabContainers(
                                theme: theme,
                                name: Tabs[index],
                                onTap: () {
                                  context
                                      .read<OrdersTabCubit>()
                                      .toggleTab(index);
                                },
                                isCurrentTab: state == index),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                // BlocBuilder<CurrentOrdersCubit,
                //     List<CurrentOrders_Model>>(builder: (context, state) {
                //   return ListView.builder(
                //       physics: NeverScrollableScrollPhysics(),
                //       shrinkWrap: true,
                //       itemCount: state.length,
                //       itemBuilder: (context, index) {
                //         return currentOrders_Card(
                //             theme: theme,
                //             context: context,
                //             currentOrders_Model: state[index],
                //             prepared: () {});
                //       });
                // })
                //TODO Here
                BlocBuilder<OrdersTabCubit, int>(
                  builder: (context, state) {
                    if (state == 2) {
                      return BlocBuilder<PastOrdersCubit,
                          List<PastOrders_Model>>(builder: (context, state) {
                        return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: state.length,
                            itemBuilder: (context, index) {
                              return pastOrder_Card(theme: theme, context: context, pastOrders_Model: state[index], onTap: (){});
                            });
                      });
                    } else if (state == 1) {
                      return BlocBuilder<CurrentOrdersCubit,
                          List<CurrentOrders_Model>>(builder: (context, state) {
                        return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: state.length,
                            itemBuilder: (context, index) {
                              return currentOrders_Card(
                                  theme: theme,
                                  context: context,
                                  currentOrders_Model: state[index],
                                  prepared: () {
                                    //TODO Add a notification functionality to notify user!
                                    context.read<CurrentOrdersCubit>().currentOrder_prepared(state[index].trxID!);
                                  });
                            });
                      });
                    } else if (state == 0) {
                      return BlocBuilder<RequestedOrdersCubit,
                              List<RequestedOrders_Model>>(
                          builder: (context, state) {
                        return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: state.length,
                            itemBuilder: (context, index) {
                              return requestedOrders_Card(
                                  theme: theme,
                                  context: context,
                                  requestedOrders_Model: state[index],
                                  accept: () {
                                    //TODO Add Notification functionlity to inform the user
                                    //TODO Change the hardcoded SMVDU101TRX1!
                                    context
                                        .read<RequestedOrdersCubit>()
                                        .accept_requested_Order(state[index].orderID!);
                                  },
                                  reject: () {
                                    //TODO Add Notification functionlity to inform the user
                                    context.read<RequestedOrdersCubit>().reject_requested_order(state[index].orderID!);
                                  });
                            });
                      });
                    }
                    return Text("Error!");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector pastOrder_Card({
    required ThemeData theme,
    required BuildContext context,
    required PastOrders_Model pastOrders_Model,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
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
                            pastOrders_Model.customerName!,
                            style: theme.textTheme.titleSmall,
                            textAlign: TextAlign.right,
                          ),
                          Text(
                            pastOrders_Model.entryNo!,
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
                        pastOrders_Model.isDineIn == true ? "Dine-In" : "Dine-Out",
                        style: theme.textTheme.titleSmall,
                        // textAlign: TextAlign.right,
                      ),
                      Text(
                        //TODO change timestamp

                        "26 Jan 2023",
                        style: theme.textTheme.bodySmall,
                        // textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10,
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
                        pastOrders_Model.trxID!,
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
                        pastOrders_Model.orderID!,
                        style: theme.textTheme.bodyLarge,
                        // textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "₹ ${pastOrders_Model.totalMRP}",
                    style: theme.textTheme.labelLarge,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 2, color: Colors.green),
                    ),
                    child: Text(
                      "Paid",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'BentonSans_Bold',
                      ),
                      // textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Card currentOrders_Card({
    required ThemeData theme,
    required BuildContext context,
    required CurrentOrders_Model currentOrders_Model,
    required VoidCallback prepared,
  }) {
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
                      currentOrders_Model.customerName!,
                      style: theme.textTheme.titleSmall,
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      currentOrders_Model.entryNo!,
                      style: theme.textTheme.bodySmall,
                      // textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Type: ",
                      style: theme.textTheme.labelMedium,
                      // textAlign: TextAlign.right,
                    ),
                    Text(
                      currentOrders_Model.isDineIn == true
                          ? "Dine-In"
                          : "Dine-Out",
                      style: theme.textTheme.bodyLarge,
                      // textAlign: TextAlign.right,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Ordered on: ",
                      style: theme.textTheme.labelMedium,
                      // textAlign: TextAlign.right,
                    ),
                    Text(
                      "26 Jan, 2023",
                      style: theme.textTheme.bodyLarge,
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
                currentOrders_Model.orderItems!.length,
                (index) => foodRow(
                  theme: theme,
                  foodItem: currentOrders_Model.orderItems![index],
                ),
              ),
            ]),
            Divider(
              thickness: 1,
              color: Colors.grey.shade600,
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
                      currentOrders_Model.trxID!,
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
                      currentOrders_Model.orderID!,
                      style: theme.textTheme.bodyLarge,
                      // textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "₹ ${currentOrders_Model.totalMRP}",
                      style: theme.textTheme.labelLarge,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 2, color: Colors.green),
                      ),
                      child: Text(
                        currentOrders_Model.isPaid == true ? "Paid" : "UnPaid",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'BentonSans_Bold',
                        ),
                        // textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: prepared,
                  child: Text(
                    "Prepared...",
                    style: theme.textTheme.titleSmall,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Card requestedOrders_Card(
      {required ThemeData theme,
      required BuildContext context,
      required RequestedOrders_Model requestedOrders_Model,
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
                    Text(
                      //TODO change timestamp

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
                                : Colors.green),
                      ),
                      child: Text(
                        requestedOrders_Model.isPaid == false
                            ? "UnPaid"
                            : "Paid",
                        style: TextStyle(
                          color: requestedOrders_Model.isPaid == false
                              ? Colors.red
                              : Colors.green,
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

  Row foodRow(
      {required ThemeData theme, required Map<String, dynamic> foodItem}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.food_bank_rounded,
              color: Colors.green,
            ),
            SizedBox(
              width: 5,
            ),
            SizedBox(
              width: 90.w,
              child: Text(
                foodItem['ItemName'],
                style: theme.textTheme.labelSmall,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ),
          ],
        ),
        SizedBox(
          width: 25.w,
          child: Text(
            foodItem['Quantity'].toString(),
            style: theme.textTheme.labelSmall,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        SizedBox(
          width: 50.w,
          child: Text(
            "₹ ${foodItem['Price']}",
            style: theme.textTheme.labelSmall,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  GestureDetector tabContainers({
    required ThemeData theme,
    required String name,
    required VoidCallback onTap,
    required bool isCurrentTab,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        margin: EdgeInsets.only(right: 10),
        alignment: Alignment.center,
        height: 50,
        width: 150,
        duration: Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              width: 3.0,
              color: isCurrentTab == true
                  ? Colors.white
                  : theme.colorScheme.secondary),
          color: theme.colorScheme.secondary,
        ),
        child: Text(
          name,
          style: theme.textTheme.titleSmall,
        ),
      ),
    );
  }

  List<String> Tabs = ["Requested", "Current", "Past"];
}
