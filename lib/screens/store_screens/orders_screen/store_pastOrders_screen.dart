import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/store_orders_cubit/pastOrders_cubit/pastOrders_cubit.dart';
import 'package:food_cafe/cubits/store_orders_cubit/pastOrders_cubit/pastOrders_state.dart';
import 'package:food_cafe/cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/data/models/All_Orders_Models.dart';
import 'package:food_cafe/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';



class PastOrdersScreen extends StatefulWidget {
  const PastOrdersScreen({Key? key}) : super(key: key);

  @override
  State<PastOrdersScreen> createState() => _PastOrdersScreenState();
}

class _PastOrdersScreenState extends State<PastOrdersScreen> {
  late PastOrdersCubit pastOrdersCubit = PastOrdersCubit();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pastOrdersCubit = BlocProvider.of<PastOrdersCubit>(context);
    pastOrdersCubit.initialize('SMVDU101');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pastOrdersCubit.close();
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
                  "Past Orders!",
                  style: theme.textTheme.headlineLarge,
                ),
                SizedBox(
                  height: 10,
                ),
                BlocBuilder<PastOrdersCubit, PastOrdersState>(
                    builder: (context, state) {
                  if (state is PastLoadingState) {
                    return Center(
                      child: CircularProgressIndicator(color: Colors.black),
                    );
                  } else if (state is PastErrorState) {
                    return Center(
                      child: Text(state.message),
                    );
                  }
                  return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: state.orders.length,
                      itemBuilder: (context, index) {
                        return pastOrder_Card(
                            theme: theme,
                            context: context,
                            pastOrders_Model: state.orders[index],
                            onTap: () {});
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

GestureDetector pastOrder_Card({
  required ThemeData theme,
  required BuildContext context,
  required Orders_Model pastOrders_Model,
  required VoidCallback onTap,
}) {
  String time = DateFormat('hh:mm a').format(pastOrders_Model.time!.toDate());
  String date = DateFormat('d MMM y').format(pastOrders_Model.time!.toDate());
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
                      pastOrders_Model.isDineIn == true
                          ? "Dine-In"
                          : "Dine-Out",
                      style: theme.textTheme.titleSmall,
                      // textAlign: TextAlign.right,
                    ),
                    if (pastOrders_Model.isDineIn == false)
                      Text(
                        pastOrders_Model.hostelName!,
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
