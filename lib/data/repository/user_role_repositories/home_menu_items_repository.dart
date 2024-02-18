import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_cafe/data/models/user_menu_item_model.dart';



/// Repository class responsible for fetching menu items from Firestore.
class HomeMenuItemsRepository {
  /// Fetches a list of menu items based on the provided store ID.
  ///
  /// Throws an exception if an error occurs during the fetch process.
  Future<List<MenuItemModel>> fetchMenuItems({required String storeID}) async {
    try {
      // Initialize Firestore instance.
      final firestore = FirebaseFirestore.instance;

      // Fetch menu items from the 'menuItems' collection for the given store ID.
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
          .collection("groceryStores")
          .doc(storeID)
          .collection("menuItems")
          .get();

      // Convert query snapshot to a list of MenuItemModel instances.
      final List<MenuItemModel> menuItems =
          querySnapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
        final data = doc.data() as Map<String, dynamic>;
        return MenuItemModel.fromJson(data);
      }).toList();

      // Return the list of menu items.
      return menuItems;
    } catch (exception) {
      // Log and rethrow any exceptions that occur during the fetch process.
      log("Exception thrown while fetching Menu Items (Error from Home Screen Repository)");
      rethrow;
    }
  }
}
