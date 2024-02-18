import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/user_role_cubits/check_store_timings_cubit/check_timings_states.dart';
import 'package:food_cafe/data/repository/user_role_repositories/check_store_timings_repository.dart';

/// A [Cubit] to check and validate store timings before initiating an order.
///
/// This [CheckTimingsCubit] extends [Cubit<CheckTimingsStates>] and is initialized with
/// an initial state of [CheckTimingsInitialState]. It provides a method [initiateTimeCheck]
/// to check if the store is available and if the current time is within the valid business hours.
class CheckTimingsCubit extends Cubit<CheckTimingsStates> {

  // Constructor for [CheckTimingsCubit].
  // Initializes the [CheckTimingsCubit] with an initial state of [CheckTimingsInitialState].
  CheckTimingsCubit() : super(CheckTimingsInitialState());

  // Repository for checking store timings.
  final CheckStoreTimingsRepository _checkStoreTimingsRepository =
      CheckStoreTimingsRepository();


  /// Initiates the time check to validate store availability and business hours.
  ///
  /// This method triggers the time check process using the [CheckStoreTimingsRepository].
  /// It emits different states based on the results:
  /// - If the store is not available, it emits an [CheckTimingsErrorState] with appropriate messages.
  /// - If the current time is not within the valid business hours, it emits an [CheckTimingsErrorState]
  ///   with a message indicating that the time is not in the business hour range.
  /// - If both conditions are satisfied, it emits a [CheckTimingsLoadedState] indicating that the
  ///   store timings are valid.
  ///
  /// Parameters:
  /// - [storeID]: The unique identifier for the store.
  Future<void> initiateTimeCheck({required String storeID}) async {
    emit(CheckTimingsLoadingState());

    try {
      // Fetching information about store timings from the repository.
      Map<String, bool> map =
          await _checkStoreTimingsRepository.isTimeValid(storeID: storeID);

      // Extracting information from the result map.
      bool isAvailable = map['isAvailable']!;
      bool isTimeValid = map['isTimeValid']!;

      // Checking and emitting appropriate states based on the results.
      if (!isAvailable) {
        emit(CheckTimingsErrorState(
            heading: 'Cafe Not Accepting Orders',
            subHeading:
                "The Cafe from which you're ordering your food is currently not accepting orders!"));
      } else if (!isTimeValid) {
        emit(CheckTimingsErrorState(
            heading: 'Not in Business Hour Range!',
            subHeading: 'Current Timing is not in Business hour range'));
      } else {
        emit(CheckTimingsLoadedState());
      }
    } catch (e) {
      // Logging and emitting an error state in case of an exception.
      log("Exception while retrieving store Timings (Error from Check Store Timings Cubit)");
      emit(CheckTimingsErrorState(heading: 'Error', subHeading: e.toString()));
    }
  }
}

