

import 'dart:io';

class AddItemsModel{
  String name;
  int mrp;
  String category;
  String itemID;
  bool availability;
  String imageURL;

  AddItemsModel(
      {required this.name,
        required this.mrp,
        required this.itemID,
        required this.category,
        required this.availability,
        required this.imageURL});

  Map<String, dynamic> toJson(){
    Map<String, dynamic> data = Map<String, dynamic>();
    data['Name'] = name;
    data['Category'] = category;
    data['ItemID'] = itemID;
    data['Price'] = mrp;
    data['ImageURL'] =  imageURL;
    data['availability'] = availability;

    return  data;
  }
}