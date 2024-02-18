import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_orders_cubit/pastOrders_cubit/past_orders_cubit.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_orders_cubit/pastOrders_cubit/pastOrders_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/screens/store_screens/store_custom_cards/past_orders_screen_card.dart';
import 'package:food_cafe/utils/login_state_check.dart';
import 'package:food_cafe/utils/theme_check.dart';
import 'package:food_cafe/widgets/custom_circular_progress_indicator.dart';
import 'package:food_cafe/widgets/custom_empty_error.dart';
import 'package:food_cafe/widgets/custom_error.dart';
import 'package:food_cafe/widgets/custom_internet_error.dart';


class PastOrdersScreen extends StatefulWidget {
  const PastOrdersScreen({super.key});

  @override
  State<PastOrdersScreen> createState() => _PastOrdersScreenState();
}

class _PastOrdersScreenState extends State<PastOrdersScreen> {
  late PastOrdersCubit pastOrdersCubit = PastOrdersCubit();
  late String storeID;

  void _initializeCubits() {
    storeID = checkLoginStateForCafeOwner(
            context: context, screenName: 'Past Orders Screen')
        .value;
    pastOrdersCubit = BlocProvider.of<PastOrdersCubit>(context);
    pastOrdersCubit.initialize(storeID);
  }

  @override
  void initState() {
    super.initState();
    _initializeCubits();
  }

  @override
  void dispose() {
    super.dispose();
    pastOrdersCubit.close();
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
                "Past Orders",
                style: theme.textTheme.headlineLarge,
              ),
              const SizedBox(
                height: 10,
              ),
              BlocBuilder<PastOrdersCubit, PastOrdersState>(
                  builder: (context, state) {
                if (state is PastLoadingState) {
                  return const CustomCircularProgress();
                } else if (state is PastErrorState &&
                    state.message == 'internetError') {
                  return CustomInternetError(tryAgain: () {
                    pastOrdersCubit.initialize(storeID);
                  });
                } else if (state is PastErrorState) {
                  return CustomError(
                      errorMessage: state.message,
                      tryAgain: () {
                        pastOrdersCubit.initialize(storeID);
                      });
                } else if (state is PastLoadedState &&
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
                        return pastOrdersCard(
                            theme: theme,
                            context: context,
                            pastOrders_Model: state.orders[index],
                            onTap: () {});
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
