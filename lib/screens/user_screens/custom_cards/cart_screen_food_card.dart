import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/data/models/user_cart_model.dart';
import 'package:food_cafe/utils/constants.dart';

Dismissible cartFoodCard({
  required ThemeData theme,
  required BuildContext context,
  required CartModel item,
  required VoidCallback decreaseQuantity,
  required VoidCallback increaseQuantity,
  required void Function(DismissDirection)? onDismissed,
  required int itemQuantity,
}) {
  return Dismissible(
    onDismissed: onDismissed,
    key: Key(item.itemID!),
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
                      imageUrl: item.img_url ?? kPlaceHolderImageUrl,
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
                  SizedBox(
                    width: 120.w,
                    child: Text(
                      item.name!,
                      style: theme.textTheme.labelMedium,
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    item.itemID!,
                    style: theme.textTheme.bodySmall,
                  ),
                  Text(
                    "\₹ ${item.mrp}",
                    style: theme.textTheme.labelLarge,
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              InkWell(
                onTap: decreaseQuantity,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 26.h,
                  child: const AspectRatio(
                    aspectRatio: 1,
                    child: Icon(Icons.remove),
                  ),
                ),
              ),
              SizedBox(
                width: 16.w,
              ),
              Text(
                itemQuantity.toString(),
                style: theme.textTheme.labelMedium,
              ),
              SizedBox(
                width: 16.w,
              ),
              InkWell(
                onTap: increaseQuantity,
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 26.h,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Icon(
                      Icons.add,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}
