import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_cafe/data/services/notification_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class cafeOwner_Notifications {

  //Method to only check if the tokenID is there in Firestore and is not to update the device's token ID!
  void initialNotifications_Action(String storeID) async {
    print("Checking InitialCheckStatus boolean value...");
    final bool isInitialchecksDone = await _loadInitialCheckStatus();

    print("Initial Check Status is $isInitialchecksDone");
    if (!isInitialchecksDone) {
      print("Performing Initial Checks...");
      await _performInitialChecks(storeID);

      print("Performing Save for InitialCheckStatus...");
      await _saveInitialChecksStatus();
    }

  }


  Future<bool> _loadInitialCheckStatus() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool('cafeOwnerTokenCheck') ?? false;
  }

  Future<void> _saveInitialChecksStatus() async{
    final pref = await SharedPreferences.getInstance();
    pref.setBool('cafeOwnerTokenCheck', true);
  }

  Future<void> _performInitialChecks(String storeID) async {
    try{
      final docRef =
          FirebaseFirestore.instance.collection('groceryStores').doc(storeID);
      final snapShotRef = await docRef.get();
      if (snapShotRef.exists) {
        late String currentTokenID;
        NotificationServices notificationServices = NotificationServices();
        currentTokenID = await notificationServices.getDeviceToken();
        final data = snapShotRef.data();
        String? storedTokenID = data!['TokenID'];

        if (storedTokenID == null) {
          docRef.update({'TokenID': currentTokenID});
        } else {
          if (storedTokenID != currentTokenID) {
            docRef.update({'TokenID': currentTokenID});
          }
        }
      } else {
        print("Snapshot is not created!");
      }
    }
    catch(e){
      print("Error in performing Initail checks for Device Token Error => $e");
    }
  }
}