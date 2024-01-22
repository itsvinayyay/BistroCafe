import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/change_password_cubit/change_password_states.dart';
import 'package:food_cafe/data/repository/change_password_repository.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordStates> {
  ChangePasswordCubit() : super(ChangePasswordInitialState());

  ChangePasswordRepository changePasswordRepository =
      ChangePasswordRepository();

  Future<void> initiatePasswordChange(
      {required String oldPassword, required String newPassword}) async {
    emit(ChangePasswordLoadingState());
    try {
      await changePasswordRepository.changePassword(
          oldPassword: oldPassword, newPassword: newPassword);
      emit(ChangePasswordLoadedState());
    } catch (e) {
      log("Exception while changing password (Error from Chnage Password Cubit)");
      emit(ChangePasswordErrorState(e.toString()));
    }
  }
}
