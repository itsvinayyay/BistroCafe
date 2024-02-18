import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/user_role_cubits/billing_cubit/checkout_cubit/billing_checkout_cubit.dart';
import 'package:food_cafe/cubits/user_role_cubits/billing_cubit/checkout_cubit/billing_checkout_states.dart';
import 'package:food_cafe/cubits/user_role_cubits/billing_cubit/billing_other_cubits.dart';
import 'package:food_cafe/cubits/user_role_cubits/billing_cubit/priceCalculation_cubit/price_calculation_cubit.dart';
import 'package:food_cafe/cubits/user_role_cubits/billing_cubit/priceCalculation_cubit/price_calculation_states.dart';
import 'package:food_cafe/cubits/user_role_cubits/cart_cubits/cart_local_state_cubit/cart_local_state_cubit.dart';
import 'package:food_cafe/data/services/connectivity_service.dart';
import 'package:food_cafe/data/services/notification_services.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:food_cafe/screens/user_screens/feed_screens/home_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/utils/login_state_check.dart';
import 'package:food_cafe/utils/theme_check.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({Key? key}) : super(key: key);

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  NotificationServices notificationServices = NotificationServices();
  late BillingPriceCalculationCubit _billingCubit;
  late BillingCheckOutCubit _billingCheckOutCubit;
  late BillingDineSelectionCubit _billingDineSelectionCubit;
  late BillingPaymentCubit _billingPaymentCubit;
  late BillingHostelCubit _billingHostelCubit;
  late Timer _timer;
  int pagenumber = 0;
  int _currentpage = 0;
  final PageController _pageController = PageController(initialPage: 0);
  late String personID;

  void _initializeCubits() {
    _billingCubit = BlocProvider.of<BillingPriceCalculationCubit>(context);
    _billingCheckOutCubit = BlocProvider.of<BillingCheckOutCubit>(context);
    _billingDineSelectionCubit =
        BlocProvider.of<BillingDineSelectionCubit>(context);
    _billingPaymentCubit = BlocProvider.of<BillingPaymentCubit>(context);
    _billingHostelCubit = BlocProvider.of<BillingHostelCubit>(context);

    personID =
        checkLoginStateForUser(context: context, screenName: 'Billing Screen');
    _billingCubit.calculateSubtotal(personID: personID, isDineIn: true);
  }

  void _disposeCubits() {
    // _billingCheckOutCubit.close();
    _billingCubit.close();
    _billingDineSelectionCubit.close();
    _billingHostelCubit.close();
    _billingPaymentCubit.close();
  }

  @override
  void initState() {
    super.initState();
    _initializeCubits();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentpage < 3) {
        _currentpage++;
      } else {
        _currentpage = 0;
      }

      _pageController.animateToPage(_currentpage,
          duration: const Duration(milliseconds: 350), curve: Curves.easeIn);
    });
  }

  @override
  void dispose() {
    _disposeCubits();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = getTheme(context: context);
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.secondary,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: TextButton(
          onPressed: () {
            final billingState = _billingCubit.state;
            bool dineIn = _billingDineSelectionCubit.state;
            bool isCash = _billingPaymentCubit.state;
            int total = 0;
            if (billingState is BillLoadedState) {
              total = billingState.total;
            }
            String hostelName = "Null";
            if (dineIn == false) {
              hostelName = getHostelName(_billingHostelCubit.state);
            }
            final customerName = FirebaseAuth.instance.currentUser!.displayName;
            showDialog(
              context: context,
              builder: (_) => _buildAlertDialog(
                  isDineIn: dineIn,
                  isCash: isCash,
                  total: total,
                  theme: theme,
                  context: context,
                  hostelName: hostelName,
                  customerName: customerName!,
                  personID: personID),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 18.h),
          ),
          child: Text(
            "Checkout!",
            style: theme.textTheme.labelLarge,
          ),
        ),
      ),
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Text(
                  'Billings',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(
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
                          BlocBuilder<BillingPriceCalculationCubit,
                              BillingState>(builder: (context, state) {
                            if (state is BillLoadedState) {
                              return Text(
                                "₹ ${state.subTotal}",
                                style: theme.textTheme.titleSmall,
                              );
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          }),
                        ],
                      ),
                      BlocBuilder<BillingDineSelectionCubit, bool>(
                          builder: (context, isDineIn) {
                        if (isDineIn == false) {
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
                        return const SizedBox();
                      }),
                      SizedBox(
                        height: 7.h,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total",
                            style: theme.textTheme.headlineMedium,
                          ),
                          BlocBuilder<BillingPriceCalculationCubit,
                              BillingState>(builder: (context, state) {
                            if (state is BillLoadedState) {
                              return Text(
                                "₹ ${state.total}",
                                style: theme.textTheme.headlineMedium,
                              );
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Choose Dine Type",
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(
                  height: 5,
                ),
                BlocBuilder<BillingDineSelectionCubit, bool>(
                    builder: (context, isDineIn) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildChoiceButton(
                        isButtonEnabled: isDineIn,
                        theme: theme,
                        onTap: () {
                          if (isDineIn == false) {
                            _billingDineSelectionCubit.toggleDineIn(isDineIn);
                            _billingCubit.calculateSubtotal(
                                personID: personID, isDineIn: true);
                          }
                        },
                        buttonName: 'Dine In',
                      ),
                      _buildChoiceButton(
                          isButtonEnabled: !isDineIn,
                          theme: theme,
                          onTap: () {
                            if (isDineIn == true) {
                              _billingDineSelectionCubit.toggleDineIn(isDineIn);

                              _billingCubit.calculateSubtotal(
                                  personID: personID, isDineIn: false);
                            }
                          },
                          buttonName: 'Dine Out'),
                    ],
                  );
                }),
                const SizedBox(
                  height: 20,
                ),
                BlocBuilder<BillingDineSelectionCubit, bool>(
                    builder: (context, isDineEnabled) {
                  if (isDineEnabled == true) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Choose Payment Mode",
                          style: theme.textTheme.titleSmall,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        BlocBuilder<BillingPaymentCubit, bool>(
                            builder: (context, isEnabled) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildChoiceButton(
                                  isButtonEnabled: isEnabled,
                                  theme: theme,
                                  onTap: () {
                                    if (isEnabled == false) {
                                      _billingPaymentCubit
                                          .togglePaymentMethod(true);
                                    }
                                  },
                                  buttonName: 'COD'),
                              _buildChoiceButton(
                                  isButtonEnabled: !isEnabled,
                                  theme: theme,
                                  onTap: () {
                                    if (isEnabled == true) {
                                      _billingPaymentCubit
                                          .togglePaymentMethod(false);
                                    }
                                  },
                                  buttonName: 'Online'),
                            ],
                          );
                        }),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    );
                  }
                  return const SizedBox();
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
                        const SizedBox(
                          height: 10,
                        ),
                        BlocBuilder<BillingHostelCubit, int>(
                            builder: (context, selectedIndex) {
                          return SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                ...List.generate(
                                  hostelNames.length,
                                  (index) => hostelCards(
                                      theme: theme,
                                      hostelName: hostelNames[index],
                                      ischecked:
                                          selectedIndex == index ? true : false,
                                      onTap: () {
                                        _billingHostelCubit.updateHostel(index);
                                      }),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    );
                  }
                  return const SizedBox();
                }),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Promotions",
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 160.h,
                  child: PageView(
                    physics: const BouncingScrollPhysics(),
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

  GestureDetector _buildChoiceButton(
      {required bool isButtonEnabled,
      required ThemeData theme,
      required VoidCallback onTap,
      required String buttonName}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150.w,
        height: 60.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isButtonEnabled
              ? theme.colorScheme.secondary
              : theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          buttonName,
          style: theme.textTheme.titleSmall,
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
        margin: const EdgeInsets.only(right: 10),
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

  AlertDialog _buildAlertDialog(
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
            child: const Text("No")),
        BlocConsumer<BillingCheckOutCubit, BillingCheckoutState>(
          builder: (context, state) {
            if (state is BillingCheckoutLoadingState) {
              log("state is BillingCheckOutLoading State");
              return const CircularProgressIndicator(
                color: Colors.white,
              );
            }
            return TextButton(
                onPressed: () async {
                  await checkConnectivity(
                      context: context,
                      onConnected: () {
                        notificationServices
                            .getDeviceToken()
                            .then((value) async {
                          await _billingCheckOutCubit.billingCheckout(
                              customerName: customerName,
                              personID: personID,
                              totalMRP: total,
                              isDineIn: isDineIn,
                              isCash: isCash,
                              storeID: "SMVDU101",
                              hostelName: hostelName,
                              userTokenID: value);
                          
                        });
                      });
                },
                child: const Text("Yes"));
          },
          listener: (context, state) {
            if (state is BillingCheckoutLoadedState) {
              // log("state is BillingCheckOutLoaded State");
              context.read<CartLocalState>().clearLocalState();
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

List hostelNames = [
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
  return hostelNames[hostelNumber];
}
