import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/store_modify_menuitem_cubit.dart/modify_menuitem_state.dart';
import 'package:food_cafe/data/repository/store_repositories/menuitem_modification_repository.dart';

class Modify_MenuItemCubit extends Cubit<ModifyMenuItemStates> {
  Modify_MenuItemCubit() : super(ModifyMenuItemInitialState());

  MenuItemModification_Repository _menuItemModification_Repository =
      MenuItemModification_Repository();

  Future<void> uploadModifiedMenuItem({
    required String storeID,
    required String itemName,
    required String category,
    required int mrp,
    required bool isavailable,
    File? imageFile,
    required String itemID,
  }) async {
    try {
      emit(ModifyMenuItemLoadingState());
      await _menuItemModification_Repository.modifyMenuItems(
          storeID: storeID,
          itemName: itemName,
          category: category,
          mrp: mrp,
          isavailable: isavailable,
          imageFile: imageFile,
          itemID: itemID);
      emit(ModifyMenuItemLoadedState());
    } catch (e) {
      log("Exception while updating Menu Item (Error from MenuItem Modification Cubit)");
      emit(
        ModifyMenuItemErrorState(e.toString()),
      );
    }
  }
}
