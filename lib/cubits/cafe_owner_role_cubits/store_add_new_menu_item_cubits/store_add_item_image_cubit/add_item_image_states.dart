import 'dart:io';

/// Abstract class representing the different states of image loading in the AddImageCubit.
abstract class AddImage {}

/// Initial state when no image has been selected.
class ImageInitialState extends AddImage {}

/// State indicating that the image is currently being loaded or picked.
class ImageLoadingState extends AddImage {}

/// State indicating that the image has been successfully loaded or picked.
class ImageLoadedState extends AddImage {
  final File image;

  // Constructs an [ImageLoadedState] with the provided [image] file.
  ImageLoadedState(this.image);
}

/// State indicating that an error occurred during the image loading process.
class ImageErrorState extends AddImage {
  final String error;

  // Constructs an [ImageErrorState] with the provided [error] message.
  ImageErrorState(this.error);
}
