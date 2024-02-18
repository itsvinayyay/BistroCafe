import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_menuitem_cubit/menu_item_cubit.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_menuitem_cubit/menu_item_states.dart';

import 'package:food_cafe/cubits/common_cubits/theme_cubit/theme_cubit.dart';

import 'package:food_cafe/core/theme/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/data/models/store_menu_item_model.dart';
import 'package:food_cafe/data/services/connectivity_service.dart';
import 'package:food_cafe/screens/store_screens/store_custom_cards/menu_item_screen_card.dart';
import 'package:food_cafe/utils/login_state_check.dart';
import 'package:food_cafe/widgets/custom_back_button.dart';
import 'package:food_cafe/widgets/custom_circular_progress_indicator.dart';
import 'package:food_cafe/widgets/custom_error.dart';
import 'package:food_cafe/widgets/custom_internet_error.dart';


class StoreMenuItemsScreen extends StatefulWidget {
  const StoreMenuItemsScreen({super.key});

  @override
  State<StoreMenuItemsScreen> createState() => _StoreMenuItemsScreenState();
}

class _StoreMenuItemsScreenState extends State<StoreMenuItemsScreen> {
  late String storeID;
  late String personID;
  late MenuItemCubit menuItemCubit;

  Future<void> _initializeCubits() async {
    MapEntry<String, String> storeInfo = checkLoginStateForCafeOwner(
        context: context, screenName: 'Store Menu Items Screen');
    personID = storeInfo.key;
    storeID = storeInfo.value;
    menuItemCubit = BlocProvider.of<MenuItemCubit>(context);
    menuItemCubit.startListening(storeID);
  }

  @override
  void initState() {
    super.initState();
    _initializeCubits();
  }

  @override
  void dispose() {
    super.dispose();
    menuItemCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;
    final ThemeData theme = themeMode == MyTheme.dark ? darkTheme : lightTheme;
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
                  "Menu Items",
                  style: theme.textTheme.titleLarge
                ),
                
                BlocBuilder<MenuItemCubit, MenuItemStates>(
                    builder: (context, state) {
                  if (state is MenuItemLoadingState) {
                    return const CustomCircularProgress();
                  } else if (state is MenuItemErrorState &&
                      state.error == 'internetError') {
                    return CustomInternetError(tryAgain: () {
                      menuItemCubit.startListening(storeID);
                    });
                  } else if (state is MenuItemErrorState) {
                    return CustomError(
                        errorMessage: state.error,
                        tryAgain: () {
                          menuItemCubit.startListening(storeID);
                        });
                  }
                  return ListView.builder(
                    itemCount: state.menuItems.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      StoreMenuItemModel menuItem =
                          state.menuItems[index];
                      return storeMenuCard(
                          onTap: () async {
                            await checkConnectivity(
                                context: context,
                                onConnected: () {
                                  Navigator.pushNamed(context,
                                      Routes.store_ModifyMenuItemScreen,
                                      arguments: menuItem);
                                });
                          },
                          theme: theme,
                          context: context,
                          onDismissed: (direction) async {
                            await checkConnectivity(
                                context: context,
                                onConnected: () {
                                  menuItemCubit.deleteItem(
                                      itemID: menuItem.itemID!,
                                      storeID: storeID);
                                });
                          },
                          switchValue: menuItem.isavailable!,
                          onChanged: (newValue) async {
                            await checkConnectivity(
                                context: context,
                                onConnected: () {
                                  menuItemCubit.toggleAvailability(
                                      itemID: menuItem.itemID!,
                                      newAvailability: newValue,
                                      storeID: storeID);
                                });
                          },
                          menuItem: menuItem);
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
