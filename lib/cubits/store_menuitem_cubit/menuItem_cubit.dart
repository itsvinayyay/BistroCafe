import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/store_menuitem_cubit/menuItem_states.dart';

import 'package:food_cafe/data/models/store_OrderCard_Models.dart';
import 'package:food_cafe/data/repository/store_repositories/store_menuitems_repository.dart';

class MenuItemCubit extends Cubit<MenuItemStates> {
  MenuItemCubit() : super(MenuItemInitialState());

  final _fireStore = FirebaseFirestore.instance;
  MenuItemRepository menuItemRepository = MenuItemRepository();

  Future<void> toggleAvailability(
      {required String itemID,
      required bool newAvailability,
      required String storeID}) async {
    try {
      await menuItemRepository.modifyAvailability(
          storeID: storeID, itemID: itemID, newAvailability: newAvailability);
    } catch (e) {
      log("Exception thrown while modifying Availability from MenuItems Cubit");
    }
  }

  Future<void> deleteItem(
      {required String itemID, required String storeID}) async {
    try {
      menuItemRepository.deleteItemImage(storeID: storeID, itemID: itemID);
      menuItemRepository.deleteItem(storeID: storeID, itemID: itemID);
    } catch (e) {
      log("Exception thrown while Deleting Menu Item from MenuItems Cubit");
    }
  }

  // int totalMRP = 0;

  void startListening(String storeID) {
    // print(storeID);
    // final collectionRef = _fireStore
    //     .collection('groceryStores')
    //     .doc(storeID)
    //     .collection('menuItems');

    // _subscription = collectionRef.snapshots().listen((snapshot) {
    //   final MenuItems = snapshot.docs
    //       .map((docs) => store_MenuItemsCard_Model.fromJson(docs.data()))
    //       .toList();
    //   emit(MenuItems);
    // });
    emit(MenuItemLoadingState(state.menuItems));

    try {
      menuItemRepository.getMenuItemsStream(storeID);
      menuItemRepository.getMenuItems
          .listen((List<store_MenuItemsCard_Model> menuItems) {
        emit(MenuItemLoadedState(menuItems));
      });
    } catch (e) {
      log("Got the error in MenuItems Cubit");
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
    menuItemRepository.closeSubscription();
    return super.close();
  }
}
