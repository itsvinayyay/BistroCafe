import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_cafe/data/services/notification_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CafeOwnerNotifications {
  //Method to only check if the tokenID is there in Firestore and is not to update the device's token ID!
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

  Future<bool> _loadInitialCheckStatus() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool('cafeOwnerTokenCheck') ?? false;
  }

  Future<void> _saveInitialChecksStatus() async {
    final pref = await SharedPreferences.getInstance();
    pref.setBool('cafeOwnerTokenCheck', true);
  }

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
          documentReference.update({'TokenID': currentTokenID});
        } else {
          if (storedTokenID != currentTokenID) {
            documentReference.update({'TokenID': currentTokenID});
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
