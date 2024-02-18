import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/user_role_cubits/food_category_cubit/food_category_states.dart';
import 'package:food_cafe/data/models/user_menu_item_model.dart';
import 'package:food_cafe/data/repository/user_role_repositories/food_category_repository.dart';
import 'package:food_cafe/data/services/connectivity_service.dart';

/// Cubit responsible for managing the state related to food categories.
class FoodCategoryCubit extends Cubit<FoodCategoryState> {
  // Constructor initializing the cubit with the initial state.
  FoodCategoryCubit() : super(FoodCategoryInitialState());

  // Repository responsible for interacting with food category-related data.
  final FoodCategoryRepository _foodCategoryRepository = FoodCategoryRepository();

  /// Initiates the process of fetching food items based on a specific category.
  ///
  /// Parameters:
  /// - [categoryName]: The name of the food category.
  /// - [storeID]: The ID of the store associated with the category.
  Future<void> initiateCategoryFetch(
      {required String categoryName, required String storeID}) async {
    // Emitting the loading state with the current category items.
    emit(FoodCategoryLoadingState(state.categoryItems));

    try {
      // Checking connectivity before fetching data.
      await checkConnectivityForCubits(onDisconnected: () {
        // Emitting an error state when there's no internet connectivity.
        emit(FoodCategoryErrorState(state.categoryItems, 'internetError'));
      }, onConnected: () async {
        // Fetching food items based on the category.
        List<MenuItemModel> categoryItems = await _foodCategoryRepository
            .getFoodCategoryWise(categoryName: categoryName, storeID: storeID);

        // Emitting the loaded state with the fetched category items.
        emit(FoodCategoryLoadedState(categoryItems));
      });
    } catch (e) {
      // Logging and emitting an error state in case of an exception.
      log("Exception while retrieving Category_Wise Food Items (Error from Food Category Cubit)");
      emit(FoodCategoryErrorState(state.categoryItems, e.toString()));
    }
  }
}
