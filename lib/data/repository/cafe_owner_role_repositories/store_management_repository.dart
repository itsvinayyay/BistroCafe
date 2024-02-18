import 'dart:developer';


import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';



/// Repository responsible for managing and retrieving store management details.
class ManagementRepository {
  // Firestore instance used for database operations.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Updates the store management details based on the provided parameters.
  ///
  /// Parameters:
  /// - [storeID]: The identifier for the store.
  /// - [openingTime]: The updated opening time.
  /// - [closingTime]: The updated closing time.
  /// - [availibility]: The updated availability status.
  /// - [openingTimeModified]: Flag indicating if the opening time is modified.
  /// - [closingTimeModified]: Flag indicating if the closing time is modified.
  /// - [availibilityModified]: Flag indicating if the availability status is modified.
  Future<void> updateDetails({
    required String storeID,
    required TimeOfDay openingTime,
    required TimeOfDay closingTime,
    required bool availibility,
    required bool openingTimeModified,
    required bool closingTimeModified,
    required bool availibilityModified,
  }) async {
    try {
      // Reference to the document for the specified store.
      DocumentReference documentReference =
          _firestore.collection('groceryStores').doc(storeID);

      // Current date and time.
      DateTime currentDate = DateTime.now();

      // Update opening time if modified.
      if (openingTimeModified) {
        DateTime dateTime = DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day,
          openingTime.hour,
          openingTime.minute,
        );
        Timestamp timestamp = Timestamp.fromDate(dateTime);
        documentReference.update({
          'Timings.OpeningTime': timestamp,
        });
      }

      // Update closing time if modified.
      if (closingTimeModified) {
        DateTime dateTime = DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day,
          closingTime.hour,
          closingTime.minute,
        );
        Timestamp timestamp = Timestamp.fromDate(dateTime);
        documentReference.update({
          'Timings.ClosingTime': timestamp,
        });
      }

      // Update availability status if modified.
      if (availibilityModified) {
        documentReference.update(
          {
            'Availibility': availibility,
          },
        );
      }
    } catch (e) {
      // Log and rethrow any errors that occur during the update.
      log('Exception occurred while updating Store Management Details (Error from Management Repository)');
      rethrow;
    }
  }

  /// Retrieves the store timings and availability for a specified store.
  ///
  /// Parameters:
  /// - [storeID]: The identifier for the store.
  Future<Map<String, dynamic>> getTimings({required String storeID}) async {
    try {
      // Reference to the document for the specified store.
      DocumentReference documentReference =
          _firestore.collection('groceryStores').doc(storeID);

      // Get the document snapshot.
      DocumentSnapshot documentSnapshot = await documentReference.get();
      if (documentSnapshot.exists) {
        // Extract opening time from the document.
        Timestamp openingTime = (documentSnapshot.data()
            as Map<String, dynamic>)['Timings']['OpeningTime'];
        DateTime openingDateTime = openingTime.toDate();
        TimeOfDay openingTimeOfDay = TimeOfDay.fromDateTime(openingDateTime);

        // Extract closing time from the document.
        Timestamp closingTime = (documentSnapshot.data()
            as Map<String, dynamic>)['Timings']['ClosingTime'];
        DateTime closingDateTime = closingTime.toDate();
        TimeOfDay closingTimeOfDay = TimeOfDay.fromDateTime(closingDateTime);

        // Extract availability status from the document.
        bool isAvailable =
            (documentSnapshot.data() as Map<String, dynamic>)['Availibility'];

        // Create a map with the extracted data.
        Map<String, dynamic> management = Map<String, dynamic>();
        management['openingTime'] = openingTimeOfDay;
        management['closingTime'] = closingTimeOfDay;
        management['isAvailable'] = isAvailable;

        return management;
      } else {
        // Log and throw an exception if the document doesn't exist.
        log('Exception while retrieving Document (Error from Management Repository)');
        throw "Document Field does not exist";
      }
    } catch (e) {
      // Log and throw an exception if an error occurs during the process.
      log('Exception while retrieving Timings (Error from Management Repository)');
      throw e.toString();
    }
  }
}

