import 'dart:developer';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_modify_menuitem_cubit.dart/modify_menuitem_state.dart';
import 'package:food_cafe/data/repository/cafe_owner_role_repositories/menuitem_modification_repository.dart';

class ModifyMenuItemCubit extends Cubit<ModifyMenuItemStates> {
  ModifyMenuItemCubit() : super(ModifyMenuItemInitialState());

  final ModifyMenuItemRepository _modifyMenuItemRepository =
      ModifyMenuItemRepository();

  /// Uploads the modified menu item to the Firestore database.
  ///
  /// [storeID] represents the unique identifier for the store.
  /// [itemName] is the name of the menu item.
  /// [category] is the category to which the menu item belongs.
  /// [mrp] is the maximum retail price of the menu item.
  /// [isavailable] indicates whether the menu item is available.
  /// [imageFile] is an optional parameter representing the image file of the menu item.
  /// [itemID] is the unique identifier for the menu item to be modified.
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
      await _modifyMenuItemRepository.modifyMenuItems(
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
