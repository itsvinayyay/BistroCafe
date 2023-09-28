import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/Bottom_Nav_Bar.dart';
import 'package:food_cafe/cubits/billing_cubit/billing_cubit.dart';
import 'package:food_cafe/cubits/cart_cubit/cartDisplay_cubit.dart';
import 'package:food_cafe/cubits/cart_cubit/cartLocalState_cubit.dart';
import 'package:food_cafe/cubits/home_cubit/homescreen_cubit.dart';
import 'package:food_cafe/cubits/login_cubit/login_cubit.dart';
import 'package:food_cafe/cubits/login_cubit/login_state.dart';
import 'package:food_cafe/cubits/store_additem_cubit/additem_cubit.dart';
import 'package:food_cafe/cubits/store_menuitem_cubit/menuItem_cubit.dart';
import 'package:food_cafe/cubits/store_orders_cubit/store_orders_cubit.dart';
import 'package:food_cafe/cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/routes/generated_routes.dart';
import 'package:food_cafe/routes/named_routes.dart';
import 'package:food_cafe/screens/OnBoard_Screen.dart';
import 'package:food_cafe/screens/SignIn_Screen.dart';
import 'package:food_cafe/screens/SignUpVerification_Screen.dart';
import 'package:food_cafe/theme.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(providers: [
          BlocProvider(create: (context) => ThemeCubit()),
          BlocProvider(create: (context) => LoginCubit()),
          BlocProvider(create: (context) => HomeCardCubit()),
          BlocProvider(create: (context) => CartDisplayCubit()),
          BlocProvider(create: (context) => CartLocalState()),
          BlocProvider(create: (context) => BillingHostelCubit()),
          BlocProvider(create: (context) => BillingCubit()),
          BlocProvider(create: (context) => BillingPaymentCubit()),
          BlocProvider(create: (context) => BillingDineSelectionCubit()),
          BlocProvider(create: (context) => AddItemCubit()),//Store
          BlocProvider(create: (context) => MenuItems()),//Store
          BlocProvider(create: (context) => RequestedOrdersCubit()), //Store
          BlocProvider(create: (context) => OrdersTabCubit()), //Store
          BlocProvider(create: (context) => CurrentOrdersCubit()), //Store
          BlocProvider(create: (context) => PastOrdersCubit()), //Store



        ], child: MyApp());
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
      // initialRoute: Routes.bottomNav,
      home: BlocBuilder<LoginCubit,LoginState>(
        buildWhen: (oldstate, newstate){
          return oldstate is LoginInitialState;
        },
        builder: (context, state){
          if(state is LoginLoggedInState){
            return BottomNavBar();
          }
          else if(state is LoginLoggedOutState){
            return SignIn();
          }
          else if(state is LoginuserNotVerifiedState){
            return SignUpVerification();
          }
          return OnBoard();
        },
      )


    );
  }
}
