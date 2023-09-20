
class Cart_FoodCard_Model {
  int? mrp;
  String? itemID;
  String? name;
  int? quantity;

  Cart_FoodCard_Model({
    this.name,
    this.itemID,
    this.mrp,
    this.quantity,
  });


  Cart_FoodCard_Model.fromJson(Map<String, dynamic> json){
    name = json["Name"];
    itemID = json["ItemID"];
    mrp = json["Price"];
    quantity = json["Quantity"];
  }


  Map<String, dynamic> toJson(){
    Map<String, dynamic> data = Map<String, dynamic>();
    data["Name"] = name;
    data["Price"] = mrp;
    data["Quantity"] = quantity;
    data["ItemID"] = itemID;
    return data;
  }
}
