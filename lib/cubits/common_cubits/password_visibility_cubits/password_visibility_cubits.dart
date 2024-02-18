import 'package:flutter_bloc/flutter_bloc.dart';

/// A [Cubit] to manage the visibility state of a password.
///
/// This [PasswordVisibility] class extends [Cubit<bool>] and is initialized with an initial state of `true`,
/// indicating that the password is initially visible. It provides a method [toggleVisibility] to toggle
/// the visibility state.
class PasswordVisibility extends Cubit<bool> {
  PasswordVisibility() : super(true);

  /// Toggles the visibility state of the password.
  ///
  /// This method flips the current state, changing it from visible to hidden or vice versa.
  void toggleVisibility() {
    emit(!state);
  }
}

/// A [Cubit] to manage the visibility state of a confirm password field.
///
/// This [ConfirmPasswordVisibility] class extends [Cubit<bool>] and is initialized with an initial state of `true`,
/// indicating that the confirm password field is initially visible. It provides a method [toggleVisibility]
/// to toggle the visibility state.
class ConfirmPasswordVisibility extends Cubit<bool> {
  ConfirmPasswordVisibility() : super(true);

  /// Toggles the visibility state of the confirm password field.
  ///
  /// This method flips the current state, changing it from visible to hidden or vice versa.
  void toggleVisibility() {
    emit(!state);
  }
}

/// A [Cubit] to manage the visibility state of an old password field.
///
/// This [OldpasswordVisibility] class extends [Cubit<bool>] and is initialized with an initial state of `true`,
/// indicating that the old password field is initially visible. It provides a method [toggleVisibility]
/// to toggle the visibility state.
class OldpasswordVisibility extends Cubit<bool> {
  OldpasswordVisibility() : super(true);

  /// Toggles the visibility state of the old password field.
  ///
  /// This method flips the current state, changing it from visible to hidden or vice versa.
  void toggleVisibility() {
    emit(!state);
  }
}
