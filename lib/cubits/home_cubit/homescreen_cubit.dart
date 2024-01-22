import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/home_cubit/homescreen_state.dart';
import 'package:food_cafe/data/models/HomeScreen_FoodCard.dart';
import 'package:food_cafe/data/repository/home_screen_repository.dart';

class HomeScreenCubit extends Cubit<HomeScreenStates> {
  HomeScreenCubit() : super(HomeCardLoadingState());

  HomeScreenRepository fetchFirebaseRepo = HomeScreenRepository();

  Future<void> initiateFetch({required String storeID}) async {
    try {
      List<MenuItemModel> cards =
          await fetchFirebaseRepo.fetchMenuItems(storeID: storeID);
      emit(HomeCardLoadedState(cards));
    } catch (exception) {
      log("Exception thrown while fetching Menu Items (Error from Home Screen Cubit)");
      emit(HomeCardErrorState(exception.toString()));
    }
  }
}
