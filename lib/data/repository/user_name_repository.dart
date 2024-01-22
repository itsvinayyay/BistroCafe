import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class UserNameRepository {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> getUserName() async {
    try {
      String userName = _auth.currentUser!.displayName!;
      return userName;
    } catch (e) {
      log("Exception in fetching the User Name (Error from User Name Repository)");
      rethrow;
    }
  }
}
