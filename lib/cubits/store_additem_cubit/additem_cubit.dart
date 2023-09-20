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

  Future<void> uploadItemtoFireStore({
    required String name,
    required String category,
    required int mrp,
    required String itemID,
    required bool isavailable,
    required File imageFile,
    required String fileName,
  }) async {
    String downloadUrl = "";

    try {
      emit(AddItemLoadingState());
      String filePath = 'GroceryStore/SMVDU101/MenuItems/$fileName';
      Reference storageReference = FirebaseStorage.instance.ref().child(
          filePath);
      UploadTask uploadTask = storageReference.putFile(imageFile);
      await uploadTask.whenComplete(() =>
          print("image Uploaded Successfully!"));

      downloadUrl = await storageReference.getDownloadURL();
      emit(AddItemImageUploadedState());
    }
    catch (exception) {
      print("Exception called while uploading Image to Storage!!!!");
      emit(AddItemImageUpload_ErrorState(error: exception.toString()));
    }

    try {
      emit(AddItemLoadingState());
      await FirebaseFirestore.instance.collection('groceryStores').doc(
          'SMVDU101').collection('menuItems').doc(itemID).set({
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
}
