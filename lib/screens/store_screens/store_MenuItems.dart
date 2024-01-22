import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/login_cubit/login_cubit.dart';
import 'package:food_cafe/cubits/login_cubit/login_state.dart';
import 'package:food_cafe/cubits/store_menuitem_cubit/menuItem_cubit.dart';
import 'package:food_cafe/cubits/store_menuitem_cubit/menuItem_states.dart';
import 'package:food_cafe/cubits/theme_cubit/theme_cubit.dart';
import 'package:food_cafe/data/models/store_OrderCard_Models.dart';
import 'package:food_cafe/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/widgets/store_customCards.dart';

class store_MenuItems extends StatefulWidget {
  const store_MenuItems({Key? key}) : super(key: key);

  @override
  State<store_MenuItems> createState() => _store_MenuItemsState();
}

class _store_MenuItemsState extends State<store_MenuItems> {
  late String storeID;
  late String personID;
  late MenuItemCubit menuItemCubit;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    initializeMenuItemData();
  }

  Future<void> initializeMenuItemData() async {
    final state = context.read<LoginCubit>().state;
    if (state is CafeLoginLoadedState) {
      personID = state.personID;
      storeID = state.storeID;
    } else {
      log("Some State Error Occured in Menu Items Screen");
      personID = "error";
      storeID = "error";
    }
    menuItemCubit = BlocProvider.of<MenuItemCubit>(context);
    menuItemCubit.startListening(storeID);
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 25,
                ),
                SizedBox(
                  height: 82.h,
                  width: 233.w,
                  child: Text(
                    "Your available Menu Items!",
                    style: theme.textTheme.headlineLarge,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "The Menu Items for store $storeID",
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                BlocBuilder<MenuItemCubit, MenuItemStates>(
                    builder: (context, state) {
                  if (state is MenuItemLoadingState) {
                    return Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  } else if (state is MenuItemErrorState) {
                    return Center(
                      child: Text(state.error),
                    );
                  }
                  return ListView.builder(
                    itemCount: state.menuItems.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      store_MenuItemsCard_Model menuItem =
                          state.menuItems[index];
                      return store_MenuCard(
                          theme: theme,
                          context: context,
                          onDismissed: (direction) {
                            menuItemCubit.deleteItem(
                                itemID: menuItem.itemID!, storeID: storeID);
                          },
                          switchValue: menuItem.isavailable!,
                          onChanged: (newValue) {
                            menuItemCubit.toggleAvailability(
                                itemID: menuItem.itemID!,
                                newAvailability: newValue,
                                storeID: storeID);
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
