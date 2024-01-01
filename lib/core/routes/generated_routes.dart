import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/Bottom_Nav_Bar.dart';
import 'package:food_cafe/cubits/order_status_cubit/orderStatus_cubit.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:food_cafe/screens/store_screens/store_AddMenuItems.dart';
import 'package:food_cafe/screens/store_screens/store_HomeScreen.dart';
import 'package:food_cafe/screens/store_screens/store_ItemaddedScreen.dart';
import 'package:food_cafe/screens/store_screens/store_MenuItems.dart';
import 'package:food_cafe/screens/store_screens/store_OrdersScreen.dart';
import 'package:food_cafe/screens/store_screens/store_SignInScreen.dart';
import 'package:food_cafe/screens/user_screens/Billing_Screen.dart';
import 'package:food_cafe/screens/user_screens/ForgotPassword_Screen.dart';
import 'package:food_cafe/screens/user_screens/Notifications_Screen.dart';
import 'package:food_cafe/screens/user_screens/OnBoard2_Screen.dart';
import 'package:food_cafe/screens/user_screens/OnBoard_Screen.dart';
import 'package:food_cafe/screens/user_screens/OrderPlaced_Screen.dart';
import 'package:food_cafe/screens/user_screens/Order_Request_Screen.dart';
import 'package:food_cafe/screens/user_screens/Payment_Screen.dart';
import 'package:food_cafe/screens/user_screens/ResetPassword_Screen.dart';
import 'package:food_cafe/screens/user_screens/auth_screens/SignIn_Screen.dart';

import 'package:food_cafe/screens/user_screens/auth_screens/SignUpSuccess_Screen.dart';
import 'package:food_cafe/screens/user_screens/auth_screens/SignUpVerification_Screen.dart';
import 'package:food_cafe/screens/user_screens/auth_screens/SignUp_Screen.dart';
import 'package:food_cafe/screens/user_screens/home_screen/Cart_Screen.dart';
import 'package:food_cafe/screens/user_screens/home_screen/Home_Screen.dart';
import 'package:food_cafe/screens/user_screens/home_screen/ProfilePage.dart';

class GeneratedRoutes {
  static Route generateRoutes(RouteSettings routeSettings) {
    final args = routeSettings.arguments;
    debugPrint("Navigating to route!!!=======>> ${routeSettings.name}");

    switch (routeSettings.name) {
      case Routes.onboard1:
        return MaterialPageRoute(
            builder: (context) => OnBoard(), settings: routeSettings);
      case Routes.onboard2:
        return MaterialPageRoute(
            builder: (context) => OnBoard2(), settings: routeSettings);
      case Routes.signIn:
        return MaterialPageRoute(
            builder: (context) => SignIn(), settings: routeSettings);
      case Routes.signUp:
        return MaterialPageRoute(
            builder: (context) => SignUp(), settings: routeSettings);
      case Routes.signUpSuccess:
        return MaterialPageRoute(
            builder: (context) => SignUpSuccess(), settings: routeSettings);
      case Routes.forgotPassword:
        return MaterialPageRoute(
            builder: (context) => ForgotPassword(), settings: routeSettings);
      case Routes.resetPassword:
        return MaterialPageRoute(
            builder: (context) => ResetPassword(), settings: routeSettings);
      case Routes.homeScreen:
        return MaterialPageRoute(
            builder: (context) => HomeScreen(), settings: routeSettings);
      
      case Routes.notificationsScreen:
        return MaterialPageRoute(
            builder: (context) => Notifications(), settings: routeSettings);
      case Routes.cartScreen:
        return MaterialPageRoute(
            builder: (context) => CartScreen(), settings: routeSettings);
      case Routes.profilePage:
        return MaterialPageRoute(
            builder: (context) => ProfilePage(), settings: routeSettings);
      case Routes.bottomNav:
        return MaterialPageRoute(
            builder: (context) => BottomNavBar(), settings: routeSettings);
      case Routes.signupVerification:
        return MaterialPageRoute(
            builder: (context) => SignUpVerification(),
            settings: routeSettings);
      case Routes.store_HomeScreen:
        return MaterialPageRoute(
            builder: (context) => store_HomeScreen(), settings: routeSettings);
      case Routes.billingScreen:
        return MaterialPageRoute(
            builder: (context) => BillingScreen(), settings: routeSettings);
      case Routes.store_HomeScreen:
        return MaterialPageRoute(
            builder: (context) => store_HomeScreen(), settings: routeSettings);
      case Routes.store_addItemsScreen:
        return MaterialPageRoute(
            builder: (context) => store_AddItemsScreen(),
            settings: routeSettings);
      case Routes.store_menuItems:
        return MaterialPageRoute(
            builder: (context) => store_MenuItems(), settings: routeSettings);
      case Routes.store_OrdersScreen:
        return MaterialPageRoute(
            builder: (context) => store_OrdersScreen(),
            settings: routeSettings);
      case Routes.store_SignIn:
        return MaterialPageRoute(
            builder: (context) => store_SignIn(), settings: routeSettings);
      case Routes.store_ItemAdded:
        return MaterialPageRoute(
            builder: (context) => store_ItemAdded(), settings: routeSettings);
      case Routes.orderPlaced:
        return MaterialPageRoute(
            builder: (context) => OrderPlacedScreen(), settings: routeSettings);
      case Routes.orderRequestScreen:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => OrderStatusCubit(),
                  child: OrderRequestedScreen(),
                ),
            settings: routeSettings);
            case Routes.paymentScreen:
        return MaterialPageRoute(
            builder: (context) => PaymentScreen(), settings: routeSettings);
      default:
        return error_Screen();
    }
  }

  static MaterialPageRoute<dynamic> error_Screen() {
    return MaterialPageRoute(
      builder: (context) => const Scaffold(
        body: SafeArea(
          child: Text("Error here!"),
        ),
      ),
    );
  }
}
