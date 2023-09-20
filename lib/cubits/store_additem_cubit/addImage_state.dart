

import 'dart:io';

abstract class AddImage{}

class ImageInitialState extends AddImage{}

class ImageLoadingState extends AddImage{}

class ImageLoadedState extends AddImage{
  File image;
  ImageLoadedState(this.image);
}

class ImageErrorState extends AddImage{
  String error;
  ImageErrorState(this.error);
}