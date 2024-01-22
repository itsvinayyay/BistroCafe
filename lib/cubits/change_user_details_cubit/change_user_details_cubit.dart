import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/change_user_details_cubit/change_user_details_states.dart';
import 'package:food_cafe/data/repository/change_user_details_repository.dart';

class ChangeUserDetailsCubit extends Cubit<ChangeUserDetailsStates> {
  ChangeUserDetailsCubit() : super(UserDetailsInitialState());

  ChangeUserDetailsRepository _changeUserDetailsRepository =
      ChangeUserDetailsRepository();

  Future<void> initiateChange(
      {required String name, required String personID}) async {
    emit(UserDetailsLoadingState());
    try {
      await _changeUserDetailsRepository.changeDetails(
          name: name, personID: personID);
      emit(UserDetailsLoadedState());
    } catch (e) {
      log("Exception while Changing the User Details (Error from Change user Details Cubit)");
      emit(UserDetailsErrorState(e.toString()));
    }
  }
}
