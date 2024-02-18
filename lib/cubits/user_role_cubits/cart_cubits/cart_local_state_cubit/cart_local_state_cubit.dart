import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/data/models/user_cart_model.dart';
import 'package:food_cafe/data/repository/user_role_repositories/cart_repositories/cart_local_state_repository.dart';
import 'package:food_cafe/widgets/custom_snackbar.dart';

///Cubit which handles and manages Cart Local State
class CartLocalState extends Cubit<Map<String, int>> {
  CartLocalState() : super({});

  final CartLocalStateRepository _cartLocalStateRepository =
      CartLocalStateRepository();

  /// Initializes the local state from Firebase for a given person.
  ///
  /// Retrieves the initialized map from the local state repository using the provided [personID].
  /// Emits the initialized map using the `emit` method.
  /// Logs any exceptions that may occur during the initialization process.
  ///
  /// Parameters:
  /// - [personID]: The unique identifier of the person for whom the local state is being initialized.
  ///
  /// Throws:
  /// - If an exception occurs during the initialization process, it is caught, logged, and not rethrown.
  Future<void> initializefromFirebase({required String personID}) async {
    try {
      // Retrieve the initialized map from the local state repository.
      Map<String, int> initializedMap = await _cartLocalStateRepository
          .getLocalStateInitialized(personID: personID);

      // Emit the initialized map to update the state.
      emit(initializedMap);
    } catch (e) {
      // Log any exceptions that occur during the initialization process.
      log("Exception while initializing Local State (Error from Cart Local State Cubit)");
      log(e.toString());
    }
  }

  /// Adds items to the local state for a given person.
  ///
  /// Retrieves the current local state, increments the quantity of the specified item if it exists,
  /// and updates the local state. If the item does not exist, logs a message.
  ///
  /// Parameters:
  /// - [itemID]: The unique identifier of the item to be added.
  /// - [personID]: The unique identifier of the person for whom items are being added to the local state.
  ///
  /// Throws:
  /// - If an exception occurs during the process, it is caught, and an error is logged.
  void addItemsToLocal(
      {required String itemID, required String personID}) async {
    try {
      // Retrieve the current local state.
      Map<String, int> updatedState = Map.from(state);

      // Increment the quantity if the item already exists in the local state.
      if (updatedState.containsKey(itemID)) {
        updatedState[itemID] = updatedState[itemID]! + 1;
      } else {
        // Log a message if the item does not exist in the local state.
        log('Local State does not contain the Item ID');
      }

      // Update the local state with the modified map.
      emit(updatedState);
    } catch (e) {
      // Log any exceptions that occur during the process.
      log("Exception while adding Items to Local State (Error from Cart Local State Cubit)");
    }
  }

  /// Removes items from the local state for a given person.
  ///
  /// Retrieves the current local state, decreases the quantity of the specified item if it exists,
  /// and updates the local state. If the quantity becomes zero, the item is deleted from the cart.
  /// If the item does not exist, logs a message.
  ///
  /// Parameters:
  /// - [personID]: The unique identifier of the person for whom items are being removed from the local state.
  /// - [itemID]: The unique identifier of the item to be removed.
  ///
  /// Throws:
  /// - If an exception occurs during the process, it is caught, and an error is logged.
  void removeItemsfromLocal(
      {required String personID, required String itemID}) async {
    // Retrieve the current local state.
    Map<String, int> updatedState = Map.from(state);

    try {
      // Check if the item exists in the local state.
      if (updatedState.containsKey(itemID)) {
        // If the quantity is 1, delete the item from the cart and remove it from the local state.
        if (updatedState[itemID] == 1) {
          await _cartLocalStateRepository.deleteItemFromCart(
              personID: personID, itemID: itemID);
          updatedState.remove(itemID);
        } else {
          // Decrease the quantity of the item in the local state.
          updatedState[itemID] = updatedState[itemID]! - 1;
        }
        // Update the local state with the modified map.
        emit(updatedState);
      } else {
        // Log a message if the item does not exist in the local state.
        log('Local State does not contain the Item ID');
      }
    } catch (e) {
      // Log any exceptions that occur during the process.
      log("Exception while decreasing Item Quantity from Local State or deleting Item from Cart (Error from Cart Local State Cubit) => $e");
    }
  }

