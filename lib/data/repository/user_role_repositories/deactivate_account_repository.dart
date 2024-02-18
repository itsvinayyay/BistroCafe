import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';

/// Repository responsible for handling the deactivation of user accounts.
class DeactivateAccountRepository {
  // Instance of FirebaseAuth for authentication operations.
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Deactivates the user account by reauthenticating and then deleting the account.
  ///
  /// Parameters:
  /// - [password]: The user's password for reauthentication.
  Future<void> deactivateAccount({required String password}) async {
    try {
      // Retrieve the current user.
      User? user = _auth.currentUser;

      if (user != null) {
        // Create an AuthCredential using email and password for reauthentication.
        AuthCredential emailCredential = EmailAuthProvider.credential(
            email: user.email!, password: password);
        
        // Reauthenticate the user with the provided credentials.
        await user.reauthenticateWithCredential(emailCredential);

        // Delete the user account after successful reauthentication.
        await user.delete();
      } else {
        // Throw an exception if the user is null.
        throw "User is NULL (Error from Deactivate Account Repository)";
      }
    } catch (e) {
      // Log and rethrow any exceptions that occur during the deactivation process.
      log("Exception thrown while deactivating Account (error from Deactivate Account Repository)");
      rethrow;
    }
  }
}
