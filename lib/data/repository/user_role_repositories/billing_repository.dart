import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:food_cafe/data/models/store_order_model.dart';
import 'package:food_cafe/data/repository/common_repositories/get_formatted_date_repository.dart';

/// Repository class responsible for handling billing operations.
class BillingRepository {
  final _firestore = FirebaseFirestore.instance;
  final FormattedDate _formattedDate = FormattedDate();

  /// Retrieves the subtotal amount for a given personID and dine-in status.
  /// Throws an exception if there's an error during the retrieval process.
  Future<int> getSubTotalAmount(
      {required String personID, required bool isDineIn}) async {
    try {
      int subTotal = 0;

      // Reference to the 'cartitem' collection for the specified user
      final collectionRef = _firestore
          .collection('Users')
          .doc('SMVDU$personID')
          .collection('cartitem');

      // Fetching the documents from the 'cartitem' collection
      QuerySnapshot querySnapshot = await collectionRef.get();

      // Calculating the subtotal based on the items in the cart
      for (var docs in querySnapshot.docs) {
        int mrp = docs['Price'];
        int quantity = docs['Quantity'];
        subTotal += mrp * quantity;
      }

      return subTotal;
    } catch (e) {
      log("Exception while retrieving Sub Total Amount (Error from Billing Repository)");
      rethrow;
    }
  }

  /// Extracts the device token of the cafe owner associated with the given storeID.
  /// Throws an exception if there's an issue during the retrieval process.
  Future<String> extractCafeOwnerTokenID(String storeID) async {
    try {
      // Reference to the document for the specified grocery store
      final docRef = _firestore.collection('groceryStores').doc(storeID);

      // Fetching the document snapshot
      final snapshots = await docRef.get();
      String deviceToken = "";

      // Checking if the document exists and extracting the TokenID
      if (snapshots.exists) {
        deviceToken = snapshots.data()!['TokenID'];
      }

      return deviceToken;
    } catch (e) {
      log("Issue while fetching the Token ID of Cafe Owner (Error from Billing Repository)");
      rethrow;
    }
  }

  /// Handles the checkout process for a customer by creating and storing an order in the Firestore database.
  ///
  /// Parameters:
  ///   - customerName: The name of the customer placing the order.
  ///   - personID: The unique identifier for the customer.
  ///   - totalMRP: The total MRP (Maximum Retail Price) of the ordered items.
  ///   - isDineIn: A flag indicating whether the order is for dine-in.
  ///   - isCash: A flag indicating the payment method (cash or not).
  ///   - storeID: The identifier of the grocery store where the order is placed.
  ///   - hostelName: The name of the hostel associated with the customer.
  ///   - tokenID: The device token of the cafe owner associated with the store.
  ///
  /// Returns:
  ///   - A Future containing the order ID if the checkout is successful.
  ///   - Throws an exception if any error occurs during the checkout process.
  Future<String> billCheckOut({
    required String customerName,
    required String personID,
    required int totalMRP,
    required bool isDineIn,
    required bool isCash,
    required String storeID,
    required String hostelName,
    required String tokenID,
  }) async {
    try {
      // Fetching the list of ordered items
      List<Map<String, dynamic>> orderedItems = await _getOrders(personID);

      // Reading the order ID
      String? ordID = await _readOrderID(storeID);

      // Creating a timestamp for the order
      Timestamp mytimeStamp = Timestamp.now();

      // Creating an Orders_Model object for the requested order
      OrderModel requestedOrdersModel = OrderModel(
        orderID: ordID,
        customerName: customerName,
        entryNo: personID,
        totalMRP: totalMRP,
        orderItems: orderedItems,
        time: mytimeStamp,
        isDineIn: isDineIn,
        isCash: isCash,
        isPaid: isCash ? true : false,
        storeID: storeID,
        hostelName: hostelName,
        tokenID: tokenID,
        orderStatus: 'Requested',
        trxID:
            'Null', // Since it is Requested Orders Model, no Transaction ID is required.
      );

      // Storing the order in the Firestore database
      if (ordID != null) {
        await _firestore
            .collection('groceryStores')
            .doc(storeID)
            .collection('requestedOrders')
            .doc(ordID)
            .set(requestedOrdersModel.toJson());

        // Returning the order ID
        return ordID;
      } else {
        log("Order ID is NULL!");
        return ordID.toString();
      }
    } catch (e) {
      log("Exception thrown while checking out Items (Error from Billing Repository)");
      rethrow;
    }
  }

