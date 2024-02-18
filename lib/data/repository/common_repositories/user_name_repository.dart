import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';


/// Repository class responsible for fetching the user name.
class UserNameRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Retrieves the user name from the current user's display name.
  /// Throws an exception if there's an error during the retrieval process.
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

