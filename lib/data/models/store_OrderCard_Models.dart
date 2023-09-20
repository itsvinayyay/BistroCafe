

class store_HomeScreenOrderCard {
  String? name;
  int? mrp;
  String? entryNo;
  bool? isDineIn;
  bool? isCOD;
  String? date_Time;
  String? hostelName;
}


class store_MenuItemsCard_Model {
  String? itemName;
  int? mrp;
  String? itemID;
  bool? isavailable;
  String? category;
  String? imageUrl;

  store_MenuItemsCard_Model({
    this.itemName,
    this.itemID,
    this.category,
    this.mrp,
    this.isavailable,
    this.imageUrl,
  });

  store_MenuItemsCard_Model.fromJson(Map<String, dynamic> json){
    itemName = json["Name"];
    itemID = json["ItemID"];
    mrp = json["Price"];
    category = json["Category"];
    isavailable = json["Available"];
    imageUrl = json["ImageURL"];
  }
}