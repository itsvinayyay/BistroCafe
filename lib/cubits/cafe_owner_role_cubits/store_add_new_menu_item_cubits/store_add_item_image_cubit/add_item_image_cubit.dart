import 'dart:developer';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_add_new_menu_item_cubits/store_add_item_image_cubit/add_item_image_states.dart';
import 'package:image_picker/image_picker.dart';

/// Cubit responsible for managing the state related to adding an image.
class AddImageCubit extends Cubit<AddImage> {
  // Initializes the [AddImageCubit] with the initial state as [ImageInitialState].
  AddImageCubit() : super(ImageInitialState());

  /// Asynchronously picks an image from the device's gallery using the ImagePicker.
  Future<void> pickImage() async {
    // Emitting the state to indicate that image loading is in progress.
    emit(ImageLoadingState());

    // Creating an instance of ImagePicker for image selection.
    final picker = ImagePicker();

    try {
      // Attempting to pick an image from the device's gallery.
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      // Checking if an image was successfully picked.
      if (pickedFile != null) {
        // Emitting the state to indicate that the image has been successfully loaded.
        emit(ImageLoadedState(File(pickedFile.path)));
      } else {
        // Emitting the initial state if no image was picked.
        emit(ImageInitialState());
      }
    } catch (e) {
      // Logging and emitting an error state in case of an exception during the image picking process.
      log("Exception while picking an Image from Image Picker (Error from Add Image Cubit)");
      emit(ImageErrorState("Error Loading Image $e"));
    }
  }
}
