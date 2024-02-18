import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_cafe/data/models/store_analytics_model.dart';
import 'package:food_cafe/data/models/store_product_analytics_model.dart';



///Repository to retrieve both Dialy and Monthly Analytics
class AnalyticsRepository {
  final _firestore = FirebaseFirestore.instance;

  /// Asynchronously loads the daily analytics data for a specified grocery store from Firestore.
  /// Returns a [DailyStatsModel] containing the retrieved data or an empty model if the document does not exist.
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

  /// Asynchronously loads the monthly analytics data for a specified grocery store from Firestore.
  /// Returns a [MonthlyStatsModel] containing the retrieved data or an empty model if the document does not exist.
  Future<MonthlyStatsModel> loadMonthlyStats({required String storeID}) async {
    try {
      // Get the current date
      DateTime currentDate = DateTime.now();
      String currentMonth =
          "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}";

      // Create a reference to the monthlyStats document for the current month
      DocumentReference documentReference = _firestore
          .collection('groceryStores')
          .doc(storeID)
          .collection('monthlyStats')
          .doc(currentMonth);

      // Retrieve data from Firestore
      DocumentSnapshot retrievedData = await documentReference.get();

      if (retrievedData.exists) {
        // Document exists, parse data into MonthlyStatsModel
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

          generatedList = await _getTop5MonthlyProductDetails(
              top5Products: top5Entries, storeID: storeID);
        } else {
          log('No Map as ProductsSold in Firestore!');
        }
        monthlyStatsModel.itemsSold = generatedList;

        return monthlyStatsModel;
      } else {
        // Document does not exist, log and return an empty MonthlyStatsModel
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
      // Handle any errors that occur during the process
      log("Error thrown while fetching the Monthly Stats (Error from Analytics Repository)");
      rethrow;
    }
  }

  /// Retrieves the top 5 products based on their sales quantity from a given monthly products map.
  /// Returns a list of map entries containing product IDs and their corresponding sales quantity.
  Future<List<MapEntry<String, dynamic>>> _getTop5MonthlyProducts({
    required Map<String, dynamic> monthlyProductsSold,
  }) async {
    // Convert the monthlyProductsSold map entries to a list and sort it in descending order based on sales quantity
    List<MapEntry<String, dynamic>> descProductList =
        monthlyProductsSold.entries.toList();
    descProductList.sort((a, b) => b.value.compareTo(a.value));

    // Log the top 5 products
    log(descProductList.take(5).toString());

    // Return the top 5 products as a list
    return descProductList.take(5).toList();
  }

  /// Retrieves detailed product analysis for the top 5 products based on their sales quantity.
  /// Returns a list of ProductAnalysisModel instances containing information about each product.
  Future<List<ProductAnalysisModel>> _getTop5MonthlyProductDetails({
    required List<MapEntry<String, dynamic>> top5Products,
    required String storeID,
  }) async {
    try {
      // List to store detailed product analysis
      List<ProductAnalysisModel> detailedProductAnalysisList = [];

      // Fetch details for each of the top 5 products in parallel
      await Future.wait(
        top5Products.map((entry) async {
          // Extract product ID and sales quantity from the map entry
          String itemID = entry.key;
          int numbersSold = entry.value;

          // Retrieve product details from Firestore
          DocumentSnapshot retrievedProduct = await _firestore
              .collection('groceryStores')
              .doc(storeID)
              .collection('menuItems')
              .doc(itemID)
              .get();

          // Check if the product exists in the menuItems collection
          if (retrievedProduct.exists) {
            Map<String, dynamic> retrievedData =
                retrievedProduct.data() as Map<String, dynamic>;

            // Create a ProductAnalysisModel instance using retrieved data
            ProductAnalysisModel productAnalysisModel =
                ProductAnalysisModel.fromFireStore(
              firestoreData: retrievedData,
              itemID: itemID,
              numbersSold: numbersSold,
            );

            // Add the detailed product analysis to the list
            detailedProductAnalysisList.add(productAnalysisModel);
          } else {
            // Add an empty ProductAnalysisModel if the product is not found
            detailedProductAnalysisList.add(
              ProductAnalysisModel.empty(
                  itemID: itemID, numbersSold: numbersSold),
            );
          }
        }),
      );

      // Sort the detailed product analysis list in descending order based on sales quantity
      detailedProductAnalysisList.sort(
        (a, b) => b.numbersSold!.compareTo(a.numbersSold!),
      );

      // Return the list of detailed product analysis
      return detailedProductAnalysisList;
    } catch (e) {
      // Handle any errors that occur during the process
      log("Exception thrown while retrieving every product details (Error from Store Analytics Repository)");
      rethrow;
    }
  }
}
