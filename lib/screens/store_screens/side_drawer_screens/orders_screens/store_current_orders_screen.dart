import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_orders_cubit/currentOrders_cubit/current_orders_cubit.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_orders_cubit/currentOrders_cubit/current_orders_states.dart';

import 'package:food_cafe/data/services/connectivity_service.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/screens/store_screens/store_custom_cards/current_orders_screen_card.dart';
import 'package:food_cafe/utils/login_state_check.dart';
import 'package:food_cafe/utils/theme_check.dart';
import 'package:food_cafe/widgets/custom_circular_progress_indicator.dart';
import 'package:food_cafe/widgets/custom_empty_error.dart';
import 'package:food_cafe/widgets/custom_error.dart';
import 'package:food_cafe/widgets/custom_internet_error.dart';

class CurrentOrdersScreen extends StatefulWidget {
  const CurrentOrdersScreen({super.key});

  @override
  State<CurrentOrdersScreen> createState() => _CurrentOrdersScreenState();
}

class _CurrentOrdersScreenState extends State<CurrentOrdersScreen> {
  late CurrentOrdersCubit _currentOrdersCubit = CurrentOrdersCubit();
  late String storeID;

  void _initializeCubits() {
    storeID = checkLoginStateForCafeOwner(
            context: context, screenName: 'Current Orders Screen')
        .value;
    _currentOrdersCubit = BlocProvider.of<CurrentOrdersCubit>(context);
    _currentOrdersCubit.initialize(storeID);
  }

  @override
  void initState() {
    super.initState();
    _initializeCubits();
  }

  @override
  void dispose() {
    super.dispose();
    _currentOrdersCubit.close();
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
                "Current Orders",
                style: theme.textTheme.headlineLarge,
              ),
              const SizedBox(
                height: 10,
              ),
              BlocBuilder<CurrentOrdersCubit, CurrentOrdersState>(
                  builder: (context, state) {
                if (state is CurrentLoadingState) {
                  return const CustomCircularProgress();
                } else if (state is CurrentErrorState &&
                    state.message == 'internetError') {
                  return CustomInternetError(tryAgain: () {
                    _currentOrdersCubit.initialize(storeID);
                  });
                } else if (state is CurrentErrorState) {
                  return CustomError(
                      errorMessage: state.message,
                      tryAgain: () {
                        _currentOrdersCubit.initialize(storeID);
                      });
                } else if (state is CurrentLoadedState &&
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
                        return currentOrdersCard(
                            theme: theme,
                            context: context,
                            currentOrders_Model: state.orders[index],
                            prepared: () async {
                              await checkConnectivity(
                                  context: context,
                                  onConnected: () async {
                                    await checkConnectivity(
                                        context: context,
                                        onConnected: () {
                                          _currentOrdersCubit
                                              .markCurrentOrderPrepared(
                                                  orderID: state
                                                      .orders[index].orderID!,
                                                  tokenID: state
                                                      .orders[index].tokenID!);
                                        });
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
