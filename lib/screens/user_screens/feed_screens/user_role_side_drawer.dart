import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/core/routes/named_routes.dart';
import 'package:food_cafe/utils/theme_check.dart';

class UserRoleSideDrawer extends StatelessWidget {
  final String personID;
  final VoidCallback onLogOut;
  const UserRoleSideDrawer(
      {super.key, required this.personID, required this.onLogOut});

  @override
  Widget build(BuildContext context) {
     ThemeData theme = getTheme(context: context);
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40), bottomLeft: Radius.circular(40)),
      child: Drawer(
        backgroundColor: theme.colorScheme.primary,
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                    Text(
                      'Delightful Dining, Every Bite a Delight!',
                      style: theme.textTheme.titleSmall,
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
              flex: 8,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildSDTiles(
                      theme: theme,
                      context: context,
                      title: "Profile",
                      iconData: Icons.person,
                      onTap: () {
                        Navigator.pushNamed(context, Routes.profileScreen);
                      }),
                  _buildSDTiles(
                      theme: theme,
                      context: context,
                      title: "Order History",
                      iconData: Icons.history_rounded,
                      onTap: () {
                        Navigator.pushNamed(context, Routes.orderHistoryScreen);
                      }),
                  _buildSDTiles(
                      theme: theme,
                      context: context,
                      title: "Settings",
                      iconData: Icons.settings,
                      onTap: () {
                        Navigator.pushNamed(context, Routes.settingsScreen);
                      }),
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
                      onTap: onLogOut),
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
