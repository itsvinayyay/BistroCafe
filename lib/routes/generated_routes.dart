import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_cafe/Bottom_Nav_Bar.dart';
import 'package:food_cafe/routes/named_routes.dart';
import 'package:food_cafe/screens/Billing_Screen.dart';
import 'package:food_cafe/screens/Cart_Screen.dart';
import 'package:food_cafe/screens/ForgotPassword_Screen.dart';
import 'package:food_cafe/screens/Home_Screen.dart';
import 'package:food_cafe/screens/Notifications_Screen.dart';
import 'package:food_cafe/screens/OnBoard2_Screen.dart';
import 'package:food_cafe/screens/OnBoard_Screen.dart';
import 'package:food_cafe/screens/OrderPlaced_Screen.dart';
import 'package:food_cafe/screens/ProfilePage.dart';
import 'package:food_cafe/screens/ResetPassword_Screen.dart';
import 'package:food_cafe/screens/Search_Screen.dart';
import 'package:food_cafe/screens/SignIn_Screen.dart';
import 'package:food_cafe/screens/SignUpProcess_Screen.dart';
import 'package:food_cafe/screens/SignUpSuccess_Screen.dart';
import 'package:food_cafe/screens/SignUpVerification_Screen.dart';
import 'package:food_cafe/screens/SignUp_Screen.dart';
import 'package:food_cafe/screens/store_screens/store_AddMenuItems.dart';
import 'package:food_cafe/screens/store_screens/store_HomeScreen.dart';
import 'package:food_cafe/screens/store_screens/store_ItemaddedScreen.dart';
import 'package:food_cafe/screens/store_screens/store_MenuItems.dart';
import 'package:food_cafe/screens/store_screens/store_OrdersScreen.dart';
import 'package:food_cafe/screens/store_screens/store_SignInScreen.dart';

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
      case Routes.signUpProcess:
        return MaterialPageRoute(
            builder: (context) => SignUpProcess(), settings: routeSettings);
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
      case Routes.searchScreen:
        return MaterialPageRoute(
            builder: (context) => SearchScreen(), settings: routeSettings);
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
    builder: (context) => SignUpVerification(), settings: routeSettings);
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
            builder: (context) => store_AddItemsScreen(), settings: routeSettings);
      case Routes.store_menuItems:
        return MaterialPageRoute(
            builder: (context) => store_MenuItems(), settings: routeSettings);
      case Routes.store_OrdersScreen:
        return MaterialPageRoute(
            builder: (context) => store_OrdersScreen(), settings: routeSettings);
      case Routes.store_SignIn:
        return MaterialPageRoute(
            builder: (context) => store_SignIn(), settings: routeSettings);
      case Routes.store_ItemAdded:
        return MaterialPageRoute(
            builder: (context) => store_ItemAdded(), settings: routeSettings);
      case Routes.orderPlaced:
        return MaterialPageRoute(
            builder: (context) => OrderPlacedScreen(), settings: routeSettings);
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
