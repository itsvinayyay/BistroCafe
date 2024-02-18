import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_cafe/data/models/store_order_model.dart';
import 'package:food_cafe/screens/store_screens/side_drawer_screens/orders_screens/store_orders_screen.dart';
import 'package:intl/intl.dart';

Card unpaidOrders_Card(
    {required ThemeData theme,
    required BuildContext context,
    required OrderModel requestedOrders_Model,
    required VoidCallback paymentSuccess,
    required VoidCallback paymentFailure}) {
  String time =
      DateFormat('hh:mm a').format(requestedOrders_Model.time!.toDate());
  String date =
      DateFormat('d MMM y').format(requestedOrders_Model.time!.toDate());
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
                  const SizedBox(
                    width: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        requestedOrders_Model.customerName!,
                        style: theme.textTheme.titleSmall,
                        textAlign: TextAlign.right,
                      ),
                      Text(
                        requestedOrders_Model.entryNo!,
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
                    requestedOrders_Model.isDineIn == true
                        ? "Dine-In"
                        : "Dine-Out",
                    style: theme.textTheme.titleSmall,
                    // textAlign: TextAlign.right,
                  ),
                  if (requestedOrders_Model.isDineIn == false)
                    Text(
                      requestedOrders_Model.hostelName!,
                      style: theme.textTheme.titleSmall,
                      // textAlign: TextAlign.right,
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
          Divider(
            thickness: 1,
            color: Colors.grey.shade600,
          ),
          Column(children: [
            ...List.generate(
              requestedOrders_Model.orderItems!.length,
              (index) => foodRow(
                theme: theme,
                foodItem: requestedOrders_Model.orderItems![index],
              ),
            ),
          ]),
          Divider(
            thickness: 1,
            color: Colors.grey.shade600,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "₹ ${requestedOrders_Model.totalMRP}",
                    style: theme.textTheme.labelLarge,
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          width: 2,
                          color: requestedOrders_Model.isPaid == false
                              ? Colors.red
                              : Colors.blue),
                    ),
                    child: Text(
                      requestedOrders_Model.isPaid == false ? "Online" : "Cash",
                      style: TextStyle(
                        color: requestedOrders_Model.isPaid == false
                            ? Colors.red
                            : Colors.blue,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'BentonSans_Bold',
                      ),
                      // textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: paymentFailure,
                    child: Text(
                      "Payment Failed",
                      style: theme.textTheme.titleSmall,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                    ),
                  ),
                  TextButton(
                    onPressed: paymentSuccess,
                    child: Text(
                      "Payment Success",
                      style: theme.textTheme.titleSmall,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                    ),
                  ),
                ],
              ),
            ],
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
                    requestedOrders_Model.trxID!,
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
                    requestedOrders_Model.orderID!,
                    style: theme.textTheme.bodyLarge,
                    // textAlign: TextAlign.right,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
