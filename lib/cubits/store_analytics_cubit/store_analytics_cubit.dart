import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/store_analytics_cubit/store_analytics_states.dart';
import 'package:food_cafe/data/models/store_analytics_model.dart';
import 'package:food_cafe/data/repository/store_repositories/store_analytics_repository.dart';

class AnalyticsCubit extends Cubit<AnalyticsStates> {
  AnalyticsCubit() : super(AnalyticsInitialState());

  AnalyticsRepository _analyticsRepository = AnalyticsRepository();

  Future<void> loadAnalytics({required String storeID}) async {
    emit(AnalyticsLoadingState());
    try {
      DailyStatsModel dailyAnalytics =
          await _analyticsRepository.loadDailyStats(storeID: storeID);
      MonthlyStatsModel monthlyAnalytics =
          await _analyticsRepository.loadMonthlyStats(storeID: storeID);

      emit(
        AnalyticsLoadedState(
            dailyAnalytics: dailyAnalytics, monthlyAnalytics: monthlyAnalytics),
      );
    } catch (e) {
      log("Error while loading Analytics (Error from Analytics Cubit)");
      emit(
        AnalyticsErrorState(
          error: e.toString(),
        ),
      );
    }
  }
}
