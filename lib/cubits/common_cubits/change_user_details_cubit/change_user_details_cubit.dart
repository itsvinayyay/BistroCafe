import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/common_cubits/change_user_details_cubit/change_user_details_states.dart';
import 'package:food_cafe/data/repository/common_repositories/change_user_details_repository.dart';

/// Cubit responsible for managing the state of changing user details.
class ChangeUserDetailsCubit extends Cubit<ChangeUserDetailsStates> {
  // Initialize the cubit with the initial state.
  ChangeUserDetailsCubit() : super(UserDetailsInitialState());

  // Repository for handling user details changes.
  final ChangeUserDetailsRepository _changeUserDetailsRepository =
      ChangeUserDetailsRepository();

  /// Initiates the process of changing user details.
  ///
  /// Parameters:
  /// - [name]: The updated name for the user.
  /// - [personID]: The unique identifier for the user.
  /// - [isCafeOwner]: Flag indicating if the user is a cafe owner.
  Future<void> initiateChange({
    required String name,
    required String personID,
    required bool isCafeOwner,
  }) async {
    // Emit loading state to indicate the start of the process.
    emit(UserDetailsLoadingState());
    try {
      // Change details based on user type.
      if (isCafeOwner) {
        await _changeUserDetailsRepository.changeCafeOwnerDetails(
            name: name, personID: personID);
      } else {
        log('executing for User!');
        await _changeUserDetailsRepository.changeUserDetails(
            name: name, personID: personID);
      }

      // Emit loaded state to indicate the successful update.
      emit(UserDetailsLoadedState());
    } catch (e) {
      // Handle exceptions and emit an error state.
      log("Exception while Changing the User Details (Error from Change user Details Cubit)");
      emit(UserDetailsErrorState(e.toString()));
    }
  }
}

