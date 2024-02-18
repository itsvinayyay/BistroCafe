import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/cubits/common_cubits/login_cubit/login_cubit.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_home_cubit/store_home_cubit.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_home_cubit/store_home_states.dart';
import 'package:food_cafe/data/services/notification_services.dart';
import 'package:food_cafe/data/services/notifications.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:food_cafe/screens/store_screens/home_screens/cafe_owner_role_side_drawer.dart';
import 'package:food_cafe/screens/store_screens/store_custom_cards/past_orders_screen_card.dart';
import 'package:food_cafe/utils/login_state_check.dart';
import 'package:food_cafe/utils/theme_check.dart';
import 'package:food_cafe/widgets/custom_circular_progress_indicator.dart';
import 'package:food_cafe/widgets/custom_empty_error.dart';
import 'package:food_cafe/widgets/custom_error.dart';
import 'package:food_cafe/widgets/custom_internet_error.dart';
import 'package:food_cafe/widgets/headings.dart';

class StoreHomeScreen extends StatefulWidget {
  const StoreHomeScreen({super.key});

  @override
  State<StoreHomeScreen> createState() => _StoreHomeScreenState();
}

class _StoreHomeScreenState extends State<StoreHomeScreen> {
  final NotificationServices _notificationServices = NotificationServices();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final CafeOwnerNotifications _cafeOwnerNotifications =
      CafeOwnerNotifications();
  late String storeID;
  late HomePastOrdersCubit _homePastOrdersCubit;
  late LoginCubit _loginCubit;

  void _initializeNotificationServices() {
    _notificationServices.requestNotificationPermission();
    _notificationServices.firebaseInit(context);
    _notificationServices.setupInteractMessage(context);
    // notificationServices.getDeviceToken().then((value) {
    //   log("This is the Device Token!!!");
    //   print(value);
    // });
  }

  void _initializeCubit() {
    _homePastOrdersCubit = BlocProvider.of<HomePastOrdersCubit>(context);
    _loginCubit = BlocProvider.of<LoginCubit>(context);

    _homePastOrdersCubit.getPastOrders(storeID: storeID);
  }

  @override
  void dispose() {
    super.dispose();
    _homePastOrdersCubit.close();
  }

  @override
  void initState() {
    super.initState();
    storeID = checkLoginStateForCafeOwner(
            context: context, screenName: 'Store HomeScreen')
        .value;
    _cafeOwnerNotifications.initialNotificationActions(storeID);
    _initializeNotificationServices();
    _initializeCubit();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = getTheme(context: context);
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: CafeOwnerRoleSideDrawer(
        storeID: storeID,
        onLogOut: () async {
          await _loginCubit.signOut();
          if (context.mounted) {
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.signIn, (route) => false);
          }
        },
      ),
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 60,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 82.h,
                      width: 233.w,
                      child: Text(
                        "Give your best food!",
                        style: theme.textTheme.headlineLarge,
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        _scaffoldKey.currentState!.openEndDrawer();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 13, vertical: 14),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.dashboard,
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.analyticsScreen);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(width: 3, color: Colors.white),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                padding: const EdgeInsets.all(2),
                                child: Icon(
                                  Icons.trending_up_rounded,
                                  color: theme.colorScheme.secondary,
                                  size: 32.sp,
                                )),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                              'Analytics',
                              style: theme.textTheme.labelLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.store_OrdersScreen);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              width: 3, color: theme.colorScheme.secondary),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: theme.colorScheme.secondary,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: const EdgeInsets.all(2),
                              child: Icon(
                                Icons.receipt_long,
                                color: Colors.white,
                                size: 32.sp,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Orders',
                              style: theme.textTheme.labelLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                subHeading(theme: theme, heading: "Past Orders"),
                const SizedBox(
                  height: 20,
                ),
                BlocBuilder<HomePastOrdersCubit, HomePastOrdersState>(
                    builder: (context, state) {
                  if (state is HomePastLoadingState) {
                    return const CustomCircularProgress();
                  } else if (state is HomePastErrorState &&
                      state.message == 'internetError') {
                    return CustomInternetError(tryAgain: () {
                      _homePastOrdersCubit.getPastOrders(storeID: storeID);
                    });
                  } else if (state is HomePastErrorState) {
                    return CustomError(
                        errorMessage: state.message,
                        tryAgain: () {
                          _homePastOrdersCubit.getPastOrders(storeID: storeID);
                        });
                  } else if (state is HomePastLoadedState &&
                      state.pastOrders.isEmpty) {
                    return const CustomEmptyError(
                        message: 'There are no past Orders as of now...');
                  }
                  return Column(
                    children: [
                      ...List.generate(
                          state.pastOrders.length,
                          (index) => pastOrdersCard(
                              theme: theme,
                              context: context,
                              pastOrders_Model: state.pastOrders[index],
                              onTap: () {}))
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector customIcons(
      {required ThemeData theme,
      required IconData iconData,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 14),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          iconData,
          color: theme.colorScheme.secondary,
        ),
      ),
    );
  }
}
