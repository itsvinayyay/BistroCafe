import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:food_cafe/data/services/notification_services.dart';
import 'package:food_cafe/theme.dart';
import 'package:food_cafe/widgets/custom_TextButton.dart';

class OrderPlacedScreen extends StatefulWidget {
  const OrderPlacedScreen({Key? key}) : super(key: key);

  @override
  State<OrderPlacedScreen> createState() => _OrderPlacedScreenState();
}

class _OrderPlacedScreenState extends State<OrderPlacedScreen> {
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
  }
  @override
  Widget build(BuildContext context) {
    bool isAccepted = ModalRoute.of(context)!.settings.arguments as bool;
    final themeMode = context.watch<ThemeCubit>().state;
    final ThemeData theme = themeMode == MyTheme.dark ? darkTheme : lightTheme;
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(isAccepted == true
                          ? "assets/images/orderPlaced.gif"
                          : "assets/images/orderNotPlaced.gif")),
                  SizedBox(
                    height: 33.h,
                  ),
                  Text(
                    isAccepted ? "Order Placed!" : "Order Rejected!",
                    style: TextStyle(
                        fontSize: 30.sp,
                        fontFamily: "BentonSans_Bold",
                        fontWeight: FontWeight.w400,
                        color: isAccepted
                            ? theme.colorScheme.tertiary
                            : Colors.red),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Text(
                    isAccepted
                        ? "Cafe Owner has accepted your Order Request!"
                        : "Cafe Owner has Rejected your Order Request!",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 250.w,
                    child: Text(
                      isAccepted
                          ? "Sit back and Relax!\n We'll Notify you when your Order is ready!"
                          : "Contact the Cafe Owner! \n Store ID is SMVDU101",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelSmall,
                    ),
                  ),
                ],
              ),
              customButton(
                  context: context,
                  theme: theme,
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, Routes.bottomNav, (route) => false);
                  },
                  title: "Back to Home"),
            ],
          ),
        ),
      ),
    );
  }
}
