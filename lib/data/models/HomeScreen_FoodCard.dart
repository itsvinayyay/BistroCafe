import 'package:flutter/material.dart';

class Home_FoodCard {
  String? name;
  int? mrp;
  String? itemID;
  String? imageURL;

  Home_FoodCard({
    this.name,
    this.mrp,
    this.itemID,
    this.imageURL,
  });
  Home_FoodCard.fromJson(Map<String, dynamic> json){
    name = json["Name"];
    mrp = json["Price"];
    itemID = json["ItemID"];
    imageURL = json["ImageURL"];
  }
}