  /// Deletes an item from both the cart and the local state for a given person.
  ///
  /// Calls the [_cartLocalStateRepository] to delete the specified item from the cart.
  /// Removes the item from the local state and emits the updated state.
  ///
  /// Parameters:
  /// - [personID]: The unique identifier of the person for whom the item is being deleted from the cart.
  /// - [itemID]: The unique identifier of the item to be deleted.
  ///
  /// Throws:
  /// - If an exception occurs during the process, it is caught, and an error is logged.
  void deleteItemfromCart(
      {required String personID, required String itemID}) async {
    // Retrieve the current local state.
    Map<String, int> updatedState = Map.from(state);

    try {
      // Call the repository to delete the item from the cart.
      await _cartLocalStateRepository.deleteItemFromCart(
          itemID: itemID, personID: personID);

      // Remove the item from the local state.
      updatedState.remove(itemID);

      // Update the local state with the modified map.
      emit(updatedState);
    } catch (e) {
      // Log any exceptions that occur during the process.
      log("Exception while Deleting Item from Local State/Cart (Error from Cart Local State Cubit) => $e");
    }
  }

  /// Adds an item to both the cart and the local state for a given person.
  ///
  /// Calls the [_cartLocalStateRepository] to check if the item already exists in the cart.
  /// If the item exists, increments its quantity in the local state and shows a snackbar.
  /// If the item does not exist, adds it to the cart, sets its quantity to 1, and shows a snackbar.
  ///
  /// Parameters:
  /// - [personID]: The unique identifier of the person for whom the item is being added to the cart.
  /// - [item]: The item (of type [CartModel]) to be added.
  /// - [context]: The [BuildContext] to show a snackbar if applicable.
  ///
  /// Throws:
  /// - If an exception occurs during the process, it is caught, and an error is logged.
  void addItemstoCart({
    required String personID,
    required CartModel item,
    required BuildContext context,
  }) async {
    // Retrieve the current local state.
    Map<String, int> updatedState = Map.from(state);

    try {
      // Check if the item already exists in the cart.
      bool doesItemExist = await _cartLocalStateRepository.checkItemExists(
        personID: personID,
        itemID: item.itemID!,
      );

      // If the item exists, increment its quantity and show a snackbar.
      if (doesItemExist) {
        updatedState[item.itemID!] = updatedState[item.itemID]! + 1;
        if (context.mounted) {
          showSnackBar(
            context: context,
            error: "Item's Quantity has been increased...",
          );
        }
      } else {
        // If the item does not exist, add it to the cart, set its quantity to 1, and show a snackbar.
        updatedState[item.itemID!] = 1;
        await _cartLocalStateRepository.addItemToCart(
          personID: personID,
          item: item,
        );

        if (context.mounted) {
          showSnackBar(
            context: context,
            error: 'Item has been added to Cart...',
          );
        }
      }

      // Update the local state with the modified map.
      emit(updatedState);
    } catch (e) {
      // Log any exceptions that occur during the process.
      log("Exception while Adding Item to Local/Cart (Error from Cart Local State Cubit) => $e");
    }
  }

  /// Synchronizes the local state of the cart with the Firestore database.
  ///
  /// Calls the [_cartLocalStateRepository] to sync the local state of the cart
  /// for a given [personID] with the corresponding Firestore data.
  ///
  /// Parameters:
  /// - [personID]: The unique identifier of the person whose cart is being synchronized.
  ///
  /// Throws:
  /// - If an exception occurs during the sync process, it is caught, and an error is logged.
  Future<void> syncLocalState({required String personID}) async {
    try {
      // Use the [_cartLocalStateRepository] to sync the local state with Firestore.
      await _cartLocalStateRepository.syncCartWithLocal(
        personID: personID,
        localState: state,
      );

      // Log a message indicating that the items have been successfully synced.
      log("Items Synced!");
    } catch (e) {
      // Log an error if there's an issue syncing the cart with Firestore.
      log('Error syncing cart with Firestore (Error from Cart Local State Cubit): $e');
    }
  }

  void clearLocalState() async {
    Map<String, int> mapValue = state;
    mapValue.clear();
    emit(mapValue);
  }
}

class CartLocalStateInitializedCubit extends Cubit<bool> {
  CartLocalStateInitializedCubit() : super(false);

  void localStateInitialized() {
    emit(true);
  }
}
