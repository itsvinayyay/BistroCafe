import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/cubits/login_cubit/login_cubit.dart';
import 'package:food_cafe/cubits/login_cubit/login_state.dart';
import 'package:food_cafe/cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/data/services/notifications.dart';
import 'package:food_cafe/routes/named_routes.dart';
import 'package:food_cafe/screens/Home_Screen.dart';
import 'package:food_cafe/theme.dart';
import 'package:food_cafe/widgets/custom_FoodCard.dart';
import 'package:food_cafe/widgets/headings.dart';

class store_HomeScreen extends StatefulWidget {
  const store_HomeScreen({Key? key}) : super(key: key);

  @override
  State<store_HomeScreen> createState() => _store_HomeScreenState();
}

class _store_HomeScreenState extends State<store_HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  cafeOwner_Notifications cafeowner_Notifications = cafeOwner_Notifications();
  late String storeID;
  late String ID;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    ID = context.read<LoginCubit>().getEntryNo();
    storeID = await context.read<LoginCubit>().getStoreID(ID);
    cafeowner_Notifications.initialNotifications_Action(storeID);
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;
    final ThemeData theme = themeMode == MyTheme.dark ? darkTheme : lightTheme;
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40), bottomLeft: Radius.circular(40)),
        child: Drawer(
          backgroundColor: theme.colorScheme.primary,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.black,
                      child: Icon(
                        Icons.person,
                        size: 40.sp,
                        color: theme.colorScheme.secondary,
                      ),
                      radius: 30.sp,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Delightful Dining, Every Bite a Delight!',
                      style: theme.textTheme.titleSmall,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    FutureBuilder<String>(
                      future: context.read<LoginCubit>().getStoreID(ID),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          // Display a loading indicator while fetching storeID
                          return Text('Loading...', style: theme.textTheme.bodySmall,);
                        } else if (snapshot.hasError) {
                          // Handle error if any
                          return Text("Error: ${snapshot.error}", style: theme.textTheme.bodySmall,);
                        } else {
                          // Display your content once storeID is fetched
                          return Text(storeID,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20.sp,
                                  color: theme.colorScheme.primary,
                                  fontFamily: 'BentonSans_Bold'));
                        }
                      },
                    ),

                  ],
                ),
              ),
              ListTile(
                horizontalTitleGap: 0,
                leading: Icon(
                  Icons.notifications,
                  color: theme.colorScheme.secondary,
                ),
                title: Text(
                  'Notifications',
                  style: theme.textTheme.bodyLarge,
                ),
                onTap: () {
                  // Add your logic for when this item is tapped.
                },
              ),
              ListTile(
                horizontalTitleGap: 0,
                leading: Icon(
                  Icons.settings,
                  color: theme.colorScheme.secondary,
                ),
                title: Text(
                  'Settings',
                  style: theme.textTheme.bodyLarge,
                ),
                onTap: () {
                  // Add your logic for when this item is tapped.
                },
              ),
              ListTile(
                horizontalTitleGap: 0,
                leading: Icon(
                  Icons.menu_book,
                  color: theme.colorScheme.secondary,
                ),
                title: Text(
                  'Menu Items',
                  style: theme.textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.pushNamed(context, Routes.store_menuItems);
                },
              ),
              ListTile(
                horizontalTitleGap: 0,
                leading: Icon(
                  Icons.receipt_long,
                  color: theme.colorScheme.secondary,
                ),
                title: Text(
                  'Your Orders',
                  style: theme.textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.pushNamed(context, Routes.store_OrdersScreen);
                },
              ),
              ListTile(
                horizontalTitleGap: 0,
                leading: Icon(
                  Icons.add_card_rounded,
                  color: theme.colorScheme.secondary,
                ),
                title: Text(
                  'Add Menu Items',
                  style: theme.textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.pushNamed(context, Routes.store_addItemsScreen);
                },
              ),
              ListTile(
                horizontalTitleGap: 0,
                leading: Icon(
                  Icons.info_outline_rounded,
                  color: theme.colorScheme.secondary,
                ),
                title: Text(
                  'About',
                  style: theme.textTheme.bodyLarge,
                ),
                onTap: () {
                  // Add your logic for when this item is tapped.
                },
              ),
              ListTile(
                horizontalTitleGap: 0,
                leading: Icon(
                  Icons.logout,
                  color: theme.colorScheme.secondary,
                ),
                title: Text(
                  'Log Out',
                  style: theme.textTheme.bodyLarge,
                ),
                onTap: () {
                  context.read<LoginCubit>().signOut();
                  Navigator.pushNamedAndRemoveUntil(
                      context, Routes.signIn, (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 60,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 82.h,
                      width: 233.w,
                      child: Text(
                        "Give your best food!",
                        style: theme.textTheme.headlineLarge,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _scaffoldKey.currentState!.openEndDrawer();
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 13, vertical: 14),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.dashboard,
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                subHeading(theme: theme, heading: "Popular Picks available"),
                SizedBox(
                  height: 10,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  child: Row(
                    children: List.generate(
                      popularPicks.length,
                      (index) => Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: foodCard(
                          theme: theme,
                          image_url: popularPicks[index]["image_url"],
                          foodName: popularPicks[index]["foodName"],
                          mrp: popularPicks[index]["mrp"],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                subHeading(theme: theme, heading: "Past Orders"),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector custom_Icons(
      {required ThemeData theme,
      required IconData iconData,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 14),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          iconData,
          color: theme.colorScheme.secondary,
        ),
      ),
    );
  }
}
