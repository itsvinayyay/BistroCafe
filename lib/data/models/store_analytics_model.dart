import 'package:food_cafe/data/models/store_product_analytics_model.dart';

class DailyStatsModel {
  int? totalItemsAccepted;
  int? totalItemsRequested;
  int? totalAmountSold;

  DailyStatsModel(
      {this.totalItemsAccepted,
      this.totalItemsRequested,
      this.totalAmountSold});

  DailyStatsModel.empty() {
    totalAmountSold = 0;
    totalItemsRequested = 0;
    totalItemsAccepted = 0;
  }

  DailyStatsModel.fromJson(Map<String, dynamic> json) {
    totalItemsAccepted = json['TotalItemsAccepted'];
    totalItemsRequested = json['TotalItemsRequested'];
    totalAmountSold = json['TotalSale'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalItemsAccepted'] = totalItemsAccepted;
    data['totalItemsRequested'] = totalItemsRequested;
    data['totalAmountSold'] = totalAmountSold;
    return data;
  }
}

class MonthlyStatsModel {
  int? totalItemsAccepted;
  int? totalItemsRequested;
  int? totalAmountSold;
  List<ProductAnalysisModel>? itemsSold;

  MonthlyStatsModel(
      {this.totalItemsAccepted,
      this.totalItemsRequested,
      this.totalAmountSold,
      this.itemsSold});

  MonthlyStatsModel.loadMonthlyAnalyticsOnly(
      {required Map<String, dynamic> firebaseData}) {
    totalItemsAccepted = firebaseData['TotalItemsAccepted'];
    totalItemsRequested = firebaseData['TotalItemsRequested'];
    totalAmountSold = firebaseData['TotalSales'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalItemsAccepted'] = totalItemsAccepted;
    data['totalItemsRequested'] = totalItemsRequested;
    data['totalAmountSold'] = totalAmountSold;
    return data;
  }
}
