import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


Stack foodCard(
    {required ThemeData theme,
      required String image_url,
      required String foodName,
      required int mrp,
      VoidCallback? onTap}) {
  return Stack(
    children: [
      Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          // height: 184.h,
          width: 147.w,
          height: 202.h,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Container(
                  height: 85.h,
                  // width: 96.w,
                  margin: EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: NetworkImage(image_url),
                        fit: BoxFit.cover,
                      )),
                ),
              ),
              // SizedBox(height: 17.h,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: SizedBox(
                  // width: 100.w,
                  height: 33.h,
                  child: Text(
                    foodName,
                    style: theme.textTheme.titleSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Text(
                  "₹ $mrp.00",
                  style: theme.textTheme.bodySmall,
                ),
              ),

              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Material(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                    ),
                    color: Colors.white,
                    child: InkWell(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                      ),
                      splashColor: theme.colorScheme.primary,
                      // hoverColor: theme.colorScheme.primary,
                      // focusColor: theme.colorScheme.primary,
                      highlightColor: theme.colorScheme.primary,
                      canRequestFocus: false,
                      onTap: onTap,
                      child: Container(
                        height: 45.h,
                        width: 45.w,
                        // decoration: BoxDecoration(
                        //   // color: Colors.white.withOpacity(0.5),
                        //   borderRadius: BorderRadius.only(
                        //     bottomRight: Radius.circular(10),
                        //   ),
                        // ),
                        child: Icon(
                          Icons.add,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          )),
    ],
  );}