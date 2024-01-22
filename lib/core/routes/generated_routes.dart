import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/Bottom_Nav_Bar.dart';
import 'package:food_cafe/cubits/change_password_cubit/change_password_cubit.dart';
import 'package:food_cafe/cubits/change_user_details_cubit/change_user_details_cubit.dart';
import 'package:food_cafe/cubits/deactivate_account_cubit/deactivate_account_cubit.dart';
import 'package:food_cafe/cubits/forgotpassword_cubit/forgotpassword_cubit.dart';
import 'package:food_cafe/cubits/login_cubit/login_cubit.dart';
import 'package:food_cafe/cubits/order_history_cubit/order_history_cubit.dart';
import 'package:food_cafe/cubits/order_status_cubit/orderStatus_cubit.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:food_cafe/cubits/store_analytics_cubit/store_analytics_cubit.dart';
import 'package:food_cafe/cubits/user_name_cubit/user_name_cubit.dart';
import 'package:food_cafe/screens/change_password_screen.dart';
import 'package:food_cafe/screens/change_password_success_screen.dart';
import 'package:food_cafe/screens/change_user_details_screen.dart';
import 'package:food_cafe/screens/change_user_details_success_screen.dart';
import 'package:food_cafe/screens/deactivate_account_screen.dart';
import 'package:food_cafe/screens/store_screens/store_AddMenuItems.dart';
import 'package:food_cafe/screens/store_screens/store_HomeScreen.dart';
import 'package:food_cafe/screens/store_screens/store_ItemaddedScreen.dart';
import 'package:food_cafe/screens/store_screens/store_MenuItems.dart';
import 'package:food_cafe/screens/store_screens/store_OrdersScreen.dart';
import 'package:food_cafe/screens/store_screens/store_SignInScreen.dart';
import 'package:food_cafe/screens/store_screens/store_analytics_screen.dart';
import 'package:food_cafe/screens/store_screens/store_profile_screen.dart';
import 'package:food_cafe/screens/user_screens/Billing_Screen.dart';
import 'package:food_cafe/screens/user_screens/auth_screens/ForgotPassword_Screen.dart';
import 'package:food_cafe/screens/user_screens/notifications_screen.dart';
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
import 'package:food_cafe/screens/user_screens/auth_screens/forgotpasswordsuccess_screen.dart';
import 'package:food_cafe/screens/user_screens/home_screen/Cart_Screen.dart';
import 'package:food_cafe/screens/user_screens/home_screen/Home_Screen.dart';
import 'package:food_cafe/screens/user_screens/home_screen/ProfilePage.dart';
import 'package:food_cafe/screens/user_screens/order_history_screen.dart';
import 'package:food_cafe/screens/user_screens/settings_screen.dart';

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
            builder: (context) => MultiBlocProvider(providers: [
                  BlocProvider(create: (context) => PasswordVisibility()),
                  BlocProvider(
                      create: (context) => ConfirmPasswordVisibility()),
                ], child: SignUp()),
            settings: routeSettings);
      case Routes.signUpSuccess:
        return MaterialPageRoute(
            builder: (context) => SignUpSuccess(), settings: routeSettings);
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
      case Routes.analyticsScreen:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => AnalyticsCubit(),
                  child: AnalyticsScreen(),
                ),
            settings: routeSettings);
      case Routes.forgotPasswordScreen:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => ForgotPasswordCubit(),
                  child: ForgotPasswordScreen(),
                ),
            settings: routeSettings);
      case Routes.forgotPasswordSuccessScreen:
        return MaterialPageRoute(
            builder: (context) => ForgotPasswordSuccess(),
            settings: routeSettings);
      case Routes.settingsScreen:
        return MaterialPageRoute(
            builder: (context) => SettingsScreen(), settings: routeSettings);
      case Routes.changePasswordScreen:
        return MaterialPageRoute(
            builder: (context) => MultiBlocProvider(providers: [
                  BlocProvider(create: (context) => OldpasswordVisibility()),
                  BlocProvider(create: (context) => PasswordVisibility()),
                  BlocProvider(
                      create: (context) => ConfirmPasswordVisibility()),
                  BlocProvider(create: (context) => ChangePasswordCubit()),
                ], child: ChangePasswordScreen()),
            settings: routeSettings);
      case Routes.changePasswordSuccessScreen:
        return MaterialPageRoute(
            builder: (context) => ChangePasswordSuccessScreen(),
            settings: routeSettings);
      case Routes.deactivateAccountScreen:
        return MaterialPageRoute(
            builder: (context) => MultiBlocProvider(providers: [
                  BlocProvider(
                    create: (context) => PasswordVisibility(),
                  ),
                  BlocProvider(create: (context) => DeactivateAccountCubit())
                ], child: DeactivateAccountScreen()),
            settings: routeSettings);
      case Routes.store_profileScreen:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => UserNameCubit(),
                  child: ProfileScreen(),
                ),
            settings: routeSettings);
      case Routes.changeUserDetailsScreen:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => ChangeUserDetailsCubit(),
                  child: ChangeUserDetailsScreen(),
                ),
            settings: routeSettings);
      case Routes.changeUserDetailsSuccessScreen:
        return MaterialPageRoute(
            builder: (context) => ChangeUserDetailsSuccessScreen(),
            settings: routeSettings);
      case Routes.orderHistoryScreen:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => OrderHistoryCubit(),
                  child: OrderHistoryScreen(),
                ),
            settings: routeSettings);

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
