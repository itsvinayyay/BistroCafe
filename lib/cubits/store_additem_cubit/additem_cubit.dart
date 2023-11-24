import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/store_additem_cubit/addImage_state.dart';
import 'package:food_cafe/cubits/store_additem_cubit/additem_state.dart';
import 'package:image_picker/image_picker.dart';

class CategoryCubit extends Cubit<String> {
  CategoryCubit() : super("Appetizer");

  void toggleCategory(String received) {
    emit(received);
  }
}

class AvailableCubit extends Cubit<bool> {
  AvailableCubit() : super(false);

  void toggleAvailibility(bool isavailable) {
    emit(isavailable);
  }
}

class AddImageCubit extends Cubit<AddImage> {
  AddImageCubit() : super(ImageInitialState());

  Future<void> PickImage() async {
    emit(ImageLoadingState());
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        emit(ImageLoadedState(File(pickedFile.path)));
      } else {
        print("pickedFile is null!");
      }
    } catch (e) {
      print("Error from try Bloc!");
      print(e);
      emit(ImageErrorState("Error Loading Image $e"));
    }
  }
}

class AddItemCubit extends Cubit<AddItemState> {
  AddItemCubit() : super(AddItemInitialState());
  final _firestore = FirebaseFirestore.instance;

  Future<void> uploadItemtoFireStore({
    required String storeID,
    required String name,
    required String category,
    required int mrp,
    required bool isavailable,
    required File imageFile,
  }) async {
    String downloadUrl = "";
    String? itemID = await readItemID(storeID);
    // Future.delayed(Duration(seconds: 5));
    if(itemID!=null){
      print("Got the Item ID");
    }
    else{
      print("Item ID is null");
    }


    try {
      emit(AddItemLoadingState());
      String filePath = 'groceryStores/$storeID/menuItems/$itemID';
      Reference storageReference = FirebaseStorage.instance.ref().child(
          filePath);
      UploadTask uploadTask = storageReference.putFile(imageFile);
      await uploadTask.whenComplete(() =>
          print("image Uploaded Successfully!"));

      downloadUrl = await storageReference.getDownloadURL();
      print('Got Download URL!');
      emit(AddItemImageUploadedState());
    }
    catch (exception) {
      print("Exception called while uploading Image to Storage!!!!");
      emit(AddItemImageUpload_ErrorState(error: exception.toString()));
    }

    try {
      emit(AddItemLoadingState());
      await FirebaseFirestore.instance.collection('groceryStores').doc(
          storeID).collection('menuItems').doc(itemID).set({
        'Name': name,
        'Price': mrp,
        'ItemID': itemID,
        'Category': category,
        'Available': isavailable,
        'ImageURL': downloadUrl
      });
      emit(AddItemUploadedState());
    }
    catch (exception){
      print("Exception called while uploading data to Firestore!");
      print(exception);
      emit(AddItemErrorState(error: exception.toString()));
    }
  }

  Future<String?> readItemID(String storeID) async {
    try {
      final docRef = _firestore.collection('groceryStores').doc(storeID);
      final snapshots = await docRef.get();
      if (snapshots.exists) {
        String? lastItemID = await snapshots.data()!['LastItem_ID'];
        if(lastItemID!=null){
          String newItemID = _generateNextItemID(lastItemID);
          await docRef.update({'LastItem_ID': newItemID});
          return newItemID;
        }
        else{
          String initialItemID = '${storeID}ITEM1';
          await docRef.update({'LastItem_ID': initialItemID});
          return initialItemID;
        }
      } else {
        print("The store document doesn't exists!");
        return null;
      }
    } catch (e) {
      print("Exception thrown while reading last Item ID!!! $e");
      return null;
    }
  }

  String _generateNextItemID(String previousItemID) {
    // Split the previous transaction ID
    List<String> parts = previousItemID.split('ITEM');
    if (parts.length != 2) {
      // Handle invalid input
      print("Error with the previous Item ID");
    }

    String prefix = parts[0]; // e.g., "SMVDU101"
    String numericPart = parts[1]; // e.g., "1"

    // Convert the numeric part to an integer and increment it
    int? numericValue = int.tryParse(numericPart);
    if (numericValue == null) {
      // Handle invalid input
      print("Error while parsing numeric part of the Last Item ID!!!");
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
