import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_cafe/data/models/HomeScreen_FoodCard.dart';

class HomeScreenRepository {
  Future<List<MenuItemModel>> fetchMenuItems({required String storeID}) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
          .collection("groceryStores")
          .doc(storeID)
          .collection("menuItems")
          .get();

      final List<MenuItemModel> menuItems =
          querySnapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
        final data = doc.data() as Map<String, dynamic>;
        return MenuItemModel.fromJson(data);
      }).toList();

      return menuItems;
    } catch (exception) {
      log("Exception thrown while fetching Menu Items (Error from Home Screen Repository)");
      rethrow;
    }
  }
}
