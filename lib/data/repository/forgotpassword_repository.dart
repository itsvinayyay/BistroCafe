import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordRepository {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> initiateForgotPasswordRequest({required String email}) async{
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      log("Exception occured while sending Password Resend Email (Error from Forgot Password Repository)");
      rethrow;
    }
  }
}
