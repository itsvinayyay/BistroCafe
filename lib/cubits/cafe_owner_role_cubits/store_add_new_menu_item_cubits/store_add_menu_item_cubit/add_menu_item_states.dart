/// Represents the different states for the AddItemCubit.
abstract class AddItemState {}

/// Initial state for the AddItemCubit.
class AddItemInitialState extends AddItemState {}

/// State indicating successful item upload.
class AddItemUploadedState extends AddItemState {}

/// State indicating successful image upload.
class AddItemImageUploadedState extends AddItemState {}

/// State indicating an error during image upload.
class AddItemImageUploadErrorState extends AddItemState {
  final String error;

  // Constructor to initialize with the provided error message.
  AddItemImageUploadErrorState({required this.error});
}

/// State indicating that the item is currently loading.
class AddItemLoadingState extends AddItemState {}

/// State indicating an error during the item upload process.
class AddItemErrorState extends AddItemState {
  final String error;

  // Constructor to initialize with the provided error message.
  AddItemErrorState({required this.error});
}
