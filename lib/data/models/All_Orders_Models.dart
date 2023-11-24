import 'package:cloud_firestore/cloud_firestore.dart';

class RequestedOrders_Model {
  String? orderID;
  String? customerName;
  String? entryNo;
  int? totalMRP;
  List<Map<String, dynamic>>? orderItems;
  Timestamp? time;
  bool? isDineIn;
  bool? isCash;
  String? storeID;
  String? hostelName;

  RequestedOrders_Model({this.orderID,
    this.customerName,
    this.entryNo,
    this.totalMRP,
    this.orderItems,
    this.time,
    this.isDineIn,
    this.isCash,
    this.storeID,
    this.hostelName,
  });

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
      isCash: json['IsPaid'] as bool,
      storeID: json['StoreID'] as String,
      hostelName: json['HostelName'] ?? "Error",
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
      'Time': time,
      'IsPaid': isCash,
      'IsDineIn': isDineIn,
      'StoreID': storeID,
      'HostelName': hostelName,
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
  bool? isCash;
  String? hostelName;

  CurrentOrders_Model({this.orderID,
    this.trxID,
    this.customerName,
    this.entryNo,
    this.totalMRP,
    this.orderItems,
    this.time,
    this.isDineIn,
    this.isCash,
    this.hostelName,
  });

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
      isCash: json['IsPaid'] as bool,
        hostelName: json['HostelName'] ?? "Not Applicable",
    );
  }

  // Convert an Order object to a Map for Firestore
  Map<String, dynamic> toJson() {
    return {
      'TRXID': trxID,
      'OrderID': orderID,
      'Name': customerName,
      'EntryNo': entryNo,
      'Total': totalMRP,
      'MenuItems': orderItems,
      'Time': time,
      'IsPaid': isCash,
      'IsDineIn': isDineIn,
      'HostelName': hostelName,
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
  bool? isCash;
  String? hostelName;

  PastOrders_Model({this.orderID,
    this.trxID,
    this.customerName,
    this.entryNo,
    this.totalMRP,
    this.time,
    this.isDineIn,
    this.isCash,
    this.hostelName,
  });

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
      isCash: json['IsPaid'] as bool,
        hostelName: json['HostelName'] as String,
    );
  }

  // Convert an Order object to a Map for Firestore
  Map<String, dynamic> toJson() {
    return {
      'TRXID': trxID,
      'OrderID': orderID,
      'Name': customerName,
      'EntryNo': entryNo,
      'Total': totalMRP,
      'Time': time,
      'IsPaid': isCash,
      'IsDineIn': isDineIn,
      'HostelName': hostelName,
    };
  }
}


class BasicOrder_Model {
  String? name;
  int? qty;
  int? mrp;


  BasicOrder_Model({
    this.name,
    this.mrp,
    this.qty,
  });

  factory BasicOrder_Model.fromJson(Map<String, dynamic> json){
    return BasicOrder_Model(
      name : json['Name'] as String,
      qty: json['Qty'] as int,
      mrp: json['Price'] as int,
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'Name' : name,
      'Quantity' : qty,
      'Price' : mrp,
    };
  }
}
