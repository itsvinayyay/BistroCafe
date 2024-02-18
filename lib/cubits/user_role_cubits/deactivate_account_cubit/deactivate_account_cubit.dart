import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/user_role_cubits/deactivate_account_cubit/deactivate_account_state.dart';
import 'package:food_cafe/data/repository/user_role_repositories/deactivate_account_repository.dart';

/// Cubit responsible for managing the state of deactivating user accounts.
class DeactivateAccountCubit extends Cubit<DeactivateAccountStates> {
  // Initialize the cubit with the initial state.
  DeactivateAccountCubit() : super(DeactivateAccountInitialState());

  // Repository for handling account deactivation.
  final DeactivateAccountRepository _deactivateAccountRepository =
      DeactivateAccountRepository();

  /// Initiates the process of deactivating the user account.
  ///
  /// Parameters:
  /// - [password]: The user's password for authentication.
  Future<void> initiateDeactivation({required String password}) async {
    // Emit loading state to indicate the start of the deactivation process.
    emit(DeactivateAccountLoadingState());
    try {
      // Deactivate the user account using the repository.
      await _deactivateAccountRepository.deactivateAccount(password: password);
      // Emit loaded state to indicate the successful account deactivation.
      emit(DeactivateAccountLoadedState());
    } catch (e) {
      // Handle exceptions and emit an error state.
      log("Exception thrown while deactivating Account (error from Deactivate Account Cubit)");
      emit(DeactivateAccountErrorState(e.toString()));
    }
  }
}

