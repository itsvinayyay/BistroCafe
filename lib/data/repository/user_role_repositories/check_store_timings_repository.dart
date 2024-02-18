import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Repository responsible for checking the validity of store timings.
class CheckStoreTimingsRepository {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Checks if the store timings are valid and available.
  ///
  /// Returns a [Map] with keys 'isAvailable' and 'isTimeValid'.
  Future<Map<String, bool>> isTimeValid({required String storeID}) async {
    try {
      // Reference to the document in the 'groceryStores' collection.
      DocumentReference documentReference =
          _firestore.collection('groceryStores').doc(storeID);

      // Retrieve document snapshot.
      DocumentSnapshot documentSnapshot = await documentReference.get();

      if (documentSnapshot.exists) {
        // Extract data from the document.
        Map<String, dynamic> docData =
            documentSnapshot.data() as Map<String, dynamic>;

        // Retrieve availability status.
        bool isAvailable = docData['Availibility'];

        // Retrieve opening and closing timestamps.
        Timestamp openingTimestamp = docData['Timings']['OpeningTime'];
        Timestamp closingTimestamp = docData['Timings']['ClosingTime'];

        // Convert timestamps to TimeOfDay.
        TimeOfDay openingTime = _getTimeOfDay(timestamp: openingTimestamp);
        TimeOfDay closingTime = _getTimeOfDay(timestamp: closingTimestamp);

        // Check if the current time is within the opening and closing times.
        bool isTimeValid = _checkIfTimeValid(
            openingTime: openingTime, closingTime: closingTime);

        // Create and return the result map.
        Map<String, bool> tobeReturned = {
          'isAvailable': isAvailable,
          'isTimeValid': isTimeValid
        };
        return tobeReturned;
      } else {
        // Log an error and throw an exception if the document is not found.
        log("No Document found! (Error from Check Store Timings Repository)");
        throw 'Document Not Found to retrieve Timings from!';
      }
    } catch (e) {
      // Log an error and rethrow the exception.
      log("Exception while retrieving store Timings (Error from Check Store Timings Repository)");
      rethrow;
    }
  }

  /// Checks if the current time is within the specified range of opening and closing times.
  ///
  /// Returns `true` if the current time is within the range, `false` otherwise.
  bool _checkIfTimeValid(
      {required TimeOfDay openingTime, required TimeOfDay closingTime}) {
    // Get the current time.
    TimeOfDay currentTime = TimeOfDay.now();

    // Convert TimeOfDay values to doubles for comparison.
    double currentDouble = _toDouble(currentTime);
    double openingDouble = _toDouble(openingTime);
    double closingDouble = _toDouble(closingTime);

    // Check if the current time is within the specified range.
    return (currentDouble >= openingDouble) && (currentDouble < closingDouble);
  }

  /// Converts a [Timestamp] to a [TimeOfDay] object.
  ///
  /// Returns a [TimeOfDay] object representing the time component of the given [Timestamp].
  TimeOfDay _getTimeOfDay({required Timestamp timestamp}) {
    // Convert Timestamp to DateTime.
    DateTime dateTime = timestamp.toDate();

    // Create a TimeOfDay object from the DateTime.
    return TimeOfDay.fromDateTime(dateTime);
  }

  /// Converts a [TimeOfDay] object to a double for easier comparison.
  ///
  /// The resulting double represents the time in hours, with fractional parts
  /// indicating minutes.
  double _toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;
}
