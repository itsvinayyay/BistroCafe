import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/cubits/common_cubits/password_visibility_cubits/password_visibility_cubits.dart';
import 'package:food_cafe/cubits/user_role_cubits/billing_cubit/checkout_cubit/billing_checkout_cubit.dart';
import 'package:food_cafe/cubits/user_role_cubits/cart_cubits/cart_display_cubit/cart_display_cubit.dart';
import 'package:food_cafe/screens/common_screens/splash_screen.dart';
import 'package:food_cafe/screens/user_screens/feed_screens/home_nav_bar.dart';

import 'package:food_cafe/cubits/user_role_cubits/cart_cubits/cart_local_state_cubit/cart_local_state_cubit.dart';
import 'package:food_cafe/cubits/user_role_cubits/home_menu_item_cubit/home_menu_item_cubit.dart';
import 'package:food_cafe/cubits/common_cubits/login_cubit/login_cubit.dart';
import 'package:food_cafe/cubits/common_cubits/login_cubit/login_state.dart';

import 'package:food_cafe/cubits/user_role_cubits/payment_cubit/payment_cubit.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_add_new_menu_item_cubits/store_add_menu_item_cubit/add_menu_item_cubit.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_home_cubit/store_home_cubit.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_orders_cubit/store_orders_cubit.dart';
import 'package:food_cafe/cubits/common_cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/core/routes/generated_routes.dart';
import 'package:food_cafe/screens/store_screens/home_screens/store_home_screen.dart';
import 'package:food_cafe/screens/user_screens/auth_screens/sign_in_screen.dart';
import 'package:food_cafe/screens/user_screens/auth_screens/sign_up_verification_screen.dart';
import 'package:food_cafe/core/theme/theme.dart';
import 'package:food_cafe/screens/user_screens/on_board_screens/on_board_screen_1.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print(message.notification!.title.toString());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => ThemeCubit()),
            BlocProvider(create: (context) => LoginCubit()),
            BlocProvider(create: (context) => CartLocalStateInitializedCubit()),

            // BlocProvider(create: (context) => CartDisplayCubit()),
            BlocProvider(create: (context) => CartLocalState()),
            // BlocProvider(create: (context) => BillingHostelCubit()),
            BlocProvider(create: (context) => BillingCheckOutCubit()),
            // BlocProvider(create: (context) => BillingCubit()),
            // BlocProvider(create: (context) => BillingPaymentCubit()),
            // BlocProvider(create: (context) => BillingDineSelectionCubit()),
            // BlocProvider(
            //   create: (context) => TimerCubit(),
            // ),
            // BlocProvider(
            //   create: (context) =>
            //       PaymentAppCubit(), //TODO Check this one (Its already been Initialized with Payment Screen)
            // ),
            BlocProvider(
              create: (context) =>
                  PaymentCubit(), //TODO Check this one (Its already been Initialized with Payment Screen)
            ),
            // BlocProvider(create: (context) => HomePastOrders()), //store
            // BlocProvider(create: (context) => AddItemCubit()), //Store
            // BlocProvider(create: (context) => MenuItemCubit()), //Store
            // BlocProvider(create: (context) => RequestedOrdersCubit()), //Store
            BlocProvider(create: (context) => OrdersTabCubit()), //Store
            // BlocProvider(create: (context) => CurrentOrdersCubit()), //Store
            // BlocProvider(create: (context) => PastOrdersCubit()),

            // BlocProvider(create: (context) => PasswordVisibility()),
            // BlocProvider(create: (context) => ConfirmPasswordVisibility()),
            // BlocProvider(create: (context) => ResendVerificationCubit()),
            // BlocProvider(create: (context) => AnalyticsCubit()),
          ],
          child: MyApp(),
        );
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;
    final ThemeData theme = themeMode == MyTheme.dark ? darkTheme : lightTheme;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: GeneratedRoutes.generateRoutes,
        theme: theme,
        home: BlocBuilder<LoginCubit, LoginState>(
          buildWhen: (oldstate, newstate) {
            return oldstate is LoginSplashState;
          },
          builder: (context, state) {
            if (state is LoginLoggedInState) {
              return MultiBlocProvider(providers: [
                BlocProvider(
                  create: (context) => CartDisplayCubit(),
                ),
                BlocProvider(
                  create: (context) => HomeMenuItemsCubit(),
                ),
              ], child: BottomNavBar());
            } else if (state is CafeLoginLoadedState) {
              return BlocProvider(
                create: (context) => HomePastOrdersCubit(),
                child: StoreHomeScreen(),
              );
            } else if (state is LoginRequiredVerificationState ||
                state is CafeLoginRequiredVerificationState) {
              return SignUpVerification();
            } else if (state is LoginLoggedOutState) {
              return BlocProvider(
                create: (context) => PasswordVisibility(),
                child: SignInScreen(),
              );
            } else if (state is LoginInitialState) {
              return OnBoard();
            }

            return SplashScreen();
          },
        ));
  }
}
