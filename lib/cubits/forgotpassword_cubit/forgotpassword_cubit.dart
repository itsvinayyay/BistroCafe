import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/forgotpassword_cubit/forgotpassword_states.dart';
import 'package:food_cafe/data/repository/forgotpassword_repository.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordStates> {
  ForgotPasswordCubit() : super(ForgotPasswordInitialState());

  ForgotPasswordRepository forgotPasswordRepository =
      ForgotPasswordRepository();

  Future<void> initiateForgotPassword({required String email}) async {
    emit(ForgotPasswordLoadingState());
    try {
      await forgotPasswordRepository.initiateForgotPasswordRequest(
          email: email);
      emit(ForgotPasswordLoadedState());
    } catch (e) {
      log("Exception occured while sending Password Resend Email (Error from Forgot Password Cubit)");
      emit(
        ForgotPasswordErrorState(e.toString()),
      );
    }
  }
}
