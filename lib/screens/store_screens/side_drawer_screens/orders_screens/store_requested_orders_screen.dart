import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_orders_cubit/requestedOrders_cubit/requested_orders_cubit.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_orders_cubit/requestedOrders_cubit/requested_orders_states.dart';
import 'package:food_cafe/data/services/connectivity_service.dart';
import 'package:food_cafe/data/services/notification_services.dart';
import 'package:food_cafe/screens/store_screens/store_custom_cards/requested_orders_screen_card.dart';
import 'package:food_cafe/utils/login_state_check.dart';
import 'package:food_cafe/utils/theme_check.dart';
import 'package:food_cafe/widgets/custom_circular_progress_indicator.dart';
import 'package:food_cafe/widgets/custom_empty_error.dart';
import 'package:food_cafe/widgets/custom_error.dart';
import 'package:food_cafe/widgets/custom_internet_error.dart';

class RequestedOrdersScreen extends StatefulWidget {
  const RequestedOrdersScreen({super.key});

  @override
  State<RequestedOrdersScreen> createState() => _RequestedOrdersScreenState();
}

class _RequestedOrdersScreenState extends State<RequestedOrdersScreen> {
  final NotificationServices _notificationServices = NotificationServices();
  late RequestedOrdersCubit _requestedOrdersCubit = RequestedOrdersCubit();
  late String storeID;

  void _initializeCubits() {
    storeID = checkLoginStateForCafeOwner(
            context: context, screenName: 'Requested Orders Screen')
        .value;
    _requestedOrdersCubit = BlocProvider.of<RequestedOrdersCubit>(context);
    _requestedOrdersCubit.initialize(storeID);
  }

  @override
  void initState() {
    super.initState();
    _initializeCubits();
    _notificationServices.isTokenRefresh(storeID: storeID);
  }

  @override
  void dispose() {
    super.dispose();
    _requestedOrdersCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = getTheme(context: context);
    return SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 25,
              ),
              Text(
                "Requested Orders",
                style: theme.textTheme.headlineLarge,
              ),
              const SizedBox(
                height: 10,
              ),
              BlocBuilder<RequestedOrdersCubit, RequestedOrdersState>(
                  builder: (context, state) {
                if (state is RequestedLoadingState) {
                  return const CustomCircularProgress();
                } else if (state is RequestedErrorState &&
                    state.message == 'internetError') {
                  return CustomInternetError(tryAgain: () {
                    _requestedOrdersCubit.initialize(storeID);
                  });
                } else if (state is RequestedErrorState) {
                  return CustomError(
                      errorMessage: state.message,
                      tryAgain: () {
                        _requestedOrdersCubit.initialize(storeID);
                      });
                } else if (state is RequestedLoadedState &&
                    state.orders.isEmpty) {
                  return Expanded(child: CustomEmptyError(message: 'No Orders to show here...'));
                }
                return Expanded(
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: state.orders.length,
                      itemBuilder: (context, index) {
                        return requestedOrders_Card(
                            theme: theme,
                            context: context,
                            requestedOrders_Model: state.orders[index],
                            accept: () async {
                              await checkConnectivity(
                                  context: context,
                                  onConnected: () {
                                    _requestedOrdersCubit.acceptRequestedOrder(
                                        orderID: state.orders[index].orderID!,
                                        tokenID: state.orders[index].tokenID!,
                                        isPaid: state.orders[index].isPaid!,
                                        storeID: state.orders[index].storeID!,
                                        price: state.orders[index].totalMRP!,
                                        orderedItems:
                                            state.orders[index].orderItems!);
                                  });
                            },
                            reject: () async {
                              await checkConnectivity(
                                  context: context,
                                  onConnected: () {
                                    _requestedOrdersCubit.rejectRequestedOrder(
                                        orderID: state.orders[index].orderID!,
                                        tokenID: state.orders[index].tokenID!);
                                  });
                            });
                      }),
                );
              })
            ],
          ),
        ));
  }
}
