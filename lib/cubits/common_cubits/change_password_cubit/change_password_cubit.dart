import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/common_cubits/change_password_cubit/change_password_states.dart';
import 'package:food_cafe/data/repository/common_repositories/change_password_repository.dart';

/// Cubit responsible for managing the change password functionality.
class ChangePasswordCubit extends Cubit<ChangePasswordStates> {
  // Constructor initializing the cubit with the initial state.
  ChangePasswordCubit() : super(ChangePasswordInitialState());

  /// Repository for handling password change operations.
  final ChangePasswordRepository _changePasswordRepository =
      ChangePasswordRepository();

  /// Initiates the process of changing the user's password.
  ///
  /// Parameters:
  /// - [oldPassword]: The user's current password.
  /// - [newPassword]: The new password the user wants to set.
  Future<void> initiatePasswordChange({
    required String oldPassword,
    required String newPassword,
  }) async {
    emit(ChangePasswordLoadingState());
    try {
      await _changePasswordRepository.changePassword(
          oldPassword: oldPassword, newPassword: newPassword);
      emit(ChangePasswordLoadedState());
    } catch (e) {
      log("Exception while changing password (Error from Change Password Cubit)");
      emit(ChangePasswordErrorState(e.toString()));
    }
  }
}
