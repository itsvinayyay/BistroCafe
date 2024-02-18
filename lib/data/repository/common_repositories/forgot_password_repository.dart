import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';

/// Repository responsible for handling Forgot Password operations.
class ForgotPasswordRepository {
  /// Instance of FirebaseAuth for authentication-related operations.
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Initiates the process of sending a password reset email to the specified [email].
  ///
  /// Throws an error if the operation encounters any issues.
  Future<void> initiateForgotPasswordRequest({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      log("Exception occurred while sending Password Reset Email (Error from Forgot Password Repository)");
      rethrow;
    }
  }
}

