import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Repository responsible for changing user details.
class ChangeUserDetailsRepository {
  // Firestore instance used for database operations.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Firebase Authentication instance used for user authentication operations.
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Changes details for a cafe owner.
  ///
  /// Parameters:
  /// - [name]: The updated name for the cafe owner.
  /// - [personID]: The unique identifier for the cafe owner.
  Future<void> changeCafeOwnerDetails({
    required String name,
    required String personID,
  }) async {
    try {
      // Reference to the document for the cafe owner in the Firestore collection.
      DocumentReference documentReference =
          _firestore.collection('CafeOwner').doc('SMVDU$personID');

      // Update the name in the Firestore document.
      await documentReference.update({'Name': name});
      // Update the display name for the authenticated user.
      await _auth.currentUser!.updateDisplayName(name);
    } catch (e) {
      // Log and rethrow any errors that occur during the update.
      log("Exception thrown while Changing the Cafe Owner Details (Error from Change Cafe Owner Details Repository)");
      rethrow;
    }
  }

  /// Changes details for a regular user.
  ///
  /// Parameters:
  /// - [name]: The updated name for the user.
  /// - [personID]: The unique identifier for the user.
  Future<void> changeUserDetails({
    required String name,
    required String personID,
  }) async {
    try {
      // Log the personID for debugging purposes.
      log(personID);

      // Reference to the document for the user in the Firestore collection.
      DocumentReference documentReference =
          _firestore.collection('Users').doc('SMVDU$personID');

      // Update the name in the Firestore document.
      await documentReference.update({'Name': name});
      // Update the display name for the authenticated user.
      await _auth.currentUser!.updateDisplayName(name);
    } catch (e) {
      // Log and rethrow any errors that occur during the update.
      log("Exception thrown while Changing the User Details (Error from Change user Details Repository)");
      rethrow;
    }
  }
}

