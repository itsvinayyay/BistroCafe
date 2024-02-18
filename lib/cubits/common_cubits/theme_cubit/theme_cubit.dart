import 'package:flutter_bloc/flutter_bloc.dart';

/// Enumeration representing the available themes: light and dark.
enum MyTheme { light, dark }

/// Cubit responsible for managing the application theme.
class ThemeCubit extends Cubit<MyTheme> {
  /// Initializes the theme cubit with the default theme set to dark.
  ThemeCubit() : super(MyTheme.dark);

  /// Toggles the theme based on the provided [isDark] parameter.
  ///
  /// If [isDark] is true, the dark theme is emitted; otherwise, the light theme is emitted.
  void toggleTheme({required bool isDark}) {
    emit(isDark ? MyTheme.dark : MyTheme.light);
  }
}

