import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/cubits/cart_cubit/cartDisplay_cubit.dart';
import 'package:food_cafe/cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/screens/user_screens/home_screen/Cart_Screen.dart';
import 'package:food_cafe/screens/user_screens/home_screen/Home_Screen.dart';
import 'package:food_cafe/screens/user_screens/home_screen/ProfilePage.dart';
import 'package:food_cafe/theme.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const HomeScreen(),
    BlocProvider(create: (context) => CartDisplayCubit(), child: const CartScreen(),),
    const ProfilePage(),
  ];

  void _onitemtapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;
    final ThemeData theme = themeMode == MyTheme.dark ? darkTheme : lightTheme;
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: theme.colorScheme.primary,),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 10.h,
          ),
          child: GNav(
            backgroundColor: theme.colorScheme.primary,
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
              GButton(
                icon: Icons.person,
                text: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
