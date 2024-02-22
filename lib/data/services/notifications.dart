import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_cafe/data/services/notification_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Class responsible for handling initial notification actions for a cafe owner.
class CafeOwnerNotifications {
  /// Method to perform initial notification actions based on the store ID.
  ///
  /// This method checks if initial checks have been done by retrieving a boolean
  /// value from SharedPreferences. If initial checks are not done, it performs
  /// checks on the Firestore document associated with the store ID, updates the
  /// TokenID if necessary, and saves the initial check status.
  ///
  /// Parameters:
  /// - `storeID`: The unique identifier for the grocery store.
  void initialNotificationActions(String storeID) async {
    log("Checking InitialCheckStatus boolean value...");
    final bool isInitialChecksDone = await _loadInitialCheckStatus();
    log("Initial Check Status for Notification Actions is $isInitialChecksDone");
    if (!isInitialChecksDone) {
      log("Performing Initial Checks...");
      await _performInitialChecks(storeID);

      log('Performed Initial Checks');

      log("Saving InitialCheckStatus...");
      await _saveInitialChecksStatus();
      log('Initial Check completed and is saved!');
    }
  }

  /// Load the initial check status from SharedPreferences.
  ///
  /// Returns:
  /// - A Future<bool> representing the initial check status.
  Future<bool> _loadInitialCheckStatus() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool('cafeOwnerTokenCheck') ?? false;
  }

  /// Save the initial check status to SharedPreferences.
  Future<void> _saveInitialChecksStatus() async {
    final pref = await SharedPreferences.getInstance();
    pref.setBool('cafeOwnerTokenCheck', true);
  }

  /// Perform initial checks for the specified store ID.
  ///
  /// This method retrieves the current device token, checks the Firestore document
  /// associated with the store ID, and updates the TokenID if necessary.
  ///
  /// Parameters:
  /// - `storeID`: The unique identifier for the grocery store.
  Future<void> _performInitialChecks(String storeID) async {
    NotificationServices notificationServices = NotificationServices();
    try {
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('groceryStores').doc(storeID);
      DocumentSnapshot documentSnapshot = await documentReference.get();
      if (documentSnapshot.exists) {
        String currentTokenID = await notificationServices.getDeviceToken();
        Object? data = documentSnapshot.data();
        String? storedTokenID = (data as Map<String, dynamic>)['TokenID'];

        if (storedTokenID == null) {
          await documentReference.update({'TokenID': currentTokenID});
        } else {
          if (storedTokenID != currentTokenID) {
           await documentReference.update({'TokenID': currentTokenID});
          }
        }
      } else {
        log("No Document is Created for the Grocery Store with Store ID as $storeID");
      }
    } catch (e) {
      log("Exception occured in updating/retrieving Store ID (Error from Initial Notification Actions)  => $e");
    }
  }
}
