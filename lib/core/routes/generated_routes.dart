import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_add_new_menu_item_cubits/store_add_item_image_cubit/add_item_image_cubit.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_menuitem_cubit/menu_item_cubit.dart';
import 'package:food_cafe/cubits/common_cubits/login_cubit/login_cubit.dart';
import 'package:food_cafe/cubits/common_cubits/password_visibility_cubits/password_visibility_cubits.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_home_cubit/store_home_cubit.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_add_new_menu_item_cubits/store_add_menu_item_cubit/add_menu_item_cubit.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_modify_menuitem_cubit.dart/modify_menuitem_cubit.dart';
import 'package:food_cafe/cubits/user_role_cubits/home_menu_item_cubit/home_menu_item_cubit.dart';
import 'package:food_cafe/cubits/user_role_cubits/cart_cubits/cart_display_cubit/cart_display_cubit.dart';
import 'package:food_cafe/cubits/user_role_cubits/payment_cubit/payment_cubit.dart';
import 'package:food_cafe/data/models/store_menu_item_model.dart';
import 'package:food_cafe/screens/common_screens/change_password_screen.dart';
import 'package:food_cafe/screens/common_screens/change_password_success_screen.dart';
import 'package:food_cafe/screens/common_screens/change_user_details_screen.dart';
import 'package:food_cafe/screens/common_screens/change_user_details_success_screen.dart';
import 'package:food_cafe/screens/user_screens/check_out_screens/make_payment_screen.dart';
import 'package:food_cafe/screens/user_screens/side_drawer_screens/deactivate_account_screen.dart';
import 'package:food_cafe/screens/store_screens/side_drawer_screens/menu_items_screen/store_modify_menuitem_screen.dart';
import 'package:food_cafe/screens/user_screens/feed_screens/home_nav_bar.dart';
import 'package:food_cafe/cubits/user_role_cubits/billing_cubit/billing_other_cubits.dart';
import 'package:food_cafe/cubits/user_role_cubits/billing_cubit/priceCalculation_cubit/price_calculation_cubit.dart';
import 'package:food_cafe/cubits/common_cubits/change_password_cubit/change_password_cubit.dart';
import 'package:food_cafe/cubits/common_cubits/change_user_details_cubit/change_user_details_cubit.dart';
import 'package:food_cafe/cubits/user_role_cubits/deactivate_account_cubit/deactivate_account_cubit.dart';
import 'package:food_cafe/cubits/user_role_cubits/food_category_cubit/food_category_cubit.dart';
import 'package:food_cafe/cubits/common_cubits/forgotpassword_cubit/forgotpassword_cubit.dart';
import 'package:food_cafe/cubits/user_role_cubits/order_history_cubit/order_history_cubit.dart';
import 'package:food_cafe/cubits/user_role_cubits/requested_order_status_cubit/requested_order_status_cubit.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_analytics_cubit/store_analytics_cubit.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_management_cubit/store_management_cubit.dart';
import 'package:food_cafe/cubits/common_cubits/user_name_cubit/user_name_cubit.dart';
import 'package:food_cafe/screens/store_screens/side_drawer_screens/add_menu_item_screens/store_add_menu_item_screen.dart';
import 'package:food_cafe/screens/store_screens/home_screens/store_home_screen.dart';
import 'package:food_cafe/screens/store_screens/side_drawer_screens/add_menu_item_screens/store_menu_item_added_screen.dart';
import 'package:food_cafe/screens/store_screens/side_drawer_screens/menu_items_screen/store_menu_items_screen.dart';
import 'package:food_cafe/screens/store_screens/side_drawer_screens/orders_screens/store_orders_screen.dart';
import 'package:food_cafe/screens/store_screens/auth_screens/store_sign_in_screen.dart';
import 'package:food_cafe/screens/store_screens/home_screens/store_analytics_screen.dart';
import 'package:food_cafe/screens/store_screens/side_drawer_screens/settings_screens/store_management_details_updated_screen.dart';
import 'package:food_cafe/screens/store_screens/side_drawer_screens/settings_screens/store_management_screen.dart';
import 'package:food_cafe/screens/store_screens/side_drawer_screens/store_profile_screen.dart';
import 'package:food_cafe/screens/user_screens/check_out_screens/billings_screen.dart';
import 'package:food_cafe/screens/user_screens/auth_screens/forgot_password_screen.dart';
import 'package:food_cafe/screens/user_screens/feed_screens/category_screen.dart';
import 'package:food_cafe/screens/user_screens/on_board_screens/on_board_screen_1.dart';
import 'package:food_cafe/screens/user_screens/on_board_screens/on_board_screen_2.dart';

import 'package:food_cafe/screens/user_screens/check_out_screens/order_placed_screen.dart';
import 'package:food_cafe/screens/user_screens/check_out_screens/order_request_screen.dart';
import 'package:food_cafe/screens/user_screens/check_out_screens/Payment_Screen.dart';

import 'package:food_cafe/screens/user_screens/auth_screens/sign_in_screen.dart';
import 'package:food_cafe/screens/user_screens/auth_screens/sign_up_success_screen.dart';
import 'package:food_cafe/screens/user_screens/auth_screens/sign_up_verification_screen.dart';
import 'package:food_cafe/screens/user_screens/auth_screens/sign_up_screen.dart.dart';
import 'package:food_cafe/screens/user_screens/auth_screens/forgot_password_success_screen.dart';
import 'package:food_cafe/screens/user_screens/feed_screens/cart_screen.dart';
import 'package:food_cafe/screens/user_screens/feed_screens/home_screen.dart';
import 'package:food_cafe/screens/user_screens/side_drawer_screens/order_history_screen.dart';
import 'package:food_cafe/screens/store_screens/side_drawer_screens/settings_screens/store_settings_screen.dart';
import 'package:food_cafe/screens/user_screens/side_drawer_screens/profile_screen.dart';
import 'package:food_cafe/screens/user_screens/side_drawer_screens/settings_screen.dart';

class GeneratedRoutes {
  static Route generateRoutes(RouteSettings routeSettings) {
    log("Navigating to route!!!=======>> ${routeSettings.name}");

    switch (routeSettings.name) {
      //SPLASH SCREEN

      //ONBOARDING SCREEN
      case Routes.onboard1:
        return MaterialPageRoute(
            builder: (context) => const OnBoard(), settings: routeSettings);

      case Routes.onboard2:
        return MaterialPageRoute(
            builder: (context) => const OnBoard2(), settings: routeSettings);

      //AUTH SCREENS (USER)

      case Routes.signIn:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => PasswordVisibility(),
                  child: const SignInScreen(),
                ),
            settings: routeSettings);

      case Routes.signUp:
        return MaterialPageRoute(
            builder: (context) => MultiBlocProvider(providers: [
                  BlocProvider(create: (context) => PasswordVisibility()),
                  BlocProvider(
                      create: (context) => ConfirmPasswordVisibility()),
                ], child: const SignUp()),
            settings: routeSettings);

      case Routes.signUpSuccess:
        return MaterialPageRoute(
            builder: (context) => const SignUpSuccess(),
            settings: routeSettings);

      case Routes.forgotPasswordScreen:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => ForgotPasswordCubit(),
                  child: const ForgotPasswordScreen(),
                ),
            settings: routeSettings);

      case Routes.forgotPasswordSuccessScreen:
        return MaterialPageRoute(
            builder: (context) => const ForgotPasswordSuccess(),
            settings: routeSettings);

      case Routes.signupVerification:
        return MaterialPageRoute(
            builder: (context) => MultiBlocProvider(providers: [
                  BlocProvider(
                    create: (context) => TimerCubit(),
                  ),
                  BlocProvider(
                    create: (context) => ResendVerificationCubit(),
                  ),
                ], child: const SignUpVerification()),
            settings: routeSettings);

