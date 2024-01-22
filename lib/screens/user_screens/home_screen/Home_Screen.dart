import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:food_cafe/cubits/cart_cubit/cartLocalState_cubit.dart';
import 'package:food_cafe/cubits/home_cubit/homescreen_cubit.dart';
import 'package:food_cafe/cubits/home_cubit/homescreen_state.dart';
import 'package:food_cafe/cubits/login_cubit/login_cubit.dart';
import 'package:food_cafe/cubits/login_cubit/login_state.dart';
import 'package:food_cafe/cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/data/models/CartScreen_FoodCard.dart';
import 'package:food_cafe/data/services/notification_services.dart';

import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:food_cafe/screens/store_screens/store_AddMenuItems.dart';
import 'package:food_cafe/theme.dart';
import 'package:food_cafe/widgets/custom_FoodCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeScreenCubit homeScreenCubit;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  NotificationServices notificationServices = NotificationServices();
  late String personID;
  int _currentpage = 0;
  final PageController _pageController = PageController(initialPage: 0);
  late Timer _timer;
  int pagenumber = 0;
  static bool _initialized = false;
  late LoginCubit loginCubit;

  @override
  void initState() {
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    // notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value) {
      log("This is the Device Token!!!");
      print(value);
    });
    loginCubit = BlocProvider.of<LoginCubit>(context);
    homeScreenCubit = BlocProvider.of<HomeScreenCubit>(context);
    homeScreenCubit.initiateFetch(storeID: 'SMVDU101');
    final state = loginCubit.state;
    if (state is LoginLoggedInState) {
      personID = state.personID;
      log("Got the Person ID $personID");
    } else {
      log("Some State Error Occured in Home Screen");
      personID = "error";
    }
    if (!_initialized) {
      context.read<CartLocalState>().initializefromFirebase(personID);
      _initialized = true;
    }
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
    log(personID);
    final themeMode = context.watch<ThemeCubit>().state;
    final ThemeData theme = themeMode == MyTheme.dark ? darkTheme : lightTheme;
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40), bottomLeft: Radius.circular(40)),
        child: Drawer(
          backgroundColor: theme.colorScheme.primary,
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: DrawerHeader(
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
                        height: 10.h,
                      ),
                      Text(
                        'Delightful Dining, Every Bite a Delight!',
                        style: theme.textTheme.titleSmall,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        personID,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20.sp,
                            color: theme.colorScheme.primary,
                            fontFamily: 'BentonSans_Bold'),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildSDTiles(
                        theme: theme,
                        context: context,
                        title: "Notifications",
                        iconData: Icons.notifications,
                        onTap: () {
                          Navigator.pushNamed(
                              context, Routes.notificationsScreen);
                        }),
                    _buildSDTiles(
                        theme: theme,
                        context: context,
                        title: "Order History",
                        iconData: Icons.history_rounded,
                        onTap: () {
                          Navigator.pushNamed(
                              context, Routes.orderHistoryScreen);
                        }),
                    _buildSDTiles(
                        theme: theme,
                        context: context,
                        title: "Profile",
                        iconData: Icons.person,
                        onTap: () {}),
                    _buildSDTiles(
                        theme: theme,
                        context: context,
                        title: "Settings",
                        iconData: Icons.settings,
                        onTap: () {}),
                    _buildSDTiles(
                        theme: theme,
                        context: context,
                        title: "About",
                        iconData: Icons.info_outline_rounded,
                        onTap: () {}),
                    _buildSDTiles(
                        theme: theme,
                        context: context,
                        title: "Log Out",
                        iconData: Icons.logout,
                        onTap: () async {
                          await loginCubit.signOut();
                          Navigator.pushNamedAndRemoveUntil(
                              context, Routes.signIn, (route) => false);
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 82.h,
                          width: 233.w,
                          child: Text(
                            "Find Your Favorite Food",
                            style: theme.textTheme.headlineLarge,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _scaffoldKey.currentState!.openEndDrawer();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 13, vertical: 14),
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
                    SizedBox(
                      height: 160.h,
                      child: PageView(
                        physics: BouncingScrollPhysics(),
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
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 15.w, top: 10, bottom: 10),
                color: theme.colorScheme.secondary,
                width: MediaQuery.of(context).size.width,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Categories",
                        style: theme.textTheme.titleMedium,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        child: Row(
                          children: List.generate(
                            categories.length,
                            (index) => Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: _buildCategoryCard(
                                  theme: theme,
                                  iconName: _categoryIconNames[index],
                                  categoryName: categories[index],
                                  onPressed: () {}),
                            ),
                          ),
                        ),
                      ),
                    ]),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Menu Items",
                      style: theme.textTheme.titleMedium,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    BlocConsumer<HomeScreenCubit, HomeScreenStates>(
                        builder: (context, state) {
                      if (state is HomeCardLoadingState) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                      } else if (state is HomeCardLoadedState) {
                        return LayoutBuilder(
                          builder: (BuildContext context,
                              BoxConstraints constraints) {
                            return CustomScrollView(
                              primary: true,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              slivers: [
                                SliverGrid(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 0.0,
                                    mainAxisSpacing: 0.0,
                                    childAspectRatio: 147.w / 180.h,
                                  ),
                                  delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      return foodCard(
                                        theme: theme,
                                        menuItem: state.cards[index],
                                        onTap: () {
                                          Cart_FoodCard_Model card =
                                              Cart_FoodCard_Model(
                                            name: state.cards[index].name!,
                                            mrp: state.cards[index].mrp!,
                                            itemID: state.cards[index].itemID,
                                            img_url:
                                                state.cards[index].imageURL,
                                            quantity: 1,
                                          );
                                          context
                                              .read<CartLocalState>()
                                              .addItemstoCart(
                                                  personID, card, context);
                                        },
                                      );
                                    },
                                    childCount: state.cards.length,
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }
                      return Center(
                        child: Text("Error here!"),
                      );
                    }, listener: (context, state) {
                      print(state.toString());
                    }),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  CupertinoButton _buildCategoryCard(
      {required ThemeData theme,
      required String iconName,
      required String categoryName,
      required VoidCallback onPressed}) {
    return CupertinoButton(
      padding: EdgeInsets.only(right: 10),
      pressedOpacity: 0.7,
      onPressed: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        // height: 184.h,
        width: 147,
        height: 202,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 8,
              child: SvgPicture.asset(
                'assets/icons/$iconName.svg',
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                categoryName,
                style:
                    theme.textTheme.labelLarge!.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _categoryIconNames = [
    'appetizer',
    'maincourse',
    'desserts',
    'beverages',
    'sides',
    'specials',
  ];

  ListTile _buildSDTiles(
      {required ThemeData theme,
      required BuildContext context,
      required String title,
      required IconData iconData,
      required VoidCallback onTap}) {
    return ListTile(
        horizontalTitleGap: 10,
        leading: Icon(
          iconData,
          color: theme.colorScheme.secondary,
        ),
        title: Text(
          title,
          style: theme.textTheme.bodyLarge,
        ),
        onTap: onTap);
  }
}

Container homescreenBanner(
    {required BuildContext context,
    required ThemeData theme,
    required String imageURL,
    required String title,
    required String details}) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
    height: 150.h,
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      image: DecorationImage(
        image: NetworkImage(
          imageURL,
        ),
        fit: BoxFit.cover,
        opacity: 0.50,
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 180.w,
          // height: 44.h,
          child: Text(
            title,
            style: theme.textTheme.headlineMedium,
          ),
        ),
        SizedBox(
          width: 180.w,
          // height: 44.h,
          child: Text(
            details,
            style: theme.textTheme.labelSmall,
          ),
        ),
      ],
    ),
  );
}

