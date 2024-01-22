import 'package:food_cafe/data/models/HomeScreen_FoodCard.dart';

abstract class HomeScreenStates {}

class HomeCardLoadingState extends HomeScreenStates {}

class HomeCardLoadedState extends HomeScreenStates {
  final List<MenuItemModel> cards;
  HomeCardLoadedState(this.cards);
}

class HomeCardErrorState extends HomeScreenStates {
  final String error;
  HomeCardErrorState(this.error);
}
