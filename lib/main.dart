import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/Bottom_Nav_Bar.dart';
import 'package:food_cafe/cubits/billing_cubit/billing_cubit.dart';
import 'package:food_cafe/cubits/billing_cubit/checkout_cubit/billingCheckout_cubit.dart';
import 'package:food_cafe/cubits/billing_cubit/priceCalculation_cubit/priceCalculation_cubit.dart';
import 'package:food_cafe/cubits/cart_cubit/cartLocalState_cubit.dart';
import 'package:food_cafe/cubits/home_cubit/homescreen_cubit.dart';
import 'package:food_cafe/cubits/login_cubit/login_cubit.dart';
import 'package:food_cafe/cubits/login_cubit/login_state.dart';
import 'package:food_cafe/cubits/payment_cubit/payment_app_cubit/payment_app_cubit.dart';
import 'package:food_cafe/cubits/payment_cubit/payment_cubit/payment_cubit.dart';
import 'package:food_cafe/cubits/store_additem_cubit/additem_cubit.dart';
import 'package:food_cafe/cubits/store_analytics_cubit/store_analytics_cubit.dart';
import 'package:food_cafe/cubits/store_home_cubit/store_home_cubit.dart';
import 'package:food_cafe/cubits/store_menuitem_cubit/menuItem_cubit.dart';
import 'package:food_cafe/cubits/store_orders_cubit/store_orders_cubit.dart';
import 'package:food_cafe/cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/core/routes/generated_routes.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:food_cafe/screens/change_password_screen.dart';
import 'package:food_cafe/screens/splash_screen.dart';
import 'package:food_cafe/screens/store_screens/store_HomeScreen.dart';
import 'package:food_cafe/screens/store_screens/store_analytics_screen.dart';
import 'package:food_cafe/screens/store_screens/store_modify_menuitem_screen.dart';
import 'package:food_cafe/screens/user_screens/OnBoard_Screen.dart';
import 'package:food_cafe/screens/user_screens/Payment_Screen.dart';
import 'package:food_cafe/screens/user_screens/auth_screens/SignIn_Screen.dart';
import 'package:food_cafe/screens/user_screens/auth_screens/SignUpVerification_Screen.dart';
import 'package:food_cafe/theme.dart';

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
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => ThemeCubit()),
              BlocProvider(create: (context) => LoginCubit()),
              BlocProvider(create: (context) => HomeScreenCubit()),
              // BlocProvider(create: (context) => CartDisplayCubit()),
              BlocProvider(create: (context) => CartLocalState()),
              BlocProvider(create: (context) => BillingHostelCubit()),
              BlocProvider(create: (context) => BillingCheckOutCubit()),
              BlocProvider(create: (context) => BillingCubit()),
              BlocProvider(create: (context) => BillingPaymentCubit()),
              BlocProvider(create: (context) => BillingDineSelectionCubit()),
              BlocProvider(
                create: (context) => TimerCubit(),
              ),
              BlocProvider(
                create: (context) =>
                    PaymentAppCubit(), //TODO Check this one (Its already been Initialized with Payment Screen)
              ),
              BlocProvider(
                create: (context) =>
                    PaymentCubit(), //TODO Check this one (Its already been Initialized with Payment Screen)
              ),
              BlocProvider(create: (context) => HomePastOrders()),
              BlocProvider(create: (context) => AddItemCubit()), //Store
              // BlocProvider(create: (context) => MenuItemCubit()), //Store
              // BlocProvider(create: (context) => RequestedOrdersCubit()), //Store
              BlocProvider(create: (context) => OrdersTabCubit()), //Store
              // BlocProvider(create: (context) => CurrentOrdersCubit()), //Store
              // BlocProvider(create: (context) => PastOrdersCubit()),

              // BlocProvider(create: (context) => PasswordVisibility()),
              // BlocProvider(create: (context) => ConfirmPasswordVisibility()),
              BlocProvider(create: (context) => ResendVerificationCubit()),
              // BlocProvider(create: (context) => AnalyticsCubit()),
            ],
            child: MyApp(),
          );
        },
      ),
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
        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: GeneratedRoutes.generateRoutes,
        theme: theme,
        home: BlocBuilder<LoginCubit, LoginState>(
          buildWhen: (oldstate, newstate) {
            return oldstate is LoginInitialState;
          },
          builder: (context, state) {
            if (state is LoginLoggedInState) {
              return BottomNavBar();
            } else if (state is CafeLoginLoadedState) {
              return store_HomeScreen();
            } else if (state is LoginRequiredVerificationState ||
                state is CafeLoginRequiredVerificationState) {
              return SignUpVerification();
            } else if (state is LoginLoggedOutState) {
              return SignIn();
            }

            return SplashScreen();
          },
        )
        // initialRoute: Routes.changePasswordScreen,
        );
  }
}
