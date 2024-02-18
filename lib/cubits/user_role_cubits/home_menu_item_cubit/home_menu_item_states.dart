import 'package:food_cafe/data/models/user_menu_item_model.dart';

/// Abstract class representing the various states of the home screen.
abstract class HomeMenuItemsStates {
  final List<MenuItemModel>
      cards; // List of menu item models associated with the state.

  // Constructor to initialize the state with menu item models.
  HomeMenuItemsStates(this.cards);
}

/// Initial state for the home screen, representing an empty list of menu items.
class HomeCardInitialState extends HomeMenuItemsStates {
  HomeCardInitialState() : super([]); // Initialize with an empty list.
}

/// Loading state for the home screen, indicating an ongoing data fetch operation.
class HomeCardLoadingState extends HomeMenuItemsStates {
  HomeCardLoadingState(
      super.cards); // Inherit the list of menu items from the base class.
}

/// Loaded state for the home screen, containing a list of fetched menu items.
class HomeCardLoadedState extends HomeMenuItemsStates {
  HomeCardLoadedState(
      super.cards); // Inherit the list of menu items from the base class.
}

/// Error state for the home screen, indicating a failure in fetching data.
class HomeCardErrorState extends HomeMenuItemsStates {
  final String error; // Specific error message describing the failure.

  // Constructor to initialize the error state with an error message and menu item models.
  HomeCardErrorState(this.error, super.cards);
}
