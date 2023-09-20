import 'package:flutter_bloc/flutter_bloc.dart';
enum MyTheme {light, dark}

class ThemeCubit extends Cubit<MyTheme>{
  ThemeCubit() : super(MyTheme.dark);


  void toggleTheme(){
    emit(state == MyTheme.light ? MyTheme.dark : MyTheme.light);
  }

}