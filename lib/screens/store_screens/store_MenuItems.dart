import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/store_menuitem_cubit/menuItem_cubit.dart';
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
  String storeNumber = "101";
  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    context.read<MenuItems>().startListening(storeNumber);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    context.read<MenuItems>().close();
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
                SizedBox(
                  width: 239.w,
                  child: Text(
                    "The Menu Items for store SMVDU101",
                    style: theme.textTheme.bodySmall,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                BlocBuilder<MenuItems, List<store_MenuItemsCard_Model>>(
                    builder: (context, state) {
                  return ListView.builder(physics: NeverScrollableScrollPhysics(), shrinkWrap: true,itemCount: state.length,itemBuilder: (context, index) {
                    final menuItem = state[index];
                    return store_MenuCard(
                        theme: theme,
                        context: context,
                        onDismissed: (direction) {
                          context.read<MenuItems>().deleteItem(menuItem.itemID!, storeNumber);
                        },
                        switchValue: menuItem.isavailable!,
                        onChanged: (newValue) {
                          context.read<MenuItems>().toggleAvailability(menuItem.itemID!, newValue, storeNumber);
                        },
                      menuItem: menuItem,
                    );
                  });
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
