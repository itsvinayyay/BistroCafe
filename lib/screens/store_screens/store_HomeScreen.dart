import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/cubits/login_cubit/login_cubit.dart';
import 'package:food_cafe/cubits/login_cubit/login_state.dart';
import 'package:food_cafe/cubits/store_home_cubit/store_home_cubit.dart';
import 'package:food_cafe/cubits/store_home_cubit/store_home_states.dart';
import 'package:food_cafe/cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/data/services/notification_services.dart';
import 'package:food_cafe/data/services/notifications.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:food_cafe/screens/store_screens/orders_screen/store_pastOrders_screen.dart';
import 'package:food_cafe/screens/user_screens/home_screen/Home_Screen.dart';
import 'package:food_cafe/theme.dart';
import 'package:food_cafe/widgets/custom_FoodCard.dart';
import 'package:food_cafe/widgets/headings.dart';

class store_HomeScreen extends StatefulWidget {
  const store_HomeScreen({Key? key}) : super(key: key);

  @override
  State<store_HomeScreen> createState() => _store_HomeScreenState();
}

class _store_HomeScreenState extends State<store_HomeScreen> {
  NotificationServices notificationServices = NotificationServices();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  cafeOwner_Notifications cafeowner_Notifications = cafeOwner_Notifications();
  late String storeID;
  late final state;
  late HomePastOrders homePastOrders;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    // ID = context.read<LoginCubit>().getEntryNo();
    // storeID = await context.read<LoginCubit>().getStoreID(ID);
    storeID = context.read<LoginCubit>().state is CafeLoginLoadedState
        ? (context.read<LoginCubit>().state as CafeLoginLoadedState).storeID
        : "Error";
    cafeowner_Notifications.initialNotifications_Action(storeID);
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.getDeviceToken().then((value) {
      log("This is the Device Token!!!");
      print(value);
    });
    homePastOrders = BlocProvider.of(context);
    homePastOrders.getPastOrders(storeID: storeID);
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;
    final ThemeData theme = themeMode == MyTheme.dark ? darkTheme : lightTheme;
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40), bottomLeft: Radius.circular(40)),
        child: Drawer(
          backgroundColor: theme.colorScheme.primary,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.black,
                        child: Icon(
                          Icons.person,
                          size: 40.sp,
                          color: theme.colorScheme.secondary,
                        ),
                        radius: 30.sp,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Delightful Dining, Every Bite a Delight!',
                        style: theme.textTheme.titleSmall,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      // FutureBuilder<String>(
                      //   future: context.read<LoginCubit>().getStoreID(ID),
                      //   builder: (context, snapshot) {
                      //     if (snapshot.connectionState ==
                      //         ConnectionState.waiting) {
                      //       // Display a loading indicator while fetching storeID
                      //       return Text(
                      //         'Loading...',
                      //         style: theme.textTheme.bodySmall,
                      //       );
                      //     } else if (snapshot.hasError) {
                      //       // Handle error if any
                      //       return Text(
                      //         "Error: ${snapshot.error}",
                      //         style: theme.textTheme.bodySmall,
                      //       );
                      //     } else {
                      //       // Display your content once storeID is fetched
                      //       return Text(storeID,
                      //           style: TextStyle(
                      //               fontWeight: FontWeight.w700,
                      //               fontSize: 20.sp,
                      //               color: theme.colorScheme.primary,
                      //               fontFamily: 'BentonSans_Bold'));
                      //     }
                      //   },
                      // ),
                      Text(
                        storeID,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20.sp,
                            color: theme.colorScheme.primary,
                            fontFamily: 'BentonSans_Bold'),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    _buildSDTiles(
                        theme: theme,
                        title: 'Notifications',
                        icon: Icons.notifications,
                        onTap: () {}),
                    _buildSDTiles(
                        theme: theme,
                        title: 'Settings',
                        icon: Icons.settings,
                        onTap: () {}),
                    _buildSDTiles(
                        theme: theme,
                        title: 'Menu Items',
                        icon: Icons.menu_book,
                        onTap: () {
                          Navigator.pushNamed(context, Routes.store_menuItems);
                        }),
                    _buildSDTiles(
                        theme: theme,
                        title: 'Your Orders',
                        icon: Icons.receipt_long,
                        onTap: () {
                          Navigator.pushNamed(
                              context, Routes.store_OrdersScreen);
                        }),
                    _buildSDTiles(
                        theme: theme,
                        title: 'Add Menu Items',
                        icon: Icons.add_card_rounded,
                        onTap: () {
                          Navigator.pushNamed(
                              context, Routes.store_addItemsScreen);
                        }),
                    _buildSDTiles(
                        theme: theme,
                        title: 'About',
                        icon: Icons.info_outline_rounded,
                        onTap: () {}),
                    _buildSDTiles(
                        theme: theme,
                        title: 'Log Out',
                        icon: Icons.logout,
                        onTap: () {
                          context.read<LoginCubit>().signOut();
                          Navigator.pushNamedAndRemoveUntil(
                              context, Routes.signIn, (route) => false);
                        })
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
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
                    GestureDetector(
                      onTap: () {
                        _scaffoldKey.currentState!.openEndDrawer();
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 13, vertical: 14),
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
                SizedBox(
                  height: 20,
                ),
                subHeading(theme: theme, heading: "Popular Picks available"),
                SizedBox(
                  height: 10,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  child: Row(
                    children: List.generate(
                      popularPicks.length,
                      (index) => Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: foodCard(
                          theme: theme,
                          image_url: popularPicks[index]["image_url"],
                          foodName: popularPicks[index]["foodName"],
                          mrp: popularPicks[index]["mrp"],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                subHeading(theme: theme, heading: "Past Orders"),
                SizedBox(
                  height: 20,
                ),
                BlocBuilder<HomePastOrders, HomePastOrdersState>(
                    builder: (context, state) {
                  if (state is HomePastLoadingState) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                  } else if (state is HomePastErrorState) {
                    return Text(state.message);
                  }

                  return Column(
                    children: [
                      ...List.generate(
                          state.pastOrders.length,
                          (index) => pastOrder_Card(
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

  ListTile _buildSDTiles(
      {required ThemeData theme,
      required String title,
      required IconData icon,
      required VoidCallback onTap}) {
    return ListTile(
        horizontalTitleGap: 10,
        leading: Icon(
          icon,
          color: theme.colorScheme.secondary,
        ),
        title: Text(
          title,
          style: theme.textTheme.bodyLarge,
        ),
        onTap: onTap);
  }

  GestureDetector custom_Icons(
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
