import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Enumeration representing the available themes: light and dark.
enum MyTheme { light, dark }

/// Cubit responsible for managing the application theme.
class ThemeCubit extends Cubit<MyTheme> {
  /// Initializes the theme cubit with the default theme set to dark.
  ThemeCubit() : super(MyTheme.dark) {
    _initialseThemeCubit();
  }

  /// Toggles the theme based on the provided [isDark] parameter.
  ///
  /// If [isDark] is true, the dark theme is emitted; otherwise, the light theme is emitted.
  Future<void> toggleTheme({required bool isDark}) async{
    
    emit(isDark ? MyTheme.dark : MyTheme.light);
    if (isDark) {
       await _setThemeMode(false);
    } else {
     await _setThemeMode(true);
    }
  }

  Future<bool> _getThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool('isLightMode') ?? false;
  }

  Future<void> _setThemeMode(bool isLightMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isLightMode', isLightMode);
  }

  Future<void> _initialseThemeCubit() async {
    bool isLightMode = await _getThemeMode();

    toggleTheme(isDark: !isLightMode);
  }
}
