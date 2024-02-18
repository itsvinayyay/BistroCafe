import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/user_role_cubits/requested_order_status_cubit/requested_order_status_cubit.dart';
import 'package:food_cafe/cubits/user_role_cubits/requested_order_status_cubit/requested_order_status_state.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/cubits/user_role_cubits/billing_cubit/checkout_cubit/billing_checkout_cubit.dart';
import 'package:food_cafe/utils/order_status.dart';
import 'package:food_cafe/utils/theme_check.dart';
import 'package:food_cafe/widgets/custom_text_button.dart';

class OrderRequestedScreen extends StatefulWidget {
  final bool isPaymentCash;
  const OrderRequestedScreen({super.key, required this.isPaymentCash});

  @override
  State<OrderRequestedScreen> createState() => _OrderRequestedScreenState();
}

class _OrderRequestedScreenState extends State<OrderRequestedScreen> {
  late BillingCheckOutCubit _billingCheckOutCubit;
  late RequestedOrderStatusCubit _orderStatusCubit;
  late String _orderID;

  void _initializeCubits() {
    _billingCheckOutCubit = BlocProvider.of<BillingCheckOutCubit>(context);
    _orderStatusCubit = BlocProvider.of<RequestedOrderStatusCubit>(context);
    _orderID = _billingCheckOutCubit.receivedOrderID;
    _orderStatusCubit.initialize(orderID: _orderID, storeID: 'SMVDU101');
  }

  @override
  void initState() {
    _initializeCubits();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _orderStatusCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = getTheme(context: context);
    return BlocListener<RequestedOrderStatusCubit, RequestedOrderStatusStates>(
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
          if (state.orderStatus == OrderStatus.unpaid) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.makePaymentScreen,
              (route) => false,
            );
          } else if (state.orderStatus == OrderStatus.preparing) {
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.orderPlaced, (route) => false,
                arguments: true);
          } else if (state.orderStatus == OrderStatus.rejected) {
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
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset("assets/images/requestOrder.gif")),
                  const SizedBox(
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
                  SizedBox(
                    height: 30,
                  ),
                  customButton(
                      context: context,
                      theme: theme,
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, Routes.bottomNav, (route) => false);
                      },
                      title: "Back to Home"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
