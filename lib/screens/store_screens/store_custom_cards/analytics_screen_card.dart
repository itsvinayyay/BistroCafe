import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/data/models/store_product_analytics_model.dart';
import 'package:food_cafe/utils/constants.dart';

CupertinoButton storeAnalysisFoodCard(
    {required VoidCallback onTap,
    required ProductAnalysisModel productAnalysisModel,
    required ThemeData theme}) {
  return CupertinoButton(
    onPressed: () {},
    padding: EdgeInsets.zero,
    child: Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      // height: 184.h,
      width: 147,
      height: 202,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 85.h,
            // width: 96.w,
            margin: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: NetworkImage(
                      productAnalysisModel.imageUrl ?? kPlaceHolderImageUrl),
                  fit: BoxFit.cover,
                )),
          ),
          SizedBox(
            // width: 100.w,
            height: 33.h,
            child: Text(
              productAnalysisModel.itemName ?? "Null",
              style: theme.textTheme.titleSmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            productAnalysisModel.category ?? "Null",
            style: theme.textTheme.bodyMedium,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₹ ${productAnalysisModel.price}/-',
                style: theme.textTheme.labelLarge!
                    .copyWith(fontSize: 18.sp, height: 1),
              ),
              Text(
                productAnalysisModel.numbersSold.toString(),
                style: theme.textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w700, fontSize: 25.sp, height: 0.8),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}