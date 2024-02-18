import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/user_role_cubits/order_history_cubit/order_history_cubit.dart';
import 'package:food_cafe/cubits/user_role_cubits/order_history_cubit/order_history_states.dart';
import 'package:food_cafe/data/models/store_order_model.dart';
import 'package:food_cafe/screens/store_screens/side_drawer_screens/orders_screens/store_orders_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/utils/login_state_check.dart';
import 'package:food_cafe/utils/theme_check.dart';
import 'package:food_cafe/widgets/custom_back_button.dart';
import 'package:food_cafe/widgets/custom_circular_progress_indicator.dart';
import 'package:food_cafe/widgets/custom_empty_error.dart';
import 'package:food_cafe/widgets/custom_error.dart';
import 'package:food_cafe/widgets/custom_internet_error.dart';
import 'package:intl/intl.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  late OrderHistoryCubit _orderHistoryCubit;
  late String personID;
  String storeID = 'SMVDU101';

  void _initializeCubits() {
    personID = checkLoginStateForUser(
        context: context, screenName: 'Order History Screen');
    _orderHistoryCubit = BlocProvider.of<OrderHistoryCubit>(context);
    _orderHistoryCubit.initiateFetch(personID: personID, storeID: storeID);
  }

  @override
  void initState() {
    super.initState();
    _initializeCubits();
  }

  @override
  void dispose() {
    super.dispose();
    _orderHistoryCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = getTheme(context: context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
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
                BlocBuilder<OrderHistoryCubit, OrderHistoryStates>(
                  builder: (context, state) {
                    if (state is OrderHistoryLoadingState) {
                      return const CustomCircularProgress();
                    } else if (state is OrderHistoryErrorState &&
                        state.error == 'internetError') {
                      return CustomInternetError(tryAgain: () {
                        _orderHistoryCubit.initiateFetch(
                            personID: personID, storeID: storeID);
                      });
                    } else if (state is OrderHistoryErrorState) {
                      return CustomError(
                          errorMessage: state.error,
                          tryAgain: () {
                            _orderHistoryCubit.initiateFetch(
                                personID: personID, storeID: storeID);
                          });
                    } else if (state is OrderHistoryLoadedState &&
                        state.orders.isEmpty) {
                      return const CustomEmptyError(
                          message: "There's nothing to show here!");
                    }
                    return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
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
    required OrderModel orderModel,
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
