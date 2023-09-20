import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/data/models/store_OrderCard_Models.dart';

Container store_pastOrderCard({
  required ThemeData theme,
  required BuildContext context,
  required store_HomeScreenOrderCard order,
}) {
  return Container(
    margin: EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(20)),
    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 11.w),
    width: MediaQuery.of(context).size.width,
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 31,
                  child: Icon(
                    Icons.person,
                    color: theme.colorScheme.secondary,
                    size: 35.sp,
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
                        order.name!,
                        style: theme.textTheme.titleSmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      order.entryNo!,
                      style: theme.textTheme.bodySmall,
                    ),
                    Text(
                      "\₹ ${order.mrp}",
                      style: theme.textTheme.labelLarge,
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Type: ",
                      style: theme.textTheme.bodyMedium,
                    ),
                    Text(order.isDineIn! == true ? "Dine - In" : "Dine - Out", style: theme.textTheme.headlineSmall),
                  ],
                ),
                if(order.isDineIn == false)
                  Row(
                    children: [
                      Text(
                        "Hostel: ",
                        style: theme.textTheme.bodyMedium,
                      ),
                      Text(order.hostelName ?? "", style: theme.textTheme.headlineSmall),
                    ],
                  ),
                Row(
                  children: [
                    Text(
                      "Payment: ",
                      style: theme.textTheme.bodyMedium,
                    ),
                    Text(order.isCOD! == true ? "COD" : "Online", style: theme.textTheme.headlineSmall),
                  ],
                ),
              ],
            )
          ],
        ),
        Row(
          children: [
            Text(
              "Txn. Date & Time: ",
              style: theme.textTheme.bodyMedium,
            ),
            Text(
              "10/06/2023 10:19:26 AM",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
              ),
            ),
          ],
        )
      ],
    ),
  );
}


Dismissible store_MenuCard({
  required ThemeData theme,
  required BuildContext context,
  required void Function(DismissDirection)? onDismissed,
  required bool switchValue,
  required Function(bool) onChanged,
  required store_MenuItemsCard_Model menuItem
}) {
  return Dismissible(
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
      margin: EdgeInsets.only(bottom: 10),
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
                    child: Image.network(
                      menuItem.imageUrl!,
                      fit: BoxFit.cover,
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
                    "\₹ ${menuItem.mrp}",
                    style: theme.textTheme.labelLarge,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 20.h,
            width: 40.w,
            child: Switch(value: switchValue, onChanged: onChanged,
              activeTrackColor: Color.fromRGBO(108, 117, 125, 0.12),
              inactiveTrackColor: Color.fromRGBO(108, 117, 125, 0.12),
              inactiveThumbColor: theme.colorScheme.primary,
              activeColor: theme.colorScheme.secondary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    ),
  );
}
