import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/user_role_cubits/cart_cubits/cart_local_state_cubit/cart_local_state_cubit.dart';
import 'package:food_cafe/cubits/user_role_cubits/food_category_cubit/food_category_cubit.dart';
import 'package:food_cafe/cubits/user_role_cubits/food_category_cubit/food_category_states.dart';
import 'package:food_cafe/data/models/user_cart_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/data/services/connectivity_service.dart';
import 'package:food_cafe/utils/login_state_check.dart';
import 'package:food_cafe/utils/theme_check.dart';
import 'package:food_cafe/widgets/custom_back_button.dart';
import 'package:food_cafe/screens/user_screens/custom_cards/home_screen_food_card.dart';
import 'package:food_cafe/widgets/custom_circular_progress_indicator.dart';
import 'package:food_cafe/widgets/custom_empty_error.dart';
import 'package:food_cafe/widgets/custom_error.dart';
import 'package:food_cafe/widgets/custom_internet_error.dart';

class CategoryScreen extends StatefulWidget {
  final String storeID;
  final String categoryName;
  const CategoryScreen(
      {Key? key, this.storeID = 'SMVDU101', required this.categoryName})
      : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late final String personID;
  late final FoodCategoryCubit _foodCategoryCubit;

  void _initializeCubits() {
    personID =
        checkLoginStateForUser(context: context, screenName: 'Category Screen');
    _foodCategoryCubit = BlocProvider.of(context);

    _foodCategoryCubit.initiateCategoryFetch(
        categoryName: widget.categoryName, storeID: widget.storeID);
  }

  @override
  void initState() {
    super.initState();
    _initializeCubits();
  }

  @override
  void dispose() {
    super.dispose();
    _foodCategoryCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = getTheme(context: context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customBackButton(context, theme),
                Text(
                  widget.categoryName,
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 20,
                ),
                BlocBuilder<FoodCategoryCubit, FoodCategoryState>(
                    builder: (context, state) {
                  if (state is FoodCategoryLoadingState ||
                      state is FoodCategoryInitialState) {
                    return const CustomCircularProgress();
                  } else if (state is FoodCategoryLoadedState &&
                      state.categoryItems.isEmpty) {
                    return const CustomEmptyError(
                        message: 'No Item Available for this Category!');
                  } else if (state is FoodCategoryErrorState &&
                      state.error == 'internetError') {
                    return CustomInternetError(tryAgain: () {
                      _foodCategoryCubit.initiateCategoryFetch(
                          categoryName: widget.categoryName,
                          storeID: widget.storeID);
                    });
                  } else if (state is FoodCategoryErrorState) {
                    return CustomError(
                        errorMessage: state.error,
                        tryAgain: () {
                          _foodCategoryCubit.initiateCategoryFetch(
                              categoryName: widget.categoryName,
                              storeID: widget.storeID);
                        });
                  }
                  return LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
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
                                  menuItem: state.categoryItems[index],
                                  onTap: () async {
                                    await checkConnectivity(
                                        context: context,
                                        onConnected: () {
                                          CartModel card = CartModel(
                                            name: state
                                                .categoryItems[index].name!,
                                            mrp:
                                                state.categoryItems[index].mrp!,
                                            itemID: state
                                                .categoryItems[index].itemID,
                                            img_url: state
                                                .categoryItems[index].imageURL,
                                            quantity: 1,
                                          );
                                          context
                                              .read<CartLocalState>()
                                              .addItemstoCart(
                                                  personID: personID,
                                                  item: card,
                                                  context: context);
                                        });
                                  },
                                );
                              },
                              childCount: state.categoryItems.length,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
