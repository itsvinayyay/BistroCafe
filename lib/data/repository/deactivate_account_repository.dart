import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class DeactivateAccountRepository {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> deactivateAccount({required String password}) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        AuthCredential emailCredential = EmailAuthProvider.credential(
            email: user.email!, password: password);
        await user.reauthenticateWithCredential(emailCredential);

        await user.delete();
      } else {
        throw "User is NULL (Error from Deactivate Account Repository)";
      }
    } catch (e) {
      log("Exception thrown while deactivating Account (error from Deactivate Account Repository)");
      rethrow;
    }
  }
}
