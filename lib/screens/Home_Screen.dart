import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_cafe/cubits/cart_cubit/cartLocalState_cubit.dart';
import 'package:food_cafe/cubits/home_cubit/homescreen_cubit.dart';
import 'package:food_cafe/cubits/home_cubit/homescreen_state.dart';
import 'package:food_cafe/cubits/login_cubit/login_cubit.dart';
import 'package:food_cafe/cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/data/models/CartScreen_FoodCard.dart';
import 'package:food_cafe/data/services/notification_services.dart';
import 'package:food_cafe/data/services/notification_services.dart';
import 'package:food_cafe/routes/named_routes.dart';
import 'package:food_cafe/theme.dart';
import 'package:food_cafe/widgets/custom_FoodCard.dart';

import '../data/services/notification_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  NotificationServices notificationServices = NotificationServices();
  late String entryNo;
  int _currentpage = 0;
  final PageController _pageController = PageController(initialPage: 0);
  late Timer _timer;
  int pagenumber = 0;
  static bool _initialized = false;

  @override
  void initState() {
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    // notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value) {
      print("This is the Device Token!!!");
      print(value);
    });



    entryNo = context.read<LoginCubit>().getEntryNo();
    if(!_initialized){

      context.read<CartLocalState>().initializefromFirebase(entryNo);
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
    print(entryNo);
    final themeMode = context.watch<ThemeCubit>().state;
    final ThemeData theme = themeMode == MyTheme.dark ? darkTheme : lightTheme;
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: ClipRRect(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(40), bottomLeft: Radius.circular(40)),
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
                    SizedBox(height: 5,),

                    Text('Delightful Dining, Every Bite a Delight!', style: theme.textTheme.titleSmall,),
                    SizedBox(height: 10,),
                    Text(entryNo, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.sp, color: theme.colorScheme.primary, fontFamily: 'BentonSans_Bold'))
                  ],
                ),
              ),
              ListTile(
                horizontalTitleGap: 0,
                leading: Icon(
                  Icons.notifications,
                  color: theme.colorScheme.secondary,
                ),
                title: Text('Notifications', style: theme.textTheme.bodyLarge,),
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
                title: Text('Settings', style: theme.textTheme.bodyLarge,),
                onTap: () {
                  // Add your logic for when this item is tapped.
                },
              ),
              ListTile(
                horizontalTitleGap: 0,
                leading: Icon(
                  Icons.info_outline_rounded,
                  color: theme.colorScheme.secondary,
                ),
                title: Text('About', style: theme.textTheme.bodyLarge,),
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
                title: Text('Log Out', style: theme.textTheme.bodyLarge,),
                onTap: () {
                  context.read<LoginCubit>().signOut();
                  Navigator.pushNamedAndRemoveUntil(context, Routes.signIn, (route) => false);
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
                        "Find Your Favorite Food",
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
                // SizedBox(
                //   height: 18.h,
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     GestureDetector(
                //       onTap: (){
                //         Navigator.pushNamed(context, Routes.searchScreen);
                //       },
                //       child: Container(
                //         width: 267.w,
                //         padding: EdgeInsets.symmetric(
                //             horizontal: 18.w, vertical: 19.h),
                //         decoration: BoxDecoration(
                //           color: theme.colorScheme.primary,
                //           borderRadius: BorderRadius.circular(20),
                //         ),
                //         child: Row(
                //           children: [
                //             SvgPicture.asset("assets/icons/search.svg"),
                //             SizedBox(
                //               width: 19.w,
                //             ),
                //             Text(
                //               "What do you want to order?",
                //               style: theme.textTheme.bodySmall,
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //     GestureDetector(
                //       onTap: () => Navigator.pop(context),
                //       child: Container(
                //         padding: EdgeInsets.symmetric(
                //             horizontal: 13, vertical: 19.h),
                //         decoration: BoxDecoration(
                //           color: theme.colorScheme.primary,
                //           borderRadius: BorderRadius.circular(15),
                //         ),
                //         child: Icon(
                //           Icons.settings,
                //           color: theme.colorScheme.secondary,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                SizedBox(
                  height: 20,
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
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Popular Picks",
                  style: theme.textTheme.titleSmall,
                ),
                SizedBox(
                  height: 20,
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
                Text(
                  "Menu Items",
                  style: theme.textTheme.titleMedium,
                ),
                SizedBox(
                  height: 15,
                ),
                BlocConsumer<HomeCardCubit, HomeCardState>(builder: (context, state){
                  if(state is HomeCardLoadingState){
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                  }
                  else if(state is HomeCardLoadedState){
                    return LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        return  CustomScrollView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          slivers: [
                            SliverGrid(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 20.0,
                                childAspectRatio: 147.w/202.h,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                  return foodCard(
                                    theme: theme,
                                    image_url: state.cards[index].imageURL!,
                                    foodName: state.cards[index].name!,
                                    mrp: state.cards[index].mrp!,
                                    onTap: (){
                                      Cart_FoodCard_Model card = Cart_FoodCard_Model(
                                        name: state.cards[index].name!,
                                        mrp: state.cards[index].mrp!,
                                        itemID: state.cards[index].itemID,
                                        quantity: 1,
                                      );
                                      context.read<CartLocalState>().addItemstoCart(entryNo, card, context);
                                    }
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
                }, listener: (context, state){
                  print(state.toString());
                })

              ],
            ),
          ),
        ),
      ),
    );
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
