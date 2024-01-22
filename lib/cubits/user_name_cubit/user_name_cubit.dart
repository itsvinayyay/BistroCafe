import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/user_name_cubit/user_name_states.dart';
import 'package:food_cafe/data/repository/user_name_repository.dart';

class UserNameCubit extends Cubit<UserNameStates> {
  UserNameCubit() : super(UserNameInitialState()){
    fetchUserName();
  }

  UserNameRepository _userNameRepository = UserNameRepository();

  Future<void> fetchUserName() async {
    emit(UserNameLoadingState(state.userName));
    try {
      String userName = await _userNameRepository.getUserName();
      emit(UserNameLoadedState(userName));
    } catch (e) {
      log("Exception in fetching the User Name (Error from User Name Cubit)");
      emit(UserNameErrorState(state.userName, e.toString()));
    }
  }
}