List popularPicks = [
  {
    "image_url":
        "https://www.vegrecipesofindia.com/wp-content/uploads/2022/12/garlic-naan-3.jpg",
    "foodName": "Paneer Naan",
    "mrp": 60,
  },
  {
    "image_url":
        "https://www.chilitochoc.com/wp-content/uploads/2021/03/Desi-Chow-Mein-2.jpg",
    "foodName": "Chowmein",
    "mrp": 70,
  },
  {
    "image_url": "https://static.toiimg.com/photo/61050397.cms",
    "foodName": "Samose",
    "mrp": 50,
  },
];

List banners = [
  {
    "image_url":
        "https://expertphotography.b-cdn.net/wp-content/uploads/2020/06/dark-food-photography-dessert-still-life-1.jpg",
    "title": "Special Deal for August",
    "details": "This August Savor the food of love!",
  },
  {
    "image_url":
        "https://i0.wp.com/digital-photography-school.com/wp-content/uploads/2018/01/Lentil-Soup_D-Kopcok.jpg?ssl=1",
    "title": "Never Ending Prices??",
    "details": "This August Savor the food of love!",
  },
  {
    "image_url":
        "https://images.pexels.com/photos/6089654/pexels-photo-6089654.jpeg?cs=srgb&dl=pexels-shameel-mukkath-6089654.jpg&fm=jpg",
    "title": "Special Deal for August",
    "details": "This August Savor the food of love!",
  },
];
