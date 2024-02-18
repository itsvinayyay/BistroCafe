import 'package:food_cafe/data/models/user_menu_item_model.dart';

/// Abstract class representing the different states of the food category.
abstract class FoodCategoryState {
  /// List of food items associated with the category.
  final List<MenuItemModel> categoryItems;

  /// Constructor to initialize the state with a list of category items.
  FoodCategoryState(this.categoryItems);
}

/// Initial state of the food category with an empty list of items.
class FoodCategoryInitialState extends FoodCategoryState {
  // Constructor initializing the initial state with an empty list.
  FoodCategoryInitialState() : super([]);
}

/// State indicating that the food category is currently loading.
class FoodCategoryLoadingState extends FoodCategoryState {
  // Constructor inheriting the list of category items from the parent state.
  FoodCategoryLoadingState(List<MenuItemModel> categoryItems) : super(categoryItems);
}

/// State indicating that the food category has been successfully loaded.
class FoodCategoryLoadedState extends FoodCategoryState {
  // Constructor inheriting the list of category items from the parent state.
  FoodCategoryLoadedState(List<MenuItemModel> categoryItems) : super(categoryItems);
}

/// State indicating an error in fetching or processing the food category.
class FoodCategoryErrorState extends FoodCategoryState {
  // The error message describing the issue.
  final String error;

  // Constructor inheriting the list of category items and the error message from the parent state.
  FoodCategoryErrorState(List<MenuItemModel> categoryItems, this.error) : super(categoryItems);
}
