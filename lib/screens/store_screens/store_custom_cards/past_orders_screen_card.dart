import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/data/models/store_order_model.dart';
import 'package:food_cafe/screens/store_screens/side_drawer_screens/orders_screens/store_orders_screen.dart';
import 'package:food_cafe/utils/order_status.dart';
import 'package:intl/intl.dart';

GestureDetector pastOrdersCard({
  required ThemeData theme,
  required BuildContext context,
  required OrderModel pastOrders_Model,
  required VoidCallback onTap,
}) {
  String time = DateFormat('hh:mm a').format(pastOrders_Model.time!.toDate());
  String date = DateFormat('d MMM y').format(pastOrders_Model.time!.toDate());
  return GestureDetector(
    onTap: onTap,
    child: Card(
      elevation: 8,
      shadowColor: theme.colorScheme.secondary,
      color: theme.colorScheme.primary,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20.sp,
                      child: Icon(
                        Icons.person,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pastOrders_Model.customerName!,
                          style: theme.textTheme.titleSmall,
                          textAlign: TextAlign.right,
                        ),
                        Text(
                          pastOrders_Model.entryNo!,
                          style: theme.textTheme.bodySmall,
                          // textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      pastOrders_Model.isDineIn == true
                          ? "Dine-In"
                          : "Dine-Out",
                      style: theme.textTheme.titleSmall,
                      // textAlign: TextAlign.right,
                    ),
                    if (pastOrders_Model.isDineIn == false)
                      Text(
                        pastOrders_Model.hostelName!,
                        style: theme.textTheme.titleSmall,
                        // textAlign: TextAlign.right,
                      ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      "$date | $time",
                      style: theme.textTheme.bodySmall,
                      // textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Transaction ID: ",
                      style: theme.textTheme.labelMedium,
                      // textAlign: TextAlign.right,
                    ),
                    Text(
                      pastOrders_Model.trxID!,
                      style: theme.textTheme.bodyLarge,
                      // textAlign: TextAlign.right,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Order ID: ",
                      style: theme.textTheme.labelMedium,
                      // textAlign: TextAlign.right,
                    ),
                    Text(
                      pastOrders_Model.orderID!,
                      style: theme.textTheme.bodyLarge,
                      // textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ],
            ),
            Divider(
              thickness: 1,
              color: Colors.grey.shade600,
            ),
            Column(children: [
              ...List.generate(
                pastOrders_Model.orderItems!.length,
                (index) => foodRow(
                  theme: theme,
                  foodItem: pastOrders_Model.orderItems![index],
                ),
              ),
            ]),
            Divider(
              thickness: 1,
              color: Colors.grey.shade600,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "₹ ${pastOrders_Model.totalMRP}",
                  style: theme.textTheme.labelLarge,
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 2, color: Colors.green),
                  ),
                  child: Text(
                    "Paid",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'BentonSans_Bold',
                    ),
                    // textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "Order Status: ",
                  style: theme.textTheme.labelMedium,
                  // textAlign: TextAlign.right,
                ),
                Text(
                  pastOrders_Model.orderStatus == OrderStatus.prepared
                      ? "Completed"
                      : "Rejected",
                  style: theme.textTheme.bodyLarge!.copyWith(
                      color:
                          pastOrders_Model.orderStatus == OrderStatus.prepared
                              ? Colors.blueAccent
                              : Colors.red,
                      fontWeight: FontWeight.w900),
                  // textAlign: TextAlign.right,
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
