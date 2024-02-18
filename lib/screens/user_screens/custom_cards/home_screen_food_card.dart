import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/data/models/user_menu_item_model.dart';
import 'package:food_cafe/utils/constants.dart';

CupertinoButton foodCard(
    {required ThemeData theme,
    required MenuItemModel menuItem,
    required VoidCallback onTap}) {
  return CupertinoButton(
    onPressed: onTap,
    padding: EdgeInsets.zero,
    child: Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10),
      // height: 184.h,
      width: 147.w,
      height: 202.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: menuItem.imageURL ?? kPlaceHolderImageUrl,
                  imageBuilder: (context, imageProvider) => Container(
                    height: 85.h,
                    margin: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 85.h,
                    margin: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                        image: NetworkImage(kPlaceHolderImageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  progressIndicatorBuilder: (context, url, downloadProgress) {
                    return Center(
                      child: CircularProgressIndicator(
                        value: downloadProgress.progress,
                      ),
                    );
                  },
                ),
                Text(
                  menuItem.name ?? "Null",
                  style: theme.textTheme.bodyLarge!
                      .copyWith(fontWeight: FontWeight.w900),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    menuItem.category ?? "Null",
                    style: theme.textTheme.bodyMedium,
                  ),
                  Text(
                    '₹ ${menuItem.mrp}/-',
                    style: theme.textTheme.labelLarge!
                        .copyWith(fontSize: 20.sp, height: 1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}