  Future<void> updateCart({required String personID}) async {
    try {
      CollectionReference collectionReference = _firestore
          .collection('Users')
          .doc('SMVDU$personID')
          .collection('carttem');
      QuerySnapshot querySnapshot = await collectionReference.get();

      for (var doc in querySnapshot.docs) {
        doc.reference.delete();
      }
      log('documents Deleted');
    } catch (e) {
      log("Exception thrown while updating User's Cart (Deleting all items from it) (Error from Billing Repository)");
      rethrow;
    }
  }

  /// Updates the daily analytics for a grocery store, specifically tracking the total number of items requested.
  ///
  /// Parameters:
  ///   - storeID: The identifier of the grocery store for which daily analytics are updated.
  ///
  /// Behavior:
  ///   - Retrieves the current date in a formatted string.
  ///   - Checks if there is an existing document for the current date in the 'dailyStats' collection.
  ///     - If not, creates a new document with initial values.
  ///     - If yes, increments the 'TotalItemsRequested' field by 1 in the existing document.
  ///
  /// Throws an exception if any error occurs during the update process.
  Future<void> updateDailyAnalytics({required String storeID}) async {
    try {
      // Get the current formatted date
      String formattedDate = _formattedDate.getCurrentDate();

      // Reference to the document for the specified grocery store and date
      DocumentReference documentReference = _firestore
          .collection('groceryStores')
          .doc(storeID)
          .collection('dailyStats')
          .doc(formattedDate);

      // Fetch the document snapshot
      DocumentSnapshot documentSnapshot = await documentReference.get();

      // Update or create the document based on existence
      if (!documentSnapshot.exists) {
        documentReference.set({
          'TotalItemsAccepted': 0,
          'TotalItemsRequested': 1,
          'TotalSale': 0
        });
      } else {
        documentReference.update({
          'TotalItemsRequested': FieldValue.increment(1),
        });
      }

      log("Daily Analytics Updated!");
    } catch (e) {
      log("Exception thrown while updating Daily Analytics (Error from Billing Repository)");
      rethrow;
    }
  }

  /// Updates the monthly analytics for a grocery store, specifically tracking the total number of items requested.
  ///
  /// Parameters:
  ///   - storeID: The identifier of the grocery store for which monthly analytics are updated.
  ///
  /// Behavior:
  ///   - Retrieves the current month in a formatted string.
  ///   - Checks if there is an existing document for the current month in the 'monthlyStats' collection.
  ///     - If not, creates a new document with initial values.
  ///     - If yes, increments the 'TotalItemsRequested' field by 1 in the existing document.
  ///
  /// Throws an exception if any error occurs during the update process.
  Future<void> updateMonthlyAnalytics({required String storeID}) async {
    try {
      // Get the current formatted month
      String formattedMonth = _formattedDate.getMonth();

      // Reference to the document for the specified grocery store and month
      DocumentReference documentReference = _firestore
          .collection('groceryStores')
          .doc(storeID)
          .collection('monthlyStats')
          .doc(formattedMonth);

      // Fetch the document snapshot
      DocumentSnapshot documentSnapshot = await documentReference.get();

      // Update or create the document based on existence
      if (!documentSnapshot.exists) {
        documentReference.set({
          'ProductsSold': [],
          'TotalItemsAccepted': 0,
          'TotalItemsRequested': 1,
          'TotalSales': 0
        });
      } else {
        documentReference.update({
          'TotalItemsRequested': FieldValue.increment(1),
        });
      }

      log("Monthly Analytics Updated!");
    } catch (e) {
      log("Exception thrown while updating Monthly Analytics (Error from Billing Repository)");
      rethrow;
    }
  }

