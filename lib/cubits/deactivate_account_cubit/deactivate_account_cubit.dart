import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/deactivate_account_cubit/deactivate_account_state.dart';
import 'package:food_cafe/data/repository/deactivate_account_repository.dart';

class DeactivateAccountCubit extends Cubit<DeactivateAccountStates> {
  DeactivateAccountCubit() : super(DeactivateAccountInitialState());

  DeactivateAccountRepository deactivateAccountRepository =
      DeactivateAccountRepository();

  Future<void> initiateDeactivation({required String password}) async {
    emit(DeactivateAccountLoadingState());
    try {
      await deactivateAccountRepository.deactivateAccount(password: password);
      emit(DeactivateAccountLoadedState());
    } catch (e) {
      log("Exception thrown while deactivating Account (error from Deactivate Account Cubit)");
      emit(DeactivateAccountErrorState(e.toString()));
    }
  }
}
