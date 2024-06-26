import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/data/models/store_order_model.dart';
import 'package:food_cafe/screens/store_screens/side_drawer_screens/orders_screens/store_orders_screen.dart';
import 'package:intl/intl.dart';

Card currentOrdersCard({
  required ThemeData theme,
  required BuildContext context,
  required OrderModel currentOrders_Model,
  required VoidCallback prepared,
}) {
  String time =
      DateFormat('hh:mm a').format(currentOrders_Model.time!.toDate());
  String date =
      DateFormat('d MMM y').format(currentOrders_Model.time!.toDate());
  return Card(
    elevation: 8,
    shadowColor: theme.colorScheme.secondary,
    color: theme.colorScheme.primary,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                    currentOrders_Model.customerName!,
                    style: theme.textTheme.titleSmall,
                    textAlign: TextAlign.right,
                  ),
                  Text(
                    currentOrders_Model.entryNo!,
                    style: theme.textTheme.bodySmall,
                    // textAlign: TextAlign.right,
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Type: ",
                    style: theme.textTheme.labelMedium,
                    // textAlign: TextAlign.right,
                  ),
                  Text(
                    currentOrders_Model.isDineIn == true
                        ? "Dine-In"
                        : "Dine-Out",
                    style: theme.textTheme.bodyLarge,
                    // textAlign: TextAlign.right,
                  ),
                ],
              ),
              if (currentOrders_Model.isDineIn == false)
                Row(
                  children: [
                    Text(
                      "Hostel Name: ",
                      style: theme.textTheme.labelMedium,
                      // textAlign: TextAlign.right,
                    ),
                    Text(
                      currentOrders_Model.hostelName!,
                      style: theme.textTheme.bodyLarge,
                      // textAlign: TextAlign.right,
                    ),
                  ],
                ),
              Row(
                children: [
                  Text(
                    "Ordered on: ",
                    style: theme.textTheme.labelMedium,
                    // textAlign: TextAlign.right,
                  ),
                  Text(
                    date,
                    style: theme.textTheme.bodyLarge,
                    // textAlign: TextAlign.right,
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Time: ",
                    style: theme.textTheme.labelMedium,
                    // textAlign: TextAlign.right,
                  ),
                  Text(
                    time,
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
              currentOrders_Model.orderItems!.length,
              (index) => foodRow(
                theme: theme,
                foodItem: currentOrders_Model.orderItems![index],
              ),
            ),
          ]),
          Divider(
            thickness: 1,
            color: Colors.grey.shade600,
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
                    currentOrders_Model.trxID!,
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
                    currentOrders_Model.orderID!,
                    style: theme.textTheme.bodyLarge,
                    // textAlign: TextAlign.right,
                  ),
                ],
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "₹ ${currentOrders_Model.totalMRP}",
                    style: theme.textTheme.labelLarge,
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          width: 2,
                          color: currentOrders_Model.isCash == true
                              ? Colors.blue
                              : Colors.red),
                    ),
                    child: Text(
                      currentOrders_Model.isCash == true ? "Cash" : "Online",
                      style: TextStyle(
                        color: currentOrders_Model.isCash == true
                            ? Colors.blue
                            : Colors.red,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'BentonSans_Bold',
                      ),
                      // textAlign: TextAlign.right,
                    ),
                  ),
                  if (currentOrders_Model.isCash == false)
                    Row(
                      children: [
                        Text(
                          "Payment Status: ",
                          style: theme.textTheme.labelMedium,
                          // textAlign: TextAlign.right,
                        ),
                        Text(
                          'Success',
                          style: theme.textTheme.bodyLarge!.copyWith(
                              color: Colors.green, fontWeight: FontWeight.w900),
                          // textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                ],
              ),
              TextButton(
                onPressed: prepared,
                child: Text(
                  "Prepared...",
                  style: theme.textTheme.titleSmall,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
