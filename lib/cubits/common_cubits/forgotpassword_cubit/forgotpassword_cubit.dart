import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/common_cubits/forgotpassword_cubit/forgotpassword_states.dart';
import 'package:food_cafe/data/repository/common_repositories/forgot_password_repository.dart';

/// Cubit responsible for handling the forgot password feature.
class ForgotPasswordCubit extends Cubit<ForgotPasswordStates> {

  /// Initializes the ForgotPasswordCubit with the initial state.
  ForgotPasswordCubit() : super(ForgotPasswordInitialState());



  /// Repository for forgot password operations.
  final ForgotPasswordRepository _forgotPasswordRepository =
      ForgotPasswordRepository();

  

  /// Initiates the process of sending a password reset email.
  ///
  /// Takes [email] as the user's email for initiating the reset process.
  Future<void> initiateForgotPassword({required String email}) async {
    // Emit the loading state to indicate the start of the operation.
    emit(ForgotPasswordLoadingState());

    try {
      // Call the repository to initiate the forgot password request.
      await _forgotPasswordRepository.initiateForgotPasswordRequest(
        email: email,
      );

      // Emit the loaded state to indicate successful completion.
      emit(ForgotPasswordLoadedState());
    } catch (e) {
      // Log and emit an error state in case of an exception.
      log("Exception occurred while sending Password Resend Email (Error from Forgot Password Cubit)");
      emit(ForgotPasswordErrorState(e.toString()));
    }
  }
}

