import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/core/routes/named_routes.dart';

import 'package:food_cafe/utils/theme_check.dart';

class CafeOwnerRoleSideDrawer extends StatelessWidget {
  final String storeID;
  final VoidCallback onLogOut;
  const CafeOwnerRoleSideDrawer(
      {super.key, required this.storeID, required this.onLogOut});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = getTheme(context: context);
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40), bottomLeft: Radius.circular(40)),
      child: Drawer(
        backgroundColor: theme.colorScheme.primary,
        
        
        child: Column(
          children: <Widget>[
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
                      radius: 30.sp,
                      child: Icon(
                        Icons.person,
                        size: 40.sp,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Delightful Dining, Every Bite a Delight!',
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      storeID,
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
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildSDTiles(
                      theme: theme,
                      title: 'Profile',
                      icon: Icons.person,
                      onTap: () {
                        Navigator.pushNamed(
                            context, Routes.store_profileScreen);
                      }),
                  _buildSDTiles(
                      theme: theme,
                      title: 'Settings',
                      icon: Icons.settings,
                      onTap: () {
                        Navigator.pushNamed(
                            context, Routes.store_SettingsScreen);
                      }),
                  _buildSDTiles(
                      theme: theme,
                      title: 'Menu Items',
                      icon: Icons.menu_book,
                      onTap: () {
                        Navigator.pushNamed(context, Routes.store_menuItems);
                      }),
                  _buildSDTiles(
                      theme: theme,
                      title: 'Your Orders',
                      icon: Icons.receipt_long,
                      onTap: () {
                        Navigator.pushNamed(context, Routes.store_OrdersScreen);
                      }),
                  _buildSDTiles(
                      theme: theme,
                      title: 'Add Menu Items',
                      icon: Icons.add_card_rounded,
                      onTap: () {
                        Navigator.pushNamed(
                            context, Routes.store_addItemsScreen);
                      }),
                  
                  _buildSDTiles(
                      theme: theme,
                      title: 'Log Out',
                      icon: Icons.logout,
                      onTap: onLogOut)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListTile _buildSDTiles(
      {required ThemeData theme,
      required String title,
      required IconData icon,
      required VoidCallback onTap}) {
    return ListTile(
        horizontalTitleGap: 10,
        leading: Icon(
          icon,
          color: theme.colorScheme.secondary,
        ),
        title: Text(
          title,
          style: theme.textTheme.bodyLarge,
        ),
        onTap: onTap);
  }
}
