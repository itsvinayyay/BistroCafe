import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/billing_cubit/checkout_cubit/billingCheckout_cubit.dart';
import 'package:food_cafe/cubits/billing_cubit/checkout_cubit/billingCheckout_state.dart';
import 'package:food_cafe/cubits/billing_cubit/billing_cubit.dart';
import 'package:food_cafe/cubits/billing_cubit/priceCalculation_cubit/priceCalculation_cubit.dart';
import 'package:food_cafe/cubits/billing_cubit/priceCalculation_cubit/priceCalculation_states.dart';
import 'package:food_cafe/cubits/login_cubit/login_cubit.dart';
import 'package:food_cafe/cubits/login_cubit/login_state.dart';
import 'package:food_cafe/cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/data/services/notification_services.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:food_cafe/screens/user_screens/home_screen/Home_Screen.dart';
import 'package:food_cafe/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({Key? key}) : super(key: key);

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  NotificationServices notificationServices = NotificationServices();
  late BillingCheckOutCubit billingCheckOutCubit = BillingCheckOutCubit();
  late Timer _timer;
  int pagenumber = 0;
  int _currentpage = 0;
  final PageController _pageController = PageController(initialPage: 0);
  late String personID;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    billingCheckOutCubit = BlocProvider.of<BillingCheckOutCubit>(context);

    final state = context.read<LoginCubit>().state;
    if (state is LoginLoggedInState) {
      personID = state.personID;
    } else {
      log("Some State Error Occured in Billing Screen");
      personID = "error";
    }
    context.read<BillingCubit>().calculateSubtotal(personID, true);
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_currentpage < 3) {
        _currentpage++;
      } else {
        _currentpage = 0;
      }

      _pageController.animateToPage(_currentpage,
          duration: Duration(milliseconds: 350), curve: Curves.easeIn);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;
    final ThemeData theme = themeMode == MyTheme.dark ? darkTheme : lightTheme;
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.secondary,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: TextButton(
          onPressed: () {
            final Billstate = context.read<BillingCubit>().state;
            bool dineIn = context.read<BillingDineSelectionCubit>().state;
            bool isCash = context.read<BillingPaymentCubit>().state;
            int total = 0;
            if (Billstate is BillLoadedState) {
              total = Billstate.total;
            }
            String hostelName = "Null";
            if (dineIn == false) {
              hostelName =
                  getHostelName(context.read<BillingHostelCubit>().state);
            }
            final customerName = FirebaseAuth.instance.currentUser!.displayName;

            showDialog(
                context: context,
                builder: (_) => alertDialog(
                    isDineIn: dineIn,
                    isCash: isCash,
                    total: total,
                    theme: theme,
                    context: context,
                    hostelName: hostelName,
                    customerName: customerName!,
                    personID: personID));
          },
          child: Text(
            "Checkout!",
            style: theme.textTheme.labelLarge,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 18.h),
          ),
        ),
      ),
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                ),
                Text(
                  "Billings",
                  style: theme.textTheme.titleMedium,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: theme.colorScheme.secondary,
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 29.w, vertical: 20.h),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Sub-Total",
                            style: theme.textTheme.titleSmall,
                          ),
                          BlocBuilder<BillingCubit, BillingState>(
                              builder: (context, state) {
                            if (state is BillLoadedState) {
                              return Text(
                                "₹ ${state.subTotal}",
                                style: theme.textTheme.titleSmall,
                              );
                            }
                            return Center(child: CircularProgressIndicator());
                          }),
                        ],
                      ),
                      BlocBuilder<BillingDineSelectionCubit, bool>(
                          builder: (context, isDineEnabled) {
                        if (isDineEnabled == false) {
                          return Column(
                            children: [
                              SizedBox(
                                height: 7.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Delivery Charge",
                                    style: theme.textTheme.titleSmall,
                                  ),
                                  Text(
                                    "₹ 10",
                                    style: theme.textTheme.titleSmall,
                                  ),
                                ],
                              ),
                            ],
                          );
                        }
                        return Column();
                      }),
                      SizedBox(
                        height: 7.h,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text(
                      //       "Discount",
                      //       style: theme.textTheme.titleSmall,
                      //     ),
                      //     Text(
                      //       "NULL",
                      //       style: theme.textTheme.titleSmall,
                      //     ),
                      //   ],
                      // ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total",
                            style: theme.textTheme.headlineMedium,
                          ),
                          BlocBuilder<BillingCubit, BillingState>(
                              builder: (context, state) {
                            if (state is BillLoadedState) {
                              return Text(
                                "₹ ${state.total}",
                                style: theme.textTheme.headlineMedium,
                              );
                            }
                            return Center(child: CircularProgressIndicator());
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                BlocBuilder<BillingDineSelectionCubit, bool>(
                    builder: (context, isDineEnabled) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (isDineEnabled == false) {
                            context
                                .read<BillingDineSelectionCubit>()
                                .toggleDineIn(true);
                            context
                                .read<BillingCubit>()
                                .calculateSubtotal(personID, true);
                          }
                        },
                        child: Container(
                          width: 150.w,
                          height: 60.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isDineEnabled == true
                                ? theme.colorScheme.secondary
                                : theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            "Dine In",
                            style: theme.textTheme.titleSmall,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (isDineEnabled == true) {
                            context
                                .read<BillingDineSelectionCubit>()
                                .toggleDineIn(false);
                            context
                                .read<BillingCubit>()
                                .calculateSubtotal(personID, false);
                          }
                        },
                        child: Container(
                          width: 150.w,
                          height: 60.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isDineEnabled == true
                                ? theme.colorScheme.primary
                                : theme.colorScheme.secondary,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            "Dine Out",
                            style: theme.textTheme.titleSmall,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                SizedBox(
                  height: 20,
                ),
                BlocBuilder<BillingDineSelectionCubit, bool>(
                    builder: (context, isDineEnabled) {
                  if (isDineEnabled == true) {
                    return Column(
                      children: [
                        BlocBuilder<BillingPaymentCubit, bool>(
                            builder: (context, isEnabled) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  print(isEnabled);
                                  if (isEnabled == false) {
                                    context
                                        .read<BillingPaymentCubit>()
                                        .togglePaymentMethod(true);
                                  }
                                },
                                child: Container(
                                  width: 150.w,
                                  height: 60.h,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isEnabled == true
                                        ? theme.colorScheme.secondary
                                        : theme.colorScheme.primary,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    "COD",
                                    style: theme.textTheme.titleSmall,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  print(isEnabled);
                                  if (isEnabled == true) {
                                    context
                                        .read<BillingPaymentCubit>()
                                        .togglePaymentMethod(false);
                                  }
                                },
                                child: Container(
                                  width: 150.w,
                                  height: 60.h,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isEnabled == true
                                        ? theme.colorScheme.primary
                                        : theme.colorScheme.secondary,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    "Online",
                                    style: theme.textTheme.titleSmall,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    );
                  }
                  return Column();
                }),
                BlocBuilder<BillingDineSelectionCubit, bool>(
                    builder: (context, isDineEnabled) {
                  if (isDineEnabled == false) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Available Hostels",
                          style: theme.textTheme.titleSmall,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        BlocBuilder<BillingHostelCubit, int>(
                            builder: (context, selectedIndex) {
                          return SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                ...List.generate(
                                  Hostels.length,
                                  (index) => hostelCards(
                                      theme: theme,
                                      hostelName: Hostels[index],
                                      ischecked:
                                          selectedIndex == index ? true : false,
                                      onTap: () {
                                        context
                                            .read<BillingHostelCubit>()
                                            .updateHostel(index);
                                      }),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    );
                  }
                  return Column();
                }),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Promotions",
                  style: theme.textTheme.titleSmall,
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 160.h,
                  child: PageView(
                    physics: BouncingScrollPhysics(),
                    // onPageChanged: (value){
                    //   setState(() {
                    //     _currentpage = value;
                    //   });
                    // },
                    controller: _pageController,
                    children: List.generate(
                      banners.length,
                      (index) => homescreenBanner(
                        context: context,
                        theme: theme,
                        imageURL: banners[index]["image_url"],
                        title: banners[index]["title"],
                        details: banners[index]["details"],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector hostelCards(
      {required ThemeData theme,
      required String hostelName,
      required bool ischecked,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.bottomCenter,
        margin: EdgeInsets.only(right: 10),
        // padding: EdgeInsets.all(10),
        height: 120,
        width: 200,
        decoration: BoxDecoration(
          color: ischecked == true ? Colors.green : theme.colorScheme.secondary,
          // image: DecorationImage(
          //     image: NetworkImage("http://bdacademyedu.com/images/hostyell.jpg"),
          //     fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          hostelName,
          style: theme.textTheme.headlineMedium,
        ),
      ),
    );
  }

  AlertDialog alertDialog(
      {required bool isDineIn,
      required bool isCash,
      required String hostelName,
      required int total,
      required String customerName,
      required String personID,
      required ThemeData theme,
      required BuildContext context}) {
    isCash = isDineIn == false ? false : isCash;
    
    String modeofPayment = isCash == true ? "Cash" : "Online";
    return AlertDialog(
      backgroundColor: theme.colorScheme.secondary,
      title: Text(
        "Do you want to place your Order?",
        style: theme.textTheme.headlineMedium,
      ),
      content: Text(
        isDineIn == true
            ? "Are you sure you want to proceed with $modeofPayment (mode of Payment) for Dine-In with total amount of Rs. $total"
            : "Are you sure you want to proceed with $modeofPayment (mode of Payment) for Dine-Out ($hostelName) with total amount of Rs. $total",
        style: theme.textTheme.bodyLarge,
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("No")),
        BlocConsumer<BillingCheckOutCubit, BillingCheckoutState>(
          builder: (context, state) {
            if (state is BillingCheckoutLoadingState) {
              log("state is BillingCheckOutLoading State");
              return CircularProgressIndicator(
                color: Colors.white,
              );
            }
            return TextButton(
                onPressed: () {
                  notificationServices.getDeviceToken().then((value) async {
                    await billingCheckOutCubit.billingCheckout(
                        customerName: customerName,
                        personID: personID,
                        totalMRP: total,
                        isDineIn: isDineIn,
                        isCash: isCash,
                        
                        storeID: "SMVDU101",
                        hostelName: hostelName,
                        userTokenID: value);
                  });
                },
                child: Text("Yes"));
          },
          listener: (context, state) {
            if (state is BillingCheckoutLoadedState) {
              log("state is BillingCheckOutLoaded State");
              Navigator.pushNamedAndRemoveUntil(
                  context, Routes.orderRequestScreen, (route) => false,
                  arguments: isCash);
            } else if (state is BillingCheckoutErrorState) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.error)));
            }
          },
        )
      ],
    );
  }
}

List Hostels = [
  "Shivalik",
  "Vaishnavi",
  "Trikuta",
  "Kailash",
  "New Bhasoli",
  "Old Bhasoli",
  "Nigiri",
  "Vindhyanchal",
];

String getHostelName(int hostelNumber) {
  return Hostels[hostelNumber];
}
