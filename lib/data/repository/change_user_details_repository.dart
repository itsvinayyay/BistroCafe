import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangeUserDetailsRepository {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> changeDetails(
      {required String name, required String personID}) async {
    try {
      DocumentReference documentReference =
          _firestore.collection('CafeOwner').doc('SMVDU$personID');

      await documentReference.update({'Name': name});
      await _auth.currentUser!.updateDisplayName(name);
    } catch (e) {
      log("Exception thrown while Changing the User Details (Error from Change user Details Repository)");
      rethrow;
    }
  }
}
