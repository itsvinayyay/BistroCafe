

import 'package:food_cafe/data/models/HomeScreen_FoodCard.dart';

abstract class HomeCardState{}

class HomeCardLoadingState extends HomeCardState{}

class HomeCardLoadedState extends HomeCardState{
  final List<Home_FoodCard> cards;
  HomeCardLoadedState(this.cards);
}

class HomeCardErrorState extends HomeCardState{
  final String error;
  HomeCardErrorState(this.error);
}