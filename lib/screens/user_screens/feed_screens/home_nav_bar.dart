import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/user_role_cubits/cart_cubits/cart_display_cubit/cart_display_cubit.dart';
import 'package:food_cafe/cubits/user_role_cubits/cart_cubits/cart_local_state_cubit/cart_local_state_cubit.dart';
import 'package:food_cafe/cubits/user_role_cubits/check_store_timings_cubit/check_timings_cubit.dart';
import 'package:food_cafe/cubits/user_role_cubits/home_menu_item_cubit/home_menu_item_cubit.dart';
import 'package:food_cafe/cubits/common_cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/screens/user_screens/feed_screens/cart_screen.dart';
import 'package:food_cafe/screens/user_screens/feed_screens/home_screen.dart';
import 'package:food_cafe/core/theme/theme.dart';
import 'package:food_cafe/utils/login_state_check.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late HomeMenuItemsCubit _homeMenuItemsCubit;
  late String personID;
  late CartDisplayCubit _cartDisplayCubit;
  late CartLocalStateInitializedCubit _cartLocalStateInitializedCubit;
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const HomeScreen(),
    BlocProvider(
      create: (context) => CheckTimingsCubit(),
      child: const CartScreen(),
    ),
  ];

  void _onitemtapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _initializeCart() async {
    log('inside');
    if (!_cartLocalStateInitializedCubit.state) {
      await context
          .read<CartLocalState>()
          .initializefromFirebase(personID: personID);
      _cartLocalStateInitializedCubit.localStateInitialized();
    }
  }

  void _initializeCubits() {
    _homeMenuItemsCubit = BlocProvider.of<HomeMenuItemsCubit>(context);
    _homeMenuItemsCubit.initiateFetch(storeID: 'SMVDU101');

    personID =
        checkLoginStateForUser(context: context, screenName: 'Bottom Nav Bar');

    _cartDisplayCubit = BlocProvider.of<CartDisplayCubit>(context);
    _cartDisplayCubit.initialize(personID);

    _cartLocalStateInitializedCubit =
        BlocProvider.of<CartLocalStateInitializedCubit>(context);
  }

  @override
  void initState() {
    super.initState();
    _initializeCubits();
    _initializeCart();
  }

  @override
  void dispose() {
    super.dispose();
    _cartDisplayCubit.close();
    _homeMenuItemsCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;
    final ThemeData theme = themeMode == MyTheme.dark ? darkTheme : lightTheme;
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
        ),
        // margin: EdgeInsets.symmetric(horizontal: 80, vertical: 5),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: GNav(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          color: theme.colorScheme.secondary,
          activeColor: theme.colorScheme.secondary,
          gap: 10,
          tabBackgroundColor: theme.colorScheme.secondary.withOpacity(0.3),
          padding: const EdgeInsets.all(12),
          selectedIndex: _selectedIndex,
          onTabChange: _onitemtapped,
          tabs: const [
            GButton(
              icon: Icons.home,
              text: "Home",
            ),
            GButton(
              icon: Icons.shopping_cart,
              text: "Cart",
            ),
          ],
        ),
      ),
    );
  }
}