//USER SCREENS

      //FEED SCREEN

      case Routes.bottomNav:
        return MaterialPageRoute(
            builder: (context) => MultiBlocProvider(providers: [
                  BlocProvider(
                    create: (context) => CartDisplayCubit(),
                  ),
                  BlocProvider(
                    create: (context) => HomeMenuItemsCubit(),
                  ),
                ], child: const BottomNavBar()),
            settings: routeSettings);

      case Routes.homeScreen:
        return MaterialPageRoute(
            builder: (context) => const HomeScreen(), settings: routeSettings);

      case Routes.cartScreen:
        return MaterialPageRoute(
            builder: (context) => const CartScreen(), settings: routeSettings);

      case Routes.categoryScreen:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => FoodCategoryCubit(),
                  child: CategoryScreen(
                    categoryName: routeSettings.arguments as String,
                  ),
                ),
            settings: routeSettings);

      

      //CHECKOUT SCREENS

      case Routes.billingScreen:
        return MaterialPageRoute(
            builder: (context) => MultiBlocProvider(providers: [
                  // BlocProvider(create: (context) => BillingCheckOutCubit()),
                  BlocProvider(create: (context) => BillingHostelCubit()),
                  BlocProvider(
                      create: (context) => BillingPriceCalculationCubit()),
                  BlocProvider(create: (context) => BillingPaymentCubit()),
                  BlocProvider(
                      create: (context) => BillingDineSelectionCubit()),
                ], child: const BillingScreen()),
            settings: routeSettings);

      case Routes.orderPlaced:
        return MaterialPageRoute(
            builder: (context) => OrderPlacedScreen(
                  isOrderAccepted: routeSettings.arguments as bool,
                ),
            settings: routeSettings);

      case Routes.orderRequestScreen:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => RequestedOrderStatusCubit(),
                  child: OrderRequestedScreen(
                    isPaymentCash: routeSettings.arguments as bool,
                  ),
                ),
            settings: routeSettings);

      case Routes.paymentScreen:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => PaymentCubit(),
                  child: const PaymentScreen(),
                ),
            settings: routeSettings);

      case Routes.makePaymentScreen:
        return MaterialPageRoute(
            builder: (context) => const MakePaymentScreen(),
            settings: routeSettings);

      //SIDE DRAWER SCREENS

      case Routes.orderHistoryScreen:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => OrderHistoryCubit(),
                  child: const OrderHistoryScreen(),
                ),
            settings: routeSettings);

      case Routes.settingsScreen:
        return MaterialPageRoute(
            builder: (context) => const SettingsScreen(),
            settings: routeSettings);

      case Routes.profileScreen:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => UserNameCubit(),
                  child: const ProfileScreen(),
                ),
            settings: routeSettings);

      //COMMONS

      case Routes.changePasswordScreen:
        return MaterialPageRoute(
            builder: (context) => MultiBlocProvider(providers: [
                  BlocProvider(create: (context) => OldpasswordVisibility()),
                  BlocProvider(create: (context) => PasswordVisibility()),
                  BlocProvider(
                      create: (context) => ConfirmPasswordVisibility()),
                  BlocProvider(create: (context) => ChangePasswordCubit()),
                ], child: const ChangePasswordScreen()),
            settings: routeSettings);

      case Routes.changePasswordSuccessScreen:
        return MaterialPageRoute(
            builder: (context) => const ChangePasswordSuccessScreen(),
            settings: routeSettings);

      case Routes.deactivateAccountScreen:
        return MaterialPageRoute(
            builder: (context) => MultiBlocProvider(providers: [
                  BlocProvider(
                    create: (context) => PasswordVisibility(),
                  ),
                  BlocProvider(create: (context) => DeactivateAccountCubit())
                ], child: const DeactivateAccountScreen()),
            settings: routeSettings);

      case Routes.changeUserDetailsScreen:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => ChangeUserDetailsCubit(),
                  child: ChangeUserDetailsScreen(
                    isCafeOwner: routeSettings.arguments as bool,
                  ),
                ),
            settings: routeSettings);

      case Routes.changeUserDetailsSuccessScreen:
        return MaterialPageRoute(
            builder: (context) => const ChangeUserDetailsSuccessScreen(),
            settings: routeSettings);

      // jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj

      //CAFE OWNER SCREENS
      //AUTH SCREENS
      case Routes.store_SignIn:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => PasswordVisibility(),
                  child: const StoreSignInScreen(),
                ),
            settings: routeSettings);

      //FEED SCREENS
      case Routes.store_HomeScreen:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => HomePastOrdersCubit(),
                  child: const StoreHomeScreen(),
                ),
            settings: routeSettings);

      case Routes.analyticsScreen:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => AnalyticsCubit(),
                  child: const AnalyticsScreen(),
                ),
            settings: routeSettings);

      //SIDE DRAWER SCREENS

      case Routes.store_addItemsScreen:
        return MaterialPageRoute(
            builder: (context) => MultiBlocProvider(providers: [
                  BlocProvider(
                    create: (context) => AddImageCubit(),
                  ),
                  BlocProvider(
                    create: (context) => CategoryCubit(category: 'Appetizer'),
                  ),
                  BlocProvider(
                    create: (context) => AvailableCubit(availability: false),
                  ),
                  BlocProvider(
                    create: (context) => AddItemCubit(),
                  ),
                ], child: const StoreAddMenuItemScreen()),
            settings: routeSettings);

      case Routes.store_ItemAdded:
        return MaterialPageRoute(
            builder: (context) => const StoreMenuItemAddedScreen(),
            settings: routeSettings);

      case Routes.store_menuItems:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => MenuItemCubit(),
                  child: const StoreMenuItemsScreen(),
                ),
            settings: routeSettings);

      case Routes.store_ModifyMenuItemScreen:
        return MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => AddImageCubit(),
                    ),
                    BlocProvider(
                      create: (context) => CategoryCubit(
                          category:
                              (routeSettings.arguments as StoreMenuItemModel)
                                  .category!),
                    ),
                    BlocProvider(
                      create: (context) => AvailableCubit(
                          availability:
                              (routeSettings.arguments as StoreMenuItemModel)
                                  .isavailable!),
                    ),
                    BlocProvider(
                      create: (context) => ModifyMenuItemCubit(),
                    ),
                  ],
                  child: ModifyMenuItemScreen(
                    menuItemModel:
                        routeSettings.arguments as StoreMenuItemModel,
                  ),
                ),
            settings: routeSettings);

      case Routes.store_OrdersScreen:
        return MaterialPageRoute(
            builder: (context) => const StoreOrdersScreen(),
            settings: routeSettings);

      //SETTINGS SCREENS
      case Routes.store_SettingsScreen:
        return MaterialPageRoute(
            builder: (context) => const StoreSettingsScreen(),
            settings: routeSettings);

      case Routes.store_managementScreen:
        return MaterialPageRoute(
            builder: (context) => MultiBlocProvider(providers: [
                  BlocProvider(create: (context) => OpeningTimeCubit()),
                  BlocProvider(create: (context) => ClosingTimeCubit()),
                  BlocProvider(create: (context) => AvailibilityCubit()),
                  BlocProvider(create: (context) => ManagementCubit()),
                ], child: const StoreManagementScreen()),
            settings: routeSettings);

      case Routes.store_managementUpdated:
        return MaterialPageRoute(
            builder: (context) => const StoreManagementUpdated(),
            settings: routeSettings);

      case Routes.store_profileScreen:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => UserNameCubit(),
                  child: const StoreProfileScreen(),
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
