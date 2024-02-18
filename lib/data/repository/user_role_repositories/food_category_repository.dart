import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_cafe/data/models/user_menu_item_model.dart';


/// Repository class responsible for handling interactions related to food categories.
class FoodCategoryRepository {
  /// Instance of Firestore for database operations.
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Retrieves a list of food items based on the specified category and store.
  ///
  /// Parameters:
  /// - [categoryName]: The name of the food category.
  /// - [storeID]: The ID of the store associated with the category.
  Future<List<MenuItemModel>> getFoodCategoryWise(
      {required String categoryName, required String storeID}) async {
    try {
      // Reference to the collection of menu items for the specified store.
      CollectionReference collectionReference = _firestore
          .collection('groceryStores')
          .doc(storeID)
          .collection('menuItems');

      // Querying for documents matching the specified category.
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await collectionReference
              .where('Category', isEqualTo: categoryName)
              .get() as QuerySnapshot<Map<String, dynamic>>;

      if (querySnapshot.docs.isNotEmpty) {
        // Mapping the documents to MenuItemModel objects.
        List<MenuItemModel> categoryItems = querySnapshot.docs
            .map((DocumentSnapshot<Map<String, dynamic>> document) {
          return MenuItemModel.fromJson(
              document.data() as Map<String, dynamic>);
        }).toList();

        return categoryItems;
      } else {
        // Logging a message when no food items are found in the category.
        log('There are no Food Items in this Category');
        return [];
      }
    } catch (e) {
      // Logging and rethrowing an exception in case of an error.
      log("Exception while retrieving Category-Wise Food Items (Error from Food Category Repository)");
      rethrow;
    }
  }
}

