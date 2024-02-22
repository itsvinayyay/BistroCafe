import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_orders_cubit/currentOrders_cubit/current_orders_cubit.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_orders_cubit/pastOrders_cubit/past_orders_cubit.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_orders_cubit/requestedOrders_cubit/requested_orders_cubit.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_orders_cubit/unpaid_orders_cubit.dart/unpaid_orders_cubit.dart';
import 'package:food_cafe/data/services/notification_services.dart';
import 'package:food_cafe/screens/store_screens/side_drawer_screens/orders_screens/store_current_orders_screen.dart';
import 'package:food_cafe/screens/store_screens/side_drawer_screens/orders_screens/store_past_orders_screen.dart';
import 'package:food_cafe/screens/store_screens/side_drawer_screens/orders_screens/store_requested_orders_screen.dart';
import 'package:food_cafe/screens/store_screens/side_drawer_screens/orders_screens/store_unpaid_orders_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/utils/login_state_check.dart';
import 'package:food_cafe/utils/theme_check.dart';

class StoreOrdersScreen extends StatefulWidget {
  const StoreOrdersScreen({super.key});

  @override
  State<StoreOrdersScreen> createState() => _StoreOrdersScreenState();
}

class _StoreOrdersScreenState extends State<StoreOrdersScreen> {
  final NotificationServices _notificationServices = NotificationServices();
  late String storeID;
  int currentBNIndex = 0;

  List<Widget> orderScreens = [
    BlocProvider(
        create: (context) => RequestedOrdersCubit(),
        child: const RequestedOrdersScreen()),
    BlocProvider(
        create: (context) => UnpaidOrdersCubit(),
        child: const UnpaidOrdersScreen()),
    BlocProvider(
      create: (context) => CurrentOrdersCubit(),
      child: const CurrentOrdersScreen(),
    ),
    BlocProvider(
      create: (context) => PastOrdersCubit(),
      child: const PastOrdersScreen(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    storeID = checkLoginStateForCafeOwner(
            context: context, screenName: 'Orders Screen')
        .value;
    _notificationServices.isTokenRefresh(storeID: storeID);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = getTheme(context: context);
    return Scaffold(
      bottomNavigationBar: Container(
        color: theme.colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                ...List.generate(
                  tabs.length,
                  (index) => tabContainers(
                      theme: theme,
                      name: tabs[index],
                      onTap: () {
                        setState(() {
                          currentBNIndex = index;
                        });
                      },
                      isCurrentTab: currentBNIndex == index),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: theme.colorScheme.background,
      body: orderScreens[currentBNIndex],
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
        margin: const EdgeInsets.only(right: 10),
        alignment: Alignment.center,
        height: 50,
        width: 150,
        duration: const Duration(milliseconds: 300),
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

  List<String> tabs = ["Requested", "Unpaid", "Current", "Past"];
}

Row foodRow(
    {required ThemeData theme, required Map<String, dynamic> foodItem}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.food_bank_rounded,
            color: Colors.green,
          ),
          const SizedBox(
            width: 5,
          ),
          SizedBox(
            width: 90.w,
            child: Text(
              foodItem['Name'],
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
