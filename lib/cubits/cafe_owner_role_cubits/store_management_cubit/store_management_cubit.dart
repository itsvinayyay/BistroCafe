import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_management_cubit/store_management_states.dart';
import 'package:food_cafe/data/repository/cafe_owner_role_repositories/store_management_repository.dart';



/// Cubit responsible for managing the state of store management details.
class ManagementCubit extends Cubit<ManagementStates> {
  // Initialize the cubit with the initial state.
  ManagementCubit() : super(ManagementInitialState());

  // Repository for handling store management details.
  final ManagementRepository _managementRepository = ManagementRepository();

  /// Initiates the process of changing store management details.
  ///
  /// Parameters:
  /// - [storeID]: The identifier for the store.
  /// - [openingTime]: The updated opening time.
  /// - [closingTime]: The updated closing time.
  /// - [availibility]: The updated availability status.
  /// - [openingTimeModified]: Flag indicating if the opening time is modified.
  /// - [closingTimeModified]: Flag indicating if the closing time is modified.
  /// - [availibilityModified]: Flag indicating if the availability status is modified.
  Future<void> initiateDetailsChange({
    required String storeID,
    required TimeOfDay openingTime,
    required TimeOfDay closingTime,
    required bool availibility,
    required bool openingTimeModified,
    required bool closingTimeModified,
    required bool availibilityModified,
  }) async {
    try {
      // Emit the initial state to update the UI.
      emit(ManagementInitialState());

      // Update store management details through the repository.
      _managementRepository.updateDetails(
        storeID: storeID,
        openingTime: openingTime,
        closingTime: closingTime,
        availibility: availibility,
        openingTimeModified: openingTimeModified,
        closingTimeModified: closingTimeModified,
        availibilityModified: availibilityModified,
      );

      // Emit the loaded state to indicate the successful update.
      emit(ManagementLoadedState());
    } catch (e) {
      // Handle exceptions and emit an error state.
      log('Exception occurred while updating Store Management Details (Error from Management Cubit)');
      emit(ManagementErrorState(error: e.toString()));
    }
  }
}



/// Cubit responsible for managing the opening time.
class OpeningTimeCubit extends Cubit<TimeOfDay> {
  /// Constructor initializes the cubit with the current time.
  OpeningTimeCubit() : super(TimeOfDay.now());

  /// Updates the opening time with the provided [updatedTime].
  void updateTime(TimeOfDay updatedTime) {
    emit(updatedTime);
  }
}

/// Cubit responsible for managing the closing time.
class ClosingTimeCubit extends Cubit<TimeOfDay> {
  /// Constructor initializes the cubit with the current time.
  ClosingTimeCubit() : super(TimeOfDay.now());

  /// Updates the closing time with the provided [updatedTime].
  void updateTime(TimeOfDay updatedTime) {
    emit(updatedTime);
  }
}

/// Cubit responsible for managing the availability status.
class AvailibilityCubit extends Cubit<bool> {
  /// Constructor initializes the cubit with 'false', indicating unavailability.
  AvailibilityCubit() : super(false);

  /// Updates the availability status with the provided [updatedAvailability].
  void updateAvailability(bool updatedAvailability) {
    emit(updatedAvailability);
  }
}

