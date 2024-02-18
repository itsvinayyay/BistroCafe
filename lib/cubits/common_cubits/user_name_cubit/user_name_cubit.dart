import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/common_cubits/user_name_cubit/user_name_states.dart';
import 'package:food_cafe/data/repository/common_repositories/user_name_repository.dart';

/// Cubit responsible for managing the user name state.
class UserNameCubit extends Cubit<UserNameStates> {
  /// Initializes the [UserNameCubit] with the initial state and triggers the
  /// fetchUserName method to retrieve the user name.
  UserNameCubit() : super(UserNameInitialState()) {
    fetchUserName();
  }

  /// Repository responsible for fetching user name data.
  final UserNameRepository _userNameRepository = UserNameRepository();

  /// Fetches the user name from the repository and updates the state accordingly.
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

