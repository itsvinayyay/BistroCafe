import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/cafe_owner_role_cubits/store_analytics_cubit/store_analytics_states.dart';
import 'package:food_cafe/data/models/store_analytics_model.dart';
import 'package:food_cafe/data/repository/cafe_owner_role_repositories/store_analytics_repository.dart';
import 'package:food_cafe/data/services/connectivity_service.dart';

/// Cubit responsible for managing the state related to analytics data in the application.
class AnalyticsCubit extends Cubit<AnalyticsStates> {
  AnalyticsCubit() : super(AnalyticsInitialState());

  final AnalyticsRepository _analyticsRepository = AnalyticsRepository();

  /// Asynchronous method to load analytics data based on the provided store ID.
  /// Emits different states based on the loading process and results.
  Future<void> loadAnalytics({required String storeID}) async {
    emit(AnalyticsLoadingState()); // Emitting loading state initially.

    try {
      // Checking internet connectivity using the provided function.
      await checkConnectivityForCubits(
        onDisconnected: () {
          emit(
            AnalyticsErrorState(
              error: 'internetError',
            ),
          );
        },
        onConnected: () async {
          // Fetching daily and monthly analytics data from the repository.
          DailyStatsModel dailyAnalytics =
              await _analyticsRepository.loadDailyStats(storeID: storeID);
          MonthlyStatsModel monthlyAnalytics =
              await _analyticsRepository.loadMonthlyStats(storeID: storeID);

          // Emitting loaded state with the fetched analytics data.
          emit(
            AnalyticsLoadedState(
              dailyAnalytics: dailyAnalytics,
              monthlyAnalytics: monthlyAnalytics,
            ),
          );
        },
      );
    } catch (e) {
      log("Error while loading Analytics (Error from Analytics Cubit)");

      // Emitting error state with the specific error message.
      emit(
        AnalyticsErrorState(
          error: e.toString(),
        ),
      );
    }
  }
}

