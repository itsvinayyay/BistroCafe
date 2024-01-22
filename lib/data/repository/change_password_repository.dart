import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordRepository {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> changePassword(
      {required String oldPassword, required String newPassword}) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        AuthCredential emailCredential = EmailAuthProvider.credential(
            email: user.email!, password: oldPassword);
        await user.reauthenticateWithCredential(emailCredential);

        await user.updatePassword(newPassword);
      } else {
        log("User is NULL (Error from Change Password Repository)");
        throw "User is NULL (Error from Change Password Repository)";
      }
    } catch (e) {
      log("Exception while Changing the Password (Error from Change Password Repository)");
      rethrow;
    }
  }
}
