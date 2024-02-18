
class StoreMenuItemModel {
  String? itemName;
  int? mrp;
  String? itemID;
  bool? isavailable;
  String? category;
  String? imageUrl;

  StoreMenuItemModel({
    this.itemName,
    this.itemID,
    this.category,
    this.mrp,
    this.isavailable,
    this.imageUrl,
  });

  StoreMenuItemModel.fromJson(Map<String, dynamic> json){
    itemName = json["Name"];
    itemID = json["ItemID"];
    mrp = json["Price"];
    category = json["Category"];
    isavailable = json["Available"];
    imageUrl = json["ImageURL"];
  }
}