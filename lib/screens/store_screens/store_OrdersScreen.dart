import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/store_orders_cubit/currentOrders_cubit/currentOrders_cubit.dart';

import 'package:food_cafe/cubits/store_orders_cubit/pastOrders_cubit/pastOrders_cubit.dart';

import 'package:food_cafe/cubits/store_orders_cubit/requestedOrders_cubit/requestedOrders_cubit.dart';
import 'package:food_cafe/cubits/store_orders_cubit/unpaid_orders_cubit.dart/unpaid_orders_cubit.dart';

import 'package:food_cafe/cubits/theme_cubit/theme_cubit.dart';

import 'package:food_cafe/screens/store_screens/orders_screen/store_currentOrders_screen.dart';
import 'package:food_cafe/screens/store_screens/orders_screen/store_pastOrders_screen.dart';
import 'package:food_cafe/screens/store_screens/orders_screen/store_requestedOrders_screen.dart';
import 'package:food_cafe/screens/store_screens/orders_screen/store_unpaid_orders_screen.dart';

import 'package:food_cafe/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class store_OrdersScreen extends StatefulWidget {
  store_OrdersScreen({Key? key}) : super(key: key);

  @override
  State<store_OrdersScreen> createState() => _store_OrdersScreenState();
}

class _store_OrdersScreenState extends State<store_OrdersScreen> {
  // late RequestedOrdersCubit requestedOrdersCubit = RequestedOrdersCubit();
  // late CurrentOrdersCubit currentOrdersCubit = CurrentOrdersCubit();
  // late PastOrdersCubit pastOrdersCubit = PastOrdersCubit();
  int currentBNIndex = 0;

  List<Widget> OrderScreens = [
    BlocProvider(
        create: (context) => RequestedOrdersCubit(),
        child: RequestedOrdersScreen()),
    BlocProvider(
        create: (context) => UnpaidOrdersCubit(), child: UnpaidOrdersScreen()),
    BlocProvider(
      create: (context) => CurrentOrdersCubit(),
      child: CurrentOrdersScreen(),
    ),
    BlocProvider(
      create: (context) => PastOrdersCubit(),
      child: PastOrdersScreen(),
    ),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //TODO Initialize the stream again for Requested Orders!
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;
    final ThemeData theme = themeMode == MyTheme.dark ? darkTheme : lightTheme;
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          child: Row(
            children: [
              ...List.generate(
                Tabs.length,
                (index) => tabContainers(
                    theme: theme,
                    name: Tabs[index],
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
      backgroundColor: theme.colorScheme.background,
      body: OrderScreens[currentBNIndex],
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
        margin: EdgeInsets.only(right: 10),
        alignment: Alignment.center,
        height: 50,
        width: 150,
        duration: Duration(milliseconds: 300),
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

  List<String> Tabs = ["Requested", "Unpaid", "Current", "Past"];
}

Row foodRow(
    {required ThemeData theme, required Map<String, dynamic> foodItem}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.food_bank_rounded,
            color: Colors.green,
          ),
          SizedBox(
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
