import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_cafe/cubits/user_role_cubits/cart_cubits/cart_local_state_cubit/cart_local_state_cubit.dart';
import 'package:food_cafe/cubits/user_role_cubits/home_menu_item_cubit/home_menu_item_cubit.dart';
import 'package:food_cafe/cubits/user_role_cubits/home_menu_item_cubit/home_menu_item_states.dart';
import 'package:food_cafe/cubits/common_cubits/login_cubit/login_cubit.dart';
import 'package:food_cafe/cubits/common_cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/data/models/user_cart_model.dart';
import 'package:food_cafe/data/services/connectivity_service.dart';
import 'package:food_cafe/data/services/notification_services.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:food_cafe/screens/store_screens/side_drawer_screens/add_menu_item_screens/store_add_menu_item_screen.dart';
import 'package:food_cafe/core/theme/theme.dart';
import 'package:food_cafe/screens/user_screens/feed_screens/user_role_side_drawer.dart';
import 'package:food_cafe/utils/login_state_check.dart';
import 'package:food_cafe/screens/user_screens/custom_cards/home_screen_food_card.dart';
import 'package:food_cafe/widgets/custom_circular_progress_indicator.dart';
import 'package:food_cafe/widgets/custom_error.dart';
import 'package:food_cafe/widgets/custom_internet_error.dart';
import 'package:food_cafe/widgets/custom_overlay_loader.dart';
import 'package:loader_overlay/loader_overlay.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeMenuItemsCubit _homeMenuItemsCubit;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final NotificationServices _notificationServices = NotificationServices();
  late String personID;
  int _currentpage = 0;
  final PageController _pageController = PageController(initialPage: 0);
  late Timer _timer;
  int pagenumber = 0;
  // static bool _initialized = false;
  late LoginCubit loginCubit;

  // void _initializeCart() async {
  //   //TODO: Create a Cubit to inialize Local State for only one time
  //   if (!_initialized) {
  //     await context
  //         .read<CartLocalState>()
  //         .initializefromFirebase(personID: personID);
  //     _initialized = true;
  //   }
  // }

  void _initializeNotifications() async {
    _notificationServices.requestNotificationPermission();
    _notificationServices.firebaseInit(context);
    _notificationServices.setupInteractMessage(context);
    // notificationServices.isTokenRefresh();
    // notificationServices.getDeviceToken().then((value) {
    //   log("This is the Device Token!!!");
    //   print(value);
    // });
  }

  void _initializeCubits() {
    loginCubit = BlocProvider.of<LoginCubit>(context);
    _homeMenuItemsCubit = BlocProvider.of<HomeMenuItemsCubit>(context);

    personID =
        checkLoginStateForUser(context: context, screenName: 'HomeScreen');
  }

  @override
  void initState() {
    super.initState();
    _initializeNotifications();

    _initializeCubits();
    // _initializeCart();

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
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;
    final ThemeData theme = themeMode == MyTheme.dark ? darkTheme : lightTheme;
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: UserRoleSideDrawer(
        personID: personID,
        onLogOut: () async {
          await loginCubit.signOut();
          if (context.mounted) {
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.signIn, (route) => false);
          }
        },
      ),
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: Column(
                  children: [
                    const SizedBox(
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
                            padding: const EdgeInsets.symmetric(
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
                    const SizedBox(
                      height: 20,
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
                    const SizedBox(
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
                      const SizedBox(
                        height: 5,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: List.generate(
                            categories.length,
                            (index) => Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: _buildCategoryCard(
                                  theme: theme,
                                  iconName: _categoryIconNames[index],
                                  categoryName: categories[index],
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, Routes.categoryScreen,
                                        arguments: categories[index]);
                                  }),
                            ),
                          ),
                        ),
                      ),
                    ]),
              ),
              const SizedBox(
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
                    const SizedBox(
                      height: 5,
                    ),
                    BlocBuilder<HomeMenuItemsCubit, HomeMenuItemsStates>(
                      builder: (context, state) {
                        if (state is HomeCardLoadingState) {
                          return const CustomCircularProgress();
                        } else if (state is HomeCardLoadedState &&
                            state.cards.isEmpty) {
                          return const Text(
                              'No Menu Items Available currently!');
                        } else if (state is HomeCardErrorState &&
                            state.error == 'internetError') {
                          return CustomInternetError(tryAgain: () {
                            _homeMenuItemsCubit.initiateFetch(
                                storeID: 'SMVDU101');
                          });
                        } else if (state is HomeCardErrorState) {
                          return CustomError(
                              errorMessage: state.error,
                              tryAgain: () {
                                _homeMenuItemsCubit.initiateFetch(
                                    storeID: 'SMVDU101');
                              });
                        }
                        return LayoutBuilder(
                          builder: (BuildContext context,
                              BoxConstraints constraints) {
                            return CustomScrollView(
                              primary: true,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
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
                                        onTap: () async {
                                          await checkConnectivity(
                                              context: context,
                                              onConnected: () {
                                                CartModel card = CartModel(
                                                  name:
                                                      state.cards[index].name!,
                                                  mrp: state.cards[index].mrp!,
                                                  itemID:
                                                      state.cards[index].itemID,
                                                  img_url: state
                                                      .cards[index].imageURL,
                                                  quantity: 1,
                                                );
                                                context
                                                    .read<CartLocalState>()
                                                    .addItemstoCart(
                                                        personID: personID,
                                                        item: card,
                                                        context: context);
                                              });

                                          if (context.mounted) {
                                            context.loaderOverlay.show();
                                            await Future.delayed(
                                                const Duration(seconds: 1));
                                          }

                                          if (context.mounted) {
                                            context.loaderOverlay.hide();
                                          }
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
                      },
                    ),
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
      padding: const EdgeInsets.only(right: 10),
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),

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

  final List<String> _categoryIconNames = [
    'appetizer',
    'maincourse',
    'desserts',
    'beverages',
    'sides',
    'specials',
  ];
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
