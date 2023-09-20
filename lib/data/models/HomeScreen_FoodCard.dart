import 'package:flutter/material.dart';

class Home_FoodCard {
  String? name;
  int? mrp;
  String? itemID;

  Home_FoodCard({
    this.name,
    this.mrp,
    this.itemID,
  });
  Home_FoodCard.fromJson(Map<String, dynamic> json){
    name = json["Name"];
    mrp = json["Price"];
    itemID = json["ItemID"];
  }
}
