import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/data/models/HomeScreen_FoodCard.dart';
import 'package:food_cafe/data/models/store_analytics_model.dart';
import 'package:food_cafe/data/models/store_product_analytics_model.dart';

// Stack foodCard(
//     {required ThemeData theme,
//     required String image_url,
//     required String foodName,
//     required int mrp,
//     VoidCallback? onTap}) {
//   return Stack(
//     children: [
//       Container(
//           decoration: BoxDecoration(
//             color: theme.colorScheme.primary,
//             borderRadius: BorderRadius.circular(20),
//           ),
//           // height: 184.h,
//           width: 147,
//           height: 202,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(
//                 height: 10,
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 15.w),
//                 child: Container(
//                   height: 85.h,
//                   // width: 96.w,
//                   margin: EdgeInsets.only(bottom: 5),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                       image: DecorationImage(
//                         image: NetworkImage(image_url),
//                         fit: BoxFit.cover,
//                       )),
//                 ),
//               ),
//               // SizedBox(height: 17.h,),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 15.w),
//                 child: SizedBox(
//                   // width: 100.w,
//                   height: 33.h,
//                   child: Text(
//                     foodName,
//                     style: theme.textTheme.titleSmall,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 15.w),
//                 child: Text(
//                   "₹ $mrp.00",
//                   style: theme.textTheme.bodySmall,
//                 ),
//               ),

//               Expanded(
//                 child: Align(
//                   alignment: Alignment.bottomRight,
//                   child: Material(
//                     borderRadius: BorderRadius.only(
//                       bottomRight: Radius.circular(10),
//                     ),
//                     color: Colors.white,
//                     child: InkWell(
//                       borderRadius: BorderRadius.only(
//                         bottomRight: Radius.circular(10),
//                       ),
//                       splashColor: theme.colorScheme.primary,
//                       // hoverColor: theme.colorScheme.primary,
//                       // focusColor: theme.colorScheme.primary,
//                       highlightColor: theme.colorScheme.primary,
//                       canRequestFocus: false,
//                       onTap: onTap,
//                       child: Container(
//                         height: 45.h,
//                         width: 45.w,
//                         // decoration: BoxDecoration(
//                         //   // color: Colors.white.withOpacity(0.5),
//                         //   borderRadius: BorderRadius.only(
//                         //     bottomRight: Radius.circular(10),
//                         //   ),
//                         // ),
//                         child: Icon(
//                           Icons.add,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           )),
//     ],
//   );
// }

CupertinoButton foodCard({
  required ThemeData theme,
  required MenuItemModel menuItem,
  required VoidCallback onTap

}) {
  return CupertinoButton(
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
                Container(
                  height: 85.h,
                  // width: 96.w,
                  margin: EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: NetworkImage(menuItem.imageURL ??
                            "https://cdn3.vectorstock.com/i/1000x1000/35/52/placeholder-rgb-color-icon-vector-32173552.jpg"),
                        fit: BoxFit.cover,
                      )),
                ),
                
                Text(
                  menuItem.name ?? "Null",
                  style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w900),
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
    onPressed: onTap,
    padding: EdgeInsets.zero,
  );
}

CupertinoButton store_FoodCard(
    {required VoidCallback onTap,
    required ProductAnalysisModel productAnalysisModel,
    required ThemeData theme}) {
  return CupertinoButton(
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
          SizedBox(
            height: 10,
          ),
          Container(
            height: 85.h,
            // width: 96.w,
            margin: EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: NetworkImage(productAnalysisModel.imageUrl ??
                      "https://cdn3.vectorstock.com/i/1000x1000/35/52/placeholder-rgb-color-icon-vector-32173552.jpg"),
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
    onPressed: () {},
    padding: EdgeInsets.zero,
  );
}
