import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

enum MyTheme { light, dark }

class ThemeCubit extends Cubit<MyTheme> {
  ThemeCubit() : super(MyTheme.dark);

  void toggleTheme({required bool isDark}) {
    
    emit(isDark ? MyTheme.dark : MyTheme.light);
  }
}
