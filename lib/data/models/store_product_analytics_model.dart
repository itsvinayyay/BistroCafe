class ProductAnalysisModel {
  String? itemID;
  int? numbersSold;
  String? itemName;
  String? imageUrl;
  int? price;
  String? category;

  ProductAnalysisModel(
      {required this.itemID,
      required this.numbersSold,
      required this.category,
      required this.imageUrl,
      required this.itemName,
      required this.price});

  ProductAnalysisModel.fromFireStore(
      {required Map<String, dynamic> firestoreData,
      required String itemID,
      required int numbersSold}) {
    this.itemID = itemID;
    this.category = firestoreData['Category'];
    this.imageUrl = firestoreData['ImageURL'];
    this.itemName = firestoreData['Name'];
    this.price = firestoreData['Price'];
    this.numbersSold = numbersSold;
  }

  ProductAnalysisModel.empty(
      {required String itemID, required int numbersSold}) {
    this.itemID = itemID;
    this.category = 'DEL';
    this.imageUrl = 'https://cdn3.vectorstock.com/i/1000x1000/35/52/placeholder-rgb-color-icon-vector-32173552.jpg';
    this.itemName = 'Item Deleted';
    this.price = 0;
    this.numbersSold = numbersSold;
  }
}
