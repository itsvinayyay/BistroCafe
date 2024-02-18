import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/data/models/store_menu_item_model.dart';

import 'package:food_cafe/utils/constants.dart';

CupertinoButton storeMenuCard(
    {required ThemeData theme,
    required BuildContext context,
    required void Function(DismissDirection)? onDismissed,
    required bool switchValue,
    required Function(bool) onChanged,
    required StoreMenuItemModel menuItem,
    required VoidCallback onTap}) {
  return CupertinoButton(
    padding: EdgeInsets.zero,
    onPressed: onTap,
    child: Dismissible(
      onDismissed: onDismissed,
      key: Key(menuItem.itemID.toString()),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 15.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.secondary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          Icons.restore_from_trash,
          color: Colors.white,
          size: 30.sp,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 11.w),
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 62.h,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: menuItem.imageUrl ?? kPlaceHolderImageUrl,
                        //TODO: Configure this error widget!
                        errorWidget: (context, url, error) => Container(
                          height: 85.h,
                          margin: const EdgeInsets.only(bottom: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(Icons.error),
                        ),
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) {
                          return Center(
                            child: CircularProgressIndicator(
                              value: downloadProgress.progress,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      menuItem.itemName!,
                      style: theme.textTheme.labelMedium,
                    ),
                    Text(
                      menuItem.itemID!,
                      style: theme.textTheme.bodySmall,
                    ),
                    Text(
                      "₹ ${menuItem.mrp}",
                      style: theme.textTheme.labelLarge,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20.h,
              width: 40.w,
              child: Switch(
                value: switchValue,
                onChanged: onChanged,
                activeTrackColor: const Color.fromRGBO(108, 117, 125, 0.12),
                inactiveTrackColor: const Color.fromRGBO(108, 117, 125, 0.12),
                inactiveThumbColor: theme.colorScheme.primary,
                activeColor: theme.colorScheme.secondary,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
