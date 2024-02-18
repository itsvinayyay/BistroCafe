import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/user_role_cubits/home_menu_item_cubit/home_menu_item_states.dart';
import 'package:food_cafe/data/models/user_menu_item_model.dart';
import 'package:food_cafe/data/repository/user_role_repositories/home_menu_items_repository.dart';
import 'package:food_cafe/data/services/connectivity_service.dart';

/// Cubit responsible for managing the state of the home menu items.
class HomeMenuItemsCubit extends Cubit<HomeMenuItemsStates> {
  HomeMenuItemsCubit() : super(HomeCardInitialState());

  // Repository to fetch menu items from Firebase.
  final HomeMenuItemsRepository _homeMenuItemsRepository =
      HomeMenuItemsRepository();

  /// Initiates the fetching of menu items for the home screen.
  /// - [storeID]: Unique identifier for the store associated with the menu.
  Future<void> initiateFetch({required String storeID}) async {
    emit(HomeCardLoadingState(state.cards));
    try {
      // Check internet connectivity before fetching menu items.
      await checkConnectivityForCubits(
        onDisconnected: () {
          emit(HomeCardErrorState('internetError', state.cards));
        },
        onConnected: () async {
          // Fetch menu items from the repository.
          List<MenuItemModel> cards =
              await _homeMenuItemsRepository.fetchMenuItems(storeID: storeID);
          emit(HomeCardLoadedState(cards));
        },
      );
    } catch (exception) {
      // Log and handle exceptions during the fetch process.
      log("Exception thrown while fetching Menu Items (Error from Home Screen Cubit)");
      emit(HomeCardErrorState(exception.toString(), state.cards));
    }
  }
}
