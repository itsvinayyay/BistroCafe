import 'package:food_cafe/data/models/store_analytics_model.dart';

/// Abstract class representing the different states for the Analytics feature.
abstract class AnalyticsStates {}

/// Initial state indicating the start of the Analytics feature.
class AnalyticsInitialState extends AnalyticsStates {}

/// Loaded state indicating the successful retrieval of daily and monthly analytics.
class AnalyticsLoadedState extends AnalyticsStates {
  final DailyStatsModel dailyAnalytics;
  final MonthlyStatsModel monthlyAnalytics;

  // Constructs an instance of AnalyticsLoadedState with required parameters.
  AnalyticsLoadedState({
    required this.dailyAnalytics,
    required this.monthlyAnalytics,
  });
}

/// Loading state indicating that the Analytics feature is currently fetching data.
class AnalyticsLoadingState extends AnalyticsStates {}

/// Error state indicating an issue or failure in the Analytics feature, accompanied by an error message.
class AnalyticsErrorState extends AnalyticsStates {
  final String error;

  // Constructs an instance of AnalyticsErrorState with the provided error message.
  AnalyticsErrorState({required this.error});
}
