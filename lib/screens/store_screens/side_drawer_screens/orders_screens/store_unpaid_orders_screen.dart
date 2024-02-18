import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_orders_cubit/unpaid_orders_cubit.dart/unpaid_orders_cubit.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_orders_cubit/unpaid_orders_cubit.dart/unpaid_orders_states.dart';
import 'package:food_cafe/data/services/connectivity_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/screens/store_screens/store_custom_cards/unpaid_orders_screen_card.dart';
import 'package:food_cafe/utils/login_state_check.dart';
import 'package:food_cafe/utils/theme_check.dart';
import 'package:food_cafe/widgets/custom_circular_progress_indicator.dart';
import 'package:food_cafe/widgets/custom_empty_error.dart';
import 'package:food_cafe/widgets/custom_error.dart';
import 'package:food_cafe/widgets/custom_internet_error.dart';

class UnpaidOrdersScreen extends StatefulWidget {
  const UnpaidOrdersScreen({super.key});

  @override
  State<UnpaidOrdersScreen> createState() => _UnpaidOrdersScreenState();
}

class _UnpaidOrdersScreenState extends State<UnpaidOrdersScreen> {
  late UnpaidOrdersCubit _unpaidOrdersCubit;
  late String storeID;

  void _initializeCubits() {
    storeID = checkLoginStateForCafeOwner(
            context: context, screenName: 'Unpaid Orders Screen')
        .value;
    _unpaidOrdersCubit = BlocProvider.of<UnpaidOrdersCubit>(context);
    _unpaidOrdersCubit.initialize(storeID: storeID);
  }

  @override
  void initState() {
    super.initState();
    _initializeCubits();
  }

  @override
  void dispose() {
    super.dispose();
    _unpaidOrdersCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = getTheme(context: context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 25,
              ),
              Text(
                "Unpaid Orders",
                style: theme.textTheme.headlineLarge,
              ),
              const SizedBox(
                height: 10,
              ),
              BlocBuilder<UnpaidOrdersCubit, UnpaidOrdersState>(
                  builder: (context, state) {
                if (state is UnpaidOrdersLoadingState) {
                  return const CustomCircularProgress();
                } else if (state is UnpaidOrdersErrorState &&
                    state.error == 'internetError') {
                  return CustomInternetError(tryAgain: () {
                    _unpaidOrdersCubit.initialize(storeID: storeID);
                  });
                } else if (state is UnpaidOrdersErrorState) {
                  return CustomError(
                      errorMessage: state.error,
                      tryAgain: () {
                        _unpaidOrdersCubit.initialize(storeID: storeID);
                      });
                } else if (state is UnpaidOrdersLoadedState &&
                    state.orders.isEmpty) {
                  return const Expanded(
                      child: CustomEmptyError(
                          message: 'No Orders to show here...'));
                }
                return Expanded(
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      
                      itemCount: state.orders.length,
                      itemBuilder: (context, index) {
                        return unpaidOrders_Card(
                            theme: theme,
                            context: context,
                            requestedOrders_Model: state.orders[index],
                            paymentSuccess: () async {
                              await checkConnectivity(
                                  context: context,
                                  onConnected: () {
                                    _unpaidOrdersCubit.markAsSuccess(
                                      orderID: state.orders[index].orderID!,
                                      storeID: state.orders[index].storeID!,
                                      tokenID: state.orders[index].tokenID!,
                                      price: state.orders[index].totalMRP!,
                                      orderedItems:
                                          state.orders[index].orderItems!,
                                    );
                                  });
                            },
                            paymentFailure: () async {
                              await checkConnectivity(
                                  context: context,
                                  onConnected: () {
                                    _unpaidOrdersCubit.markAsFailure(
                                        orderID: state.orders[index].orderID!,
                                        storeID: state.orders[index].storeID!,
                                        tokenID: state.orders[index].tokenID!);
                                  });
                            });
                      }),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
