import 'dart:developer';

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
    this.totalAmountSold = 0;
    this.totalItemsRequested = 0;
    this.totalItemsAccepted = 0;
  }

  DailyStatsModel.fromJson(Map<String, dynamic> json) {
    totalItemsAccepted = json['TotalItemsAccepted'];
    totalItemsRequested = json['TotalItemsRequested'];
    totalAmountSold = json['TotalSale'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalItemsAccepted'] = this.totalItemsAccepted;
    data['totalItemsRequested'] = this.totalItemsRequested;
    data['totalAmountSold'] = this.totalAmountSold;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalItemsAccepted'] = this.totalItemsAccepted;
    data['totalItemsRequested'] = this.totalItemsRequested;
    data['totalAmountSold'] = this.totalAmountSold;
    return data;
  }
}
