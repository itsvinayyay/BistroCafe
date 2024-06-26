import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  String? orderID;
  String? trxID;
  String? customerName;
  String? entryNo;
  int? totalMRP;
  List<Map<String, dynamic>>? orderItems;
  Timestamp? time;
  bool? isDineIn;
  bool?
      isPaid; //If the payemnt is done or not true if mode is COD else can be true else false
  bool? isCash; // If the payment is in Cash then true else false
  String? storeID;
  String? hostelName;
  String? tokenID;
  String? orderStatus;

  OrderModel({
    this.orderID,
    this.trxID,
    this.customerName,
    this.entryNo,
    this.totalMRP,
    this.orderItems,
    this.time,
    this.isDineIn,
    this.isPaid,
    this.isCash,
    this.storeID,
    this.hostelName,
    this.tokenID,
    this.orderStatus,
  });

  // Create an Order object from a Firestore document
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderID: json['OrderID'] as String,
      trxID: json['TRXID'] ?? "Null",
      customerName: json['Name'] as String,
      entryNo: json['EntryNo'] as String,
      totalMRP: json['Total'] as int,
      orderItems: List<Map<String, dynamic>>.from(json['MenuItems'] as List),
      time: json['Time'] as Timestamp,
      isDineIn: json['IsDineIn'] as bool,
      isPaid: json['IsPaid'] as bool,
      isCash: json['IsCash'] as bool,
      storeID: json['StoreID'] as String,
      hostelName: json['HostelName'] ?? "Error",
      tokenID: json['TokenID'],
      orderStatus: json['OrderStatus'],
    );
  }

  // Convert an Order object to a Map for Firestore
  Map<String, dynamic> toJson() {
    return {
      'OrderID': orderID,
      'TRXID': trxID,
      'Name': customerName,
      'EntryNo': entryNo,
      'Total': totalMRP,
      'MenuItems': orderItems,
      'Time': time,
      'IsPaid': isPaid,
      'IsCash': isCash,
      'IsDineIn': isDineIn,
      'StoreID': storeID,
      'HostelName': hostelName,
      'TokenID': tokenID,
      'OrderStatus': orderStatus,
    };
  }
}
