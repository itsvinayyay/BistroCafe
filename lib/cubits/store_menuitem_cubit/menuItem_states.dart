import 'package:food_cafe/data/models/store_OrderCard_Models.dart';

abstract class MenuItemStates {
  final List<store_MenuItemsCard_Model> menuItems;
  MenuItemStates(this.menuItems);
}

class MenuItemInitialState extends MenuItemStates {
  MenuItemInitialState() : super([]);
}

class MenuItemLoadingState extends MenuItemStates {
  MenuItemLoadingState(super.menuItems);
}

class MenuItemLoadedState extends MenuItemStates {
  MenuItemLoadedState(super.menuItems);
}

class MenuItemErrorState extends MenuItemStates {
  final String error;
  MenuItemErrorState(super.menuItems, this.error);
}
