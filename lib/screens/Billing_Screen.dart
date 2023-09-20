import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/billing_cubit/billing_cubit.dart';
import 'package:food_cafe/cubits/billing_cubit/billing_state.dart';
import 'package:food_cafe/cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/screens/Home_Screen.dart';
import 'package:food_cafe/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/widgets/custom_TextButton.dart';

import '../cubits/login_cubit/login_cubit.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({Key? key}) : super(key: key);

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  late Timer _timer;
  int pagenumber = 0;
  int _currentpage = 0;
  final PageController _pageController = PageController(initialPage: 0);
  late String entryNo;
  late final BillingCubit_variable;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    entryNo = context.read<LoginCubit>().getEntryNo();
    context.read<BillingCubit>().calculateSubtotal(entryNo, true);
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
    BillingCubit_variable.subTotal = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BillingCubit_variable = BlocProvider.of<BillingCubit>(context);
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
          onPressed: () {},
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
                  "Billing Screen",
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Discount",
                            style: theme.textTheme.titleSmall,
                          ),
                          Text(
                            "NULL",
                            style: theme.textTheme.titleSmall,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
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
                            context.read<BillingCubit>().calculateSubtotal(entryNo, true);
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
                            context.read<BillingCubit>().calculateSubtotal(entryNo, false);
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
