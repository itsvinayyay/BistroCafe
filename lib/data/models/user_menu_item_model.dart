
class MenuItemModel {
  String? name;
  int? mrp;
  String? itemID;
  String? imageURL;
  String? category;

  MenuItemModel({
    this.name,
    this.mrp,
    this.itemID,
    this.imageURL,
    this.category,
  });
  MenuItemModel.fromJson(Map<String, dynamic> json) {
    name = json["Name"];
    mrp = json["Price"];
    itemID = json["ItemID"];
    imageURL = json["ImageURL"];
    category = json['Category'];
  }
}
