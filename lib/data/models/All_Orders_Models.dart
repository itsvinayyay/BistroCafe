import 'package:cloud_firestore/cloud_firestore.dart';

class RequestedOrders_Model {
  String? orderID;
  String? customerName;
  String? entryNo;
  int? totalMRP;
  List<Map<String, dynamic>>? orderItems;
  Timestamp? time;
  bool? isDineIn;
  bool? isPaid;

  RequestedOrders_Model(
      {this.orderID,
      this.customerName,
      this.entryNo,
      this.totalMRP,
      this.orderItems,
      this.time,
      this.isDineIn,
      this.isPaid});

  // Create an Order object from a Firestore document
  factory RequestedOrders_Model.fromJson(Map<String, dynamic> json) {
    return RequestedOrders_Model(
      orderID: json['OrderID'] as String,
      customerName: json['Name'] as String,
      entryNo: json['EntryNo'] as String,
      totalMRP: json['Total'] as int,
      orderItems: List<Map<String, dynamic>>.from(json['MenuItems'] as List),
      time: json['Time'] as Timestamp,
      isDineIn: json['IsDineIn'] as bool,
      isPaid: json['IsPaid'] as bool,
    );
  }

  // Convert an Order object to a Map for Firestore
  Map<String, dynamic> toJson() {
    return {
      'OrderID': orderID,
      'Name': customerName,
      'EntryNo': entryNo,
      'Total': totalMRP,
      'MenuItems': orderItems,
      'time': time,
      'IsPaid': isPaid,
      'IsDineIn': isDineIn,
    };
  }
}


class CurrentOrders_Model {
  String? orderID;
  String? trxID;
  String? customerName;
  String? entryNo;
  int? totalMRP;
  List<Map<String, dynamic>>? orderItems;
  Timestamp? time;
  bool? isDineIn;
  bool? isPaid;

  CurrentOrders_Model(
      {this.orderID,
        this.trxID,
        this.customerName,
        this.entryNo,
        this.totalMRP,
        this.orderItems,
        this.time,
        this.isDineIn,
        this.isPaid});

  // Create an Order object from a Firestore document
  factory CurrentOrders_Model.fromJson(Map<String, dynamic> json) {
    return CurrentOrders_Model(
      trxID: json['TRXID'] as String,
      orderID: json['OrderID'] as String,
      customerName: json['Name'] as String,
      entryNo: json['EntryNo'] as String,
      totalMRP: json['Total'] as int,
      orderItems: List<Map<String, dynamic>>.from(json['MenuItems'] as List),
      time: json['Time'] as Timestamp,
      isDineIn: json['IsDineIn'] as bool,
      isPaid: json['IsPaid'] as bool,
    );
  }

  // Convert an Order object to a Map for Firestore
  Map<String, dynamic> toJson() {
    return {
      'TRXID' : trxID,
      'OrderID': orderID,
      'Name': customerName,
      'EntryNo': entryNo,
      'Total': totalMRP,
      'MenuItems': orderItems,
      'time': time,
      'IsPaid': isPaid,
      'IsDineIn': isDineIn,
    };
  }
}

class PastOrders_Model {
  String? orderID;
  String? trxID;
  String? customerName;
  String? entryNo;
  int? totalMRP;
  Timestamp? time;
  bool? isDineIn;
  bool? isPaid;

  PastOrders_Model(
      {this.orderID,
        this.trxID,
        this.customerName,
        this.entryNo,
        this.totalMRP,
        this.time,
        this.isDineIn,
        this.isPaid});

  // Create an Order object from a Firestore document
  factory PastOrders_Model.fromJson(Map<String, dynamic> json) {
    return PastOrders_Model(
      trxID: json['TRXID'] as String,
      orderID: json['OrderID'] as String,
      customerName: json['Name'] as String,
      entryNo: json['EntryNo'] as String,
      totalMRP: json['Total'] as int,
      time: json['Time'] as Timestamp,
      isDineIn: json['IsDineIn'] as bool,
      isPaid: json['IsPaid'] as bool,
    );
  }

  // Convert an Order object to a Map for Firestore
  Map<String, dynamic> toJson() {
    return {
      'TRXID' : trxID,
      'OrderID': orderID,
      'Name': customerName,
      'EntryNo': entryNo,
      'Total': totalMRP,
      'time': time,
      'IsPaid': isPaid,
      'IsDineIn': isDineIn,
    };
  }
}
