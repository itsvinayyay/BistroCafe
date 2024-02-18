import 'dart:developer';
import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_add_new_menu_item_cubits/store_add_menu_item_cubit/add_menu_item_states.dart';

class CategoryCubit extends Cubit<String> {
  CategoryCubit({required String category}) : super(category);

  void toggleCategory(String received) {
    emit(received);
  }
}

class AvailableCubit extends Cubit<bool> {
  AvailableCubit({required bool availability}) : super(availability);

  void toggleAvailibility(bool isavailable) {
    emit(isavailable);
  }
}

class AddItemCubit extends Cubit<AddItemState> {
  AddItemCubit() : super(AddItemInitialState());
  final _firestore = FirebaseFirestore.instance;

  /// Asynchronously uploads an item to Firestore along with its image to Firebase Storage.
  /// Handles the process of uploading item details and the corresponding image file.
  /// Throws exceptions in case of errors during the upload process.
  Future<void> uploadItemtoFireStore({
    required String storeID,
    required String name,
    required String category,
    required int mrp,
    required bool isavailable,
    required File imageFile,
  }) async {
    String downloadUrl = "";

    // Retrieving the unique item ID associated with the store.
    String? itemID = await _readItemID(storeID);

    try {
      emit(AddItemLoadingState());

      // Constructing the file path in Firebase Storage for the item image.
      String filePath = 'groceryStores/$storeID/menuItems/$itemID';

      // Creating a reference to the Firebase Storage location for the item image.
      Reference storageReference =
          FirebaseStorage.instance.ref().child(filePath);

      // Initiating the upload task for the item image file.
      UploadTask uploadTask = storageReference.putFile(imageFile);

      // Waiting for the completion of the image upload.
      await uploadTask.whenComplete(() => log("Image Uploaded Successfully!"));

      // Retrieving the download URL of the uploaded image.
      downloadUrl = await storageReference.getDownloadURL();

      emit(AddItemImageUploadedState());
    } catch (exception) {
      log("Exception called while uploading Image to Firebase Storage (Error from Add Menu Item Cubit)");
      emit(AddItemImageUploadErrorState(error: exception.toString()));
    }

    try {
      emit(AddItemLoadingState());

      // Creating a reference to the Firestore collection for menu items.
      await FirebaseFirestore.instance
          .collection('groceryStores')
          .doc(storeID)
          .collection('menuItems')
          .doc(itemID)
          .set({
        'Name': name,
        'Price': mrp,
        'ItemID': itemID,
        'Category': category,
        'Available': isavailable,
        'ImageURL': downloadUrl
      });

      // Emitting state to indicate that the item details have been successfully uploaded.
      emit(AddItemUploadedState());
    } catch (exception) {
      log("Exception called while uploading New Menu Item to Firestore (Error from Add Menu Item Cubit)");
      emit(AddItemErrorState(error: exception.toString()));
    }
  }

  /// Asynchronously retrieves the unique item ID associated with the given store from Firestore.
  /// Handles the process of generating a new item ID if not available and updates the Firestore document accordingly.
  /// Throws exceptions in case of errors during the retrieval or update process.
  Future<String?> _readItemID(String storeID) async {
    try {
      // Creating a reference to the document for the specified grocery store.
      final docRef = _firestore.collection('groceryStores').doc(storeID);

      // Fetching the document snapshot.
      final snapshots = await docRef.get();

      // Checking if the document exists.
      if (snapshots.exists) {
        // Retrieving the last item ID from the document.
        String? lastItemID = await snapshots.data()!['LastItem_ID'];

        // Generating a new item ID if the last item ID is available.
        if (lastItemID != null) {
          String newItemID = _generateNextItemID(lastItemID);

          // Updating the document with the new item ID.
          await docRef.update({'LastItem_ID': newItemID});

          return newItemID;
        } else {
          // If the last item ID is not available, generating an initial item ID.
          String initialItemID = '${storeID}ITEM1';

          // Updating the document with the initial item ID.
          await docRef.update({'LastItem_ID': initialItemID});

          return initialItemID;
        }
      } else {
        // Logging and returning null if the store document doesn't exist.
        log("The store document doesn't exist!");
        return null;
      }
    } catch (e) {
      // Logging and returning null in case of an exception during the process.
      log("Exception thrown while reading last Item ID!!! $e");
      return null;
    }
  }

  /// Generates the next item ID based on the provided previous item ID.
  /// Expects the previous item ID to follow the format "PREFIXITEMNUMERICPART" (e.g., "SMVDU101ITEM1").
  /// Handles the process of parsing the numeric part, incrementing it, and creating a new item ID.
  /// Throws exceptions for invalid input during parsing or incrementing.
  String _generateNextItemID(String previousItemID) {
    // Split the previous transaction ID
    List<String> parts = previousItemID.split('ITEM');
    if (parts.length != 2) {
      // Handle invalid input
      log("Error with the previous Item ID");
    }

    String prefix = parts[0]; // e.g., "SMVDU101"
    String numericPart = parts[1]; // e.g., "1"

    // Convert the numeric part to an integer and increment it
    int? numericValue = int.tryParse(numericPart);
    if (numericValue == null) {
      // Handle invalid input
      log("Error while parsing numeric part of the Last Item ID!!!");
    }

    // Increment the numeric value
    numericValue = numericValue! + 1;

    // Format the numeric part with leading zeros (if needed)
    String incrementedNumericPart = numericValue.toString();

    // Create the new transaction ID
    String newItemID = '${prefix}ITEM$incrementedNumericPart';

    return newItemID;
  }
}