  /// Reads and generates the next order ID for a grocery store based on the last recorded order ID.
  ///
  /// Parameters:
  ///   - storeID: The identifier of the grocery store for which the order ID is generated.
  ///
  /// Returns:
  ///   - A [String] representing the new order ID.
  ///
  /// Behavior:
  ///   - Fetches the document for the specified grocery store from the 'groceryStores' collection.
  ///   - Checks if the document exists.
  ///     - If yes, retrieves the last recorded order ID or defaults to "SMVDU101ORD0" if not available.
  ///     - Generates the next order ID using the [_generateNextOrderID] method.
  ///     - Updates the document with the new order ID as the 'LastORD_ID'.
  ///     - Returns the new order ID.
  ///     - If no, logs an error and returns null.
  ///
  /// Throws an exception if any error occurs during the process.
  Future<String?> _readOrderID(String storeID) async {
    try {
      // Reference to the document for the specified grocery store
      final docRef = _firestore.collection('groceryStores').doc(storeID);

      // Fetch the document snapshot
      final snapshots = await docRef.get();

      // Check if the document exists
      if (snapshots.exists) {
        // Retrieve the last recorded order ID or default to "SMVDU101ORD0"
        String? lastOrdID = await snapshots.data()!['LastORD_ID'];
        lastOrdID ??= "SMVDU101ORD0";

        // Generate the next order ID
        String newOrdID = _generateNextOrderID(lastOrdID);

        // Update the document with the new order ID
        await docRef.update({'LastORD_ID': newOrdID});

        // Return the new order ID
        return newOrdID;
      } else {
        // Log an error and return null if the document doesn't exist
        log("The last Transaction containing document doesn't exist!");
        return null;
      }
    } catch (e) {
      // Log an error and return null if an exception occurs
      log("Exception thrown while reading last Transaction ID!!! $e");
      return null;
    }
  }

  /// Generates the next order ID based on the given previous order ID.
  ///
  /// Parameters:
  ///   - previousOrderID: The last recorded order ID to be used as a base for generating the next one.
  ///
  /// Returns:
  ///   - A [String] representing the new order ID.
  ///
  /// Behavior:
  ///   - Splits the previous order ID into a prefix and a numeric part using 'ORD' as the separator.
  ///   - Converts the numeric part to an integer, increments it by 1, and formats it with leading zeros.
  ///   - Creates the new order ID by combining the prefix and the incremented numeric part with 'ORD'.
  ///
  /// Throws an exception if there's an issue with the format or parsing during the process.
  String _generateNextOrderID(String previousOrderID) {
    // Split the previous transaction ID
    List<String> parts = previousOrderID.split('ORD');
    if (parts.length != 2) {
      // Handle invalid input
      log("Error with the previous Order ID");
    }

    String prefix = parts[0]; // e.g., "SMVDU101"
    String numericPart = parts[1]; // e.g., "1"

    // Convert the numeric part to an integer and increment it
    int? numericValue = int.tryParse(numericPart);
    if (numericValue == null) {
      // Handle invalid input
      log("Error while parsing numeric part of the Last Order ID!!! (Error from Billing Repository)");
    }

    // Increment the numeric value
    numericValue = numericValue! + 1;

    // Format the numeric part with leading zeros (if needed)
    String incrementedNumericPart = numericValue.toString();

    // Create the new transaction ID
    String newOrderID = '${prefix}ORD$incrementedNumericPart';

    return newOrderID;
  }

  /// Retrieves the list of orders from the user's cart based on the provided person ID.
  ///
  /// Parameters:
  ///   - personID: The unique identifier associated with the user.
  ///
  /// Returns:
  ///   - A [Future] that resolves to a [List] of [Map]s representing the orders in the user's cart.
  ///
  /// Behavior:
  ///   - Queries the Firestore database to fetch the orders stored in the specified user's cart.
  ///   - Constructs a list of [Map]s, where each map represents the data of an individual order.
  ///   - Returns the list of orders.
  ///
  /// Throws an exception if there's an issue during the retrieval process, logging an error message.
  Future<List<Map<String, dynamic>>> _getOrders(String personID) async {
    try {
      // Initialize an empty list to store the retrieved orders
      List<Map<String, dynamic>> returnedList = [];

      // Query Firestore to fetch orders from the user's cart
      final querySnapShot = await _firestore
          .collection('Users')
          .doc('SMVDU$personID')
          .collection('cartitem')
          .get();

      // Iterate through each document in the query snapshot and add its data to the list
      for (var doc in querySnapShot.docs) {
        returnedList.add(doc.data());
      }

      for (var doc in querySnapShot.docs) {
        doc.reference.delete();
      }

      // Return the list of orders
      return returnedList;
    } catch (e) {
      // Log an error and return an empty list if there's an exception during the retrieval process
      log("Error fetching booked Orders from User's Cart (Error from Billing Repository): $e");
      return [];
    }
  }
}
