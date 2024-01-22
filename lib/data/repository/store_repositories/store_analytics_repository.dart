import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_cafe/data/models/store_analytics_model.dart';
import 'package:food_cafe/data/models/store_product_analytics_model.dart';

class AnalyticsRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<DailyStatsModel> loadDailyStats({required String storeID}) async {
    try {
      // Get the current date
      DateTime currentDate = DateTime.now();
      String formattedDate =
          "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";

      // Create a reference to the dailyStats document for the current date
      DocumentReference documentReference = _firestore
          .collection('groceryStores')
          .doc(storeID)
          .collection('dailyStats')
          .doc(formattedDate);

      // Retrieve data from Firestore
      DocumentSnapshot retrievedData = await documentReference.get();

      // Check if the document exists
      if (retrievedData.exists) {
        // Document exists, parse data into DailyStatsModel
        Map<String, dynamic> docs =
            retrievedData.data() as Map<String, dynamic>;
        DailyStatsModel dailyAnalyticsModel = DailyStatsModel.fromJson(docs);
        return dailyAnalyticsModel;
      } else {
        // Document does not exist, log and return an empty DailyStatsModel
        log("The Daily Stats Document does not exist in Backend!");
        DailyStatsModel dailyAnalyticsModel = DailyStatsModel.empty();
        return dailyAnalyticsModel;
      }
    } catch (e) {
      // Handle any errors that occur during the process
      log("Error thrown while fetching the Daily Stats (Error from Analytics Repository)");
      rethrow;
    }
  }

  Future<MonthlyStatsModel> loadMonthlyStats({required String storeID}) async {
    try {
      DateTime currentData = DateTime.now();
      String currentMonth =
          "${currentData.year}-${currentData.month.toString().padLeft(2, '0')}";
      DocumentReference documentReference = _firestore
          .collection('groceryStores')
          .doc(storeID)
          .collection('monthlyStats')
          .doc(currentMonth);
      DocumentSnapshot retrievedData = await documentReference.get();

      if (retrievedData.exists) {
        Map<String, dynamic> firebaseData =
            retrievedData.data() as Map<String, dynamic>;
        MonthlyStatsModel monthlyStatsModel =
            MonthlyStatsModel.loadMonthlyAnalyticsOnly(
                firebaseData: firebaseData);

        List<ProductAnalysisModel> generatedList = [];

        if (firebaseData.containsKey('ProductsSold')) {
          Map<String, dynamic> productsSoldMap =
              firebaseData['ProductsSold'] as Map<String, dynamic>;

          // Take the top 5 entries
          List<MapEntry<String, dynamic>> top5Entries =
              await _getTop5MonthlyProducts(
                  monthlyProductsSold: productsSoldMap);

          // Create ItemStats models for the top 5 entries
          // generatedList = await Future.wait(top5Entries.map((entry) async {
          //   String itemId = entry.key;
          //   int numbersSold = entry.value;

          //   ProductAnalysisModel item =
          //       ProductAnalysisModel(itemID: itemId, numbersSold: numbersSold);

          //   DocumentSnapshot menuItem = await _firestore
          //       .collection('groceryStores')
          //       .doc(storeID)
          //       .collection('menuItems')
          //       .doc(item.itemID)
          //       .get();

          //   if (menuItem.exists) {
          //     item.itemName = menuItem['Name'];
          //     item.imageUrl = menuItem['ImageURL'];
          //     item.category = menuItem['Category'];
          //     item.price = menuItem['Price'];
          //   } else {
          //     item.itemName = "ItemDeleted";
          //     item.imageUrl =
          //         "https://cdn3.vectorstock.com/i/1000x1000/35/52/placeholder-rgb-color-icon-vector-32173552.jpg";
          //     item.category = "Item Deleted";
          //     item.price = 0;
          //   }

          //   return item;
          // }).toList());

          generatedList = await _getTop5MonthlyProductDetails(
              top5Products: top5Entries, storeID: storeID);
        } else {
          log('No Map as ProductsSold in Firestore!');
        }
        monthlyStatsModel.itemsSold = generatedList;

        return monthlyStatsModel;
      } else {
        log("The MonthlyStats Document does not exist in Backend!");
        MonthlyStatsModel monthlyStatsModel = MonthlyStatsModel(
          itemsSold: [],
          totalItemsAccepted: 0,
          totalItemsRequested: 0,
          totalAmountSold: 0,
        );
        return monthlyStatsModel;
      }
    } catch (e) {
      log("Error thrown while fetching the Monthly Stats (Error from Analytics Repository)");
      rethrow;
    }
  }

  Future<List<MapEntry<String, dynamic>>> _getTop5MonthlyProducts(
      {required Map<String, dynamic> monthlyProductsSold}) async {
    List<MapEntry<String, dynamic>> descProductList =
        monthlyProductsSold.entries.toList();
    descProductList.sort((a, b) => b.value.compareTo(a.value));
    log(descProductList.take(5).toString());

    return descProductList.take(5).toList();
  }

  Future<List<ProductAnalysisModel>> _getTop5MonthlyProductDetails(
      {required List<MapEntry<String, dynamic>> top5Products,
      required String storeID}) async {
    try {
      List<ProductAnalysisModel> detailedProductAnalysisList = [];
      await Future.wait(
        top5Products.map((entry) async {
          String itemID = entry.key;
          int numbersSold = entry.value;

          DocumentSnapshot retrievedProduct = await _firestore
              .collection('groceryStores')
              .doc(storeID)
              .collection('menuItems')
              .doc(itemID)
              .get();

          if (retrievedProduct.exists) {
            Map<String, dynamic> retrievedData =
                retrievedProduct.data() as Map<String, dynamic>;
            ProductAnalysisModel productAnalysisModel =
                ProductAnalysisModel.fromFireStore(
                    firestoreData: retrievedData,
                    itemID: itemID,
                    numbersSold: numbersSold);
            detailedProductAnalysisList.add(productAnalysisModel);
          } else {
            detailedProductAnalysisList.add(ProductAnalysisModel.empty(
                itemID: itemID, numbersSold: numbersSold));
          }
        }),
      );
      detailedProductAnalysisList
          .sort((a, b) => b.numbersSold!.compareTo(a.numbersSold!));
      return detailedProductAnalysisList;
    } catch (e) {
      log("Exception thrown while retrieveing every product Details (Error from Store Analytics Repository)");
      rethrow;
    }
  }
}
