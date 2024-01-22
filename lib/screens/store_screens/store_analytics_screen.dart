import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/cubits/store_analytics_cubit/store_analytics_cubit.dart';
import 'package:food_cafe/cubits/store_analytics_cubit/store_analytics_states.dart';
import 'package:food_cafe/cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/data/models/store_analytics_model.dart';
import 'package:food_cafe/theme.dart';
import 'package:food_cafe/widgets/custom_FoodCard.dart';
import 'package:food_cafe/widgets/headings.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  late AnalyticsCubit analyticsCubit;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    analyticsCubit = BlocProvider.of(context);
    analyticsCubit.loadAnalytics(storeID: 'SMVDU101');
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;
    final ThemeData theme = themeMode == MyTheme.dark ? darkTheme : lightTheme;
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hey there!",
                        style: theme.textTheme.bodyLarge!.copyWith(
                          fontSize: 20.sp,
                        ),
                      ),
                      Text(
                        'SMVDU101',
                        style: theme.textTheme.labelLarge!
                            .copyWith(fontSize: 25.sp, height: 1),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.black,
                    child: Icon(
                      Icons.person,
                      size: 30.sp,
                      color: theme.colorScheme.secondary,
                    ),
                    radius: 25.sp,
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Your Analytics!",
                style: theme.textTheme.headlineLarge,
              ),
              Text(
                "The detailed analytics for your store is listed below!",
                style: theme.textTheme.bodySmall,
              ),
              SizedBox(
                height: 10,
              ),
              BlocBuilder<AnalyticsCubit, AnalyticsStates>(
                  builder: (context, state) {
                if (state is AnalyticsLoadingState) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                } else if (state is AnalyticsErrorState) {
                  return Center(
                    child: Text(state.error),
                  );
                } else if (state is AnalyticsLoadedState) {
                  return Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: theme.colorScheme.primary,
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0XFFDE396B),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 30),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 40,
                                    child: Icon(
                                      Icons.credit_score_rounded,
                                      color: Colors.green,
                                      size: 50,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Your Today's income is",
                                    style: theme.textTheme.headlineMedium,
                                  ),
                                  Text(
                                    "₹ ${state.dailyAnalytics.totalAmountSold}/-",
                                    style: theme.textTheme.labelLarge!.copyWith(
                                        fontSize: 25.sp,
                                        height: 1.2,
                                        color: Colors.green),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Total Number of Orders requested today",
                                    style: theme.textTheme.headlineMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    state.dailyAnalytics.totalItemsRequested
                                        .toString(),
                                    style: theme.textTheme.labelLarge!.copyWith(
                                        fontSize: 25.sp,
                                        height: 1.2,
                                        color: Colors.green),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Total Number of Orders accepted today",
                                    style: theme.textTheme.headlineMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    state.dailyAnalytics.totalItemsAccepted
                                        .toString(),
                                    style: theme.textTheme.labelLarge!.copyWith(
                                        fontSize: 25.sp,
                                        height: 1.2,
                                        color: Colors.green),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'Daily Overview',
                              style: theme.textTheme.bodyLarge!.copyWith(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.green),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: theme.colorScheme.primary,
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.yellow.shade900,
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 30),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 40,
                                        child: Icon(
                                          Icons.payments_rounded,
                                          color: Colors.blueAccent,
                                          size: 50,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 15),
                                        child: Text(
                                          "Your Monthly income is",
                                          style: theme.textTheme.headlineMedium,
                                        ),
                                      ),
                                      Text(
                                        "₹ ${state.monthlyAnalytics.totalAmountSold}/-",
                                        style: theme.textTheme.labelLarge!.copyWith(
                                            fontSize: 25.sp,
                                            height: 1.2,
                                            color: Colors.blueAccent),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 15),
                                        child: Text(
                                          "Total Number of Orders requested for this Month",
                                          style: theme.textTheme.headlineMedium,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Text(
                                        state.monthlyAnalytics.totalItemsRequested
                                            .toString(),
                                        style: theme.textTheme.labelLarge!.copyWith(
                                            fontSize: 25.sp,
                                            height: 1.2,
                                            color: Colors.blueAccent),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 15),
                                        child: Text(
                                          "Total Number of Orders accepted for this Month",
                                          style: theme.textTheme.headlineMedium,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Text(
                                        state.monthlyAnalytics.totalItemsAccepted
                                            .toString(),
                                        style: theme.textTheme.labelLarge!.copyWith(
                                            fontSize: 25.sp,
                                            height: 1.2,
                                            color: Colors.blueAccent),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    child: Text(
                                      "Monthly\nProduct Analysis",
                                      style: theme.textTheme.headlineMedium!.copyWith(color: Colors.black),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      physics: BouncingScrollPhysics(),
                                      child: Row(
                                        children: List.generate(
                                          state.monthlyAnalytics.itemsSold!.length,
                                          (index) => Padding(
                                            padding: EdgeInsets.only(right: 20),
                                            child: store_FoodCard(
                                                onTap: () {},
                                                productAnalysisModel: state.monthlyAnalytics.itemsSold![index],
                                                theme: theme),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                 
                                ],
                              ),
                            ),
                            Text(
                              'Monthly Overview',
                              style: theme.textTheme.bodyLarge!.copyWith(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.blueAccent),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return Center(
                  child: Text("Loading your Analytics"),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
