import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_menuitem_cubit/menu_item_states.dart';
import 'package:food_cafe/data/models/store_menu_item_model.dart';


import 'package:food_cafe/data/repository/cafe_owner_role_repositories/store_menuitems_repository.dart';
import 'package:food_cafe/data/services/connectivity_service.dart';

///Cubit to handle interactions regarding a menuItem with the database (Firestore).
class MenuItemCubit extends Cubit<MenuItemStates> {
  MenuItemCubit() : super(MenuItemInitialState());

  final MenuItemRepository _menuItemRepository = MenuItemRepository();

  /// Toggles the availability of a menu item identified by its ID.
  ///
  /// This method calls the `modifyAvailability` function from the `menuItemRepository`
  /// to update the availability status of the specified menu item in the Firestore database.
  ///
  /// Parameters:
  /// - `itemID`: The unique identifier of the menu item to be modified.
  /// - `newAvailability`: The new availability status for the menu item.
  /// - `storeID`: The identifier of the store where the menu item belongs.
  ///
  /// Throws an exception if there's an issue during the modification process.
  Future<void> toggleAvailability({
    required String itemID,
    required bool newAvailability,
    required String storeID,
  }) async {
    try {
      await _menuItemRepository.modifyAvailability(
        storeID: storeID,
        itemID: itemID,
        newAvailability: newAvailability,
      );
    } catch (e) {
      log("Exception thrown while modifying Availability of a Menu Item with Item ID as $itemID (Error from MenuItems Cubit)");
    }
  }

  /// Deletes a menu item and its associated image from the Firestore database.
  ///
  /// This method calls the `deleteItemImage` and `deleteItem` functions from the `menuItemRepository`
  /// to remove the specified menu item and its image from the Firestore database.
  ///
  /// Parameters:
  /// - `itemID`: The unique identifier of the menu item to be deleted.
  /// - `storeID`: The identifier of the store where the menu item belongs.
  ///
  /// Throws an exception if there's an issue during the deletion process.
  Future<void> deleteItem({
    required String itemID,
    required String storeID,
  }) async {
    try {
      await _menuItemRepository.deleteItemImage(
          storeID: storeID, itemID: itemID);
      await _menuItemRepository.deleteItem(storeID: storeID, itemID: itemID);
    } catch (e) {
      log("Exception thrown while Deleting Menu Item with Item ID $itemID (Error from MenuItems Cubit)");
    }
  }

  /// Initiates the process of listening to a stream of menu items for a specific store.
  ///
  /// This method calls the `getMenuItemsStream` function from the `menuItemRepository`
  /// to obtain a stream of menu items for the specified store. It then listens to the stream
  /// and updates the state of the `MenuItemCubit` accordingly.
  ///
  /// Parameters:
  /// - `storeID`: The identifier of the store for which the menu items stream is requested.
  ///
  /// Throws an exception if there's an issue during the stream retrieval or listening process.
  Future<void> startListening(String storeID) async {
    emit(MenuItemLoadingState(state.menuItems));
    try {
      await checkConnectivityForCubits(onDisconnected: () {
        emit(MenuItemErrorState(state.menuItems, 'internetError'));
      }, onConnected: () {
        _menuItemRepository.getMenuItemsStream(storeID);
        _menuItemRepository.getMenuItems
            .listen((List<StoreMenuItemModel> menuItems) {
          emit(MenuItemLoadedState(menuItems));
        });
      });
    } catch (e) {
      log("Exception occurred while retrieving a stream for Menu Items Cubit (Error from Menu Items Cubit)");
      emit(
        MenuItemErrorState(
          state.menuItems,
          e.toString(),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    // Close the menu item subscription before closing the cubit
    _menuItemRepository.closeSubscription();
    return super.close();
  }
}
