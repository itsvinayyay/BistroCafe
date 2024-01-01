

abstract class AddItemState {}

class AddItemInitialState extends AddItemState {}

class AddItemUploadedState extends AddItemState {
  // String name;
  // int mrp;
  // String category;
  // String itemID;
  // bool availability;
  // File imageFile;
  // String fileName;
  //
  // AddItemUploadedState(
  //     {required this.name,
  //     required this.mrp,
  //     required this.itemID,
  //     required this.category,
  //     required this.availability,
  //     required this.fileName,
  //     required this.imageFile});
}
class AddItemImageUploadedState extends AddItemState{}

class AddItemImageUpload_ErrorState extends AddItemState{
  String error;
  AddItemImageUpload_ErrorState({required this.error});
}

class AddItemLoadingState extends AddItemState {}

class AddItemErrorState extends AddItemState {
  String error;
  AddItemErrorState({required this.error});
}
