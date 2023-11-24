import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/login_cubit/login_cubit.dart';
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
  late String storeID;
  late String ID;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    initializeMenuItemData();

  }

  Future<void> initializeMenuItemData() async {
    ID = context.read<LoginCubit>().getEntryNo();
    storeID = await context.read<LoginCubit>().getStoreID(ID);

    context.read<MenuItems>().startListening(storeID);
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
                Row(
                  children: [
                    Text(
                      "The Menu Items for store ",
                      style: theme.textTheme.bodySmall,
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
                          return Text(snapshot.data.toString(), style: theme.textTheme.bodySmall,);
                        }
                      },
                    ),
                  ],
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
                          context.read<MenuItems>().deleteItem(menuItem.itemID!, "SMVDU101");
                        },
                        switchValue: menuItem.isavailable!,
                        onChanged: (newValue) {
                          context.read<MenuItems>().toggleAvailability(menuItem.itemID!, newValue, "SMVDU101");
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
