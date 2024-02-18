import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';

/// Repository responsible for handling password change operations.
class ChangePasswordRepository {
  /// Firebase Authentication instance.
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Changes the user's password.
  ///
  /// Takes [oldPassword] for reauthentication and [newPassword] for the updated password.
  Future<void> changePassword(
      {required String oldPassword, required String newPassword}) async {
    try {
      // Retrieve the current user from Firebase Authentication.
      User? user = _auth.currentUser;

      // Check if the user is not null.
      if (user != null) {
        // Reauthenticate the user with the provided credentials.
        AuthCredential emailCredential = EmailAuthProvider.credential(
            email: user.email!, password: oldPassword);
        await user.reauthenticateWithCredential(emailCredential);

        // Update the user's password with the new one.
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

