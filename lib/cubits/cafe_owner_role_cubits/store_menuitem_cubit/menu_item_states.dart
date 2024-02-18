import 'package:food_cafe/data/models/store_menu_item_model.dart';

/// Abstract class representing the states of the MenuItemCubit.
abstract class MenuItemStates {
  final List<StoreMenuItemModel> menuItems;
  MenuItemStates(this.menuItems);
}

/// Initial state when no menu items are loaded.
class MenuItemInitialState extends MenuItemStates {
  MenuItemInitialState() : super([]);
}

/// Loading state while fetching menu items.
class MenuItemLoadingState extends MenuItemStates {
  MenuItemLoadingState(super.menuItems);
}

/// Loaded state with the list of menu items.
class MenuItemLoadedState extends MenuItemStates {
  MenuItemLoadedState(super.menuItems);
}

/// Error state when an issue occurs during menu item retrieval.
class MenuItemErrorState extends MenuItemStates {
  final String error;

  MenuItemErrorState(super.menuItems, this.error);
}
