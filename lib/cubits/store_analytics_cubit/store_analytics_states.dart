import 'package:food_cafe/data/models/store_analytics_model.dart';

abstract class AnalyticsStates {}

class AnalyticsInitialState extends AnalyticsStates {}

class AnalyticsLoadedState extends AnalyticsStates {
  final DailyStatsModel dailyAnalytics;
  final MonthlyStatsModel monthlyAnalytics;
  AnalyticsLoadedState(
      {required this.dailyAnalytics, required this.monthlyAnalytics});
}

class AnalyticsLoadingState extends AnalyticsStates {}

class AnalyticsErrorState extends AnalyticsStates {
  final String error;
  AnalyticsErrorState({required this.error});
}
