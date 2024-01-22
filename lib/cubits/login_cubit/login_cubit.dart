import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/login_cubit/login_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginCubit extends Cubit<LoginState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  LoginCubit() : super(LoginInitialState()) {
    initializeLogin();
  }

  void initializeLogin() async {
    Future.delayed(Duration(seconds: 4), () async {
      User? currentuser = _auth.currentUser;
      bool isUser = await getBoolPreference();

      if (currentuser != null) {
        String personID = _getPersonID(email: currentuser.email!);
        if (currentuser.emailVerified) {
          if (isUser) {
            emit(LoginLoggedInState(
              firebaseUser: currentuser,
              personID: personID,
            ));
          } else {
            String storeNumber = await _getStoreID(personID: personID);
            emit(
              CafeLoginLoadedState(storeID: storeNumber, personID: personID),
            );
          }
        } else {
          if (isUser) {
            emit(
              LoginRequiredVerificationState(
                firebaseUser: currentuser,
                personID: personID,
              ),
            );
          } else {
            String storeNumber = await _getStoreID(personID: personID);
            emit(CafeLoginRequiredVerificationState(
                firebaseUser: currentuser,
                storeID: storeNumber,
                personID: personID));
          }
        }
      } else {
        emit(LoginLoggedOutState());
      }
    });
  }

  String _getPersonID({required String email}) {
    String personID = "";
    for (int i = 0; i < email.length; i++) {
      if (email[i] == '@') {
        break;
      }
      personID += email[i];
    }
    personID.toLowerCase();
    return personID;
  }

  Future<bool> getBoolPreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isUser') ??
        false; // Provide a default value if the key doesn't exist.
  }

  Future<void> setBoolPreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isUser', value);
  }

  //Sign In for User Role!!
  void signinwith_Email(
      {required String email, required String password}) async {
    emit(LoginLoadingState());
    try {
      //Signing in with Firebase Authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      //Checking Conditions
      String personID = getPersonID(email);
      bool definedRole_User = await isDefinedRole_User(personID);

      if (definedRole_User) {
        await setBoolPreference(true);
        if (_auth.currentUser!.emailVerified) {
          emit(LoginLoggedInState(
            firebaseUser: userCredential.user!,
            personID: personID,
          ));
        } else {
          emit(LoginRequiredVerificationState(
            firebaseUser: userCredential.user!,
            personID: personID,
          ));
        }
      } else {
        emit(LoginErrorState(error: "You're not a User!"));
      }
    } on FirebaseAuthException catch (exception) {
      emit(LoginErrorState(error: exception.message.toString()));
    }
  }

  //Method to Sign In a Cafe Owner!
  void cafe_signinwith_Email(String Email, String Password) async {
    // emit(LoginLoadingState());
    emit(CafeLoginLoadingState());
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: Email, password: Password);

      //Checking if the person is not null
      if (userCredential.user != null) {
        String email = userCredential.user!.email!;
        String personID = getPersonID(email);
        bool definedRole_cafeOwner = await isDefinedRole_cafeOwner(personID);

        if (definedRole_cafeOwner) {
          String storeID = await _getStoreID(personID: personID);
          log("This is the Store ID");
          log(storeID);
          await setBoolPreference(false);
          log("The user is cafe Owner");
          if (_auth.currentUser!.emailVerified) {
            log("Email is Verified");
            emit(CafeLoginLoadedState(storeID: storeID, personID: personID));
          } else {
            await userCredential.user!.sendEmailVerification();
            emit(CafeLoginRequiredVerificationState(
                firebaseUser: userCredential.user!,
                storeID: storeID,
                personID: personID));
          }
        } else {
          emit(CafeLoginErrorState(error: "You're not a Cafe Owner"));
        }
      }
    } on FirebaseAuthException catch (exception) {
      emit(LoginErrorState(error: exception.message.toString()));
    }
  }

  //Method to Sign Up a User!
  void signupwith_Email(
      {required String email,
      required String password,
      required String name}) async {
    emit(LoginLoadingState());
    try {
      //Creating new account of User
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        String uid = userCredential.user!.uid;

        //Getting the personID
        String personID = getPersonID(email);

        //Adding name here in Authentication!
        userCredential.user!.updateDisplayName(name);

        //Adding a documnet in 'Users' collection
        await _updateUserDetails(
            personID: personID,
            email: email,
            uid: uid,
            name: name,
            definedRole: 'User');

        //Sending user the verification link
        await userCredential.user!.sendEmailVerification();

        //Setting the in Shared Preferences that the Person is a User!
        await setBoolPreference(true);
        emit(
          LoginRequiredVerificationState(
            firebaseUser: userCredential.user!,
            personID: personID,
          ),
        );
      }
    } on FirebaseAuthException catch (exception) {
      log("Exception thrown while Signing up a user in Login Cubit");
      emit(LoginErrorState(error: exception.message.toString()));
    }
  }

  Future<void> _updateUserDetails(
      {required String personID,
      required String email,
      required String uid,
      required String name,
      required String definedRole}) async {
    try {
      _firestore.collection('Users').doc('SMVDU$personID').set({
        'Name': name,
        'DefinedRole': definedRole,
        'PersonID': personID,
        'Email': email,
        'UID': uid,
      });
    } catch (e) {
      log("Exception thrown while updating User Details from Login Cubit!");
      rethrow;
    }
  }

  //Method to verify User!!!
  void verifyUser({required String personID}) async {
    emit(LoginLoadingState());

    if (_auth.currentUser != null) {
      await Future.delayed(Duration(seconds: 5));

      await _auth.currentUser!.reload();

      User user = _auth.currentUser!;

      if (user.emailVerified) {
        emit(LoginLoggedInState(
          firebaseUser: user,
          personID: personID,
        ));
      } else {
        // emit(LoginUserNotVerifiedState(firebaseUser: user));
        //TODO emit LoginrequiredVerification state again here!!!
        emit(
          LoginRequiredVerificationState(
            firebaseUser: user,
            personID: personID,
          ),
        );
      }
    }
  }

  void verifycafeOwner(
      {required String personID, required String storeID}) async {
    emit(CafeLoginLoadingState());
    if (_auth.currentUser != null) {
      await Future.delayed(Duration(seconds: 8));

      await _auth.currentUser!.reload();
      User user = _auth.currentUser!;
      if (user.emailVerified) {
        try {
          String firestoreName = await _getCafeOwnerName(personID: personID);

          // Updating the name of Cafe Owner in Firebase Authentication
          user.updateDisplayName(firestoreName);
          String uid = user.uid;
          String email = user.email!;

          // Updating the details of the cafe Owner in Firebase FireStore.

          await _updateCafeOwnerDetails(
              email: email, uid: uid, personID: personID);
          emit(CafeLoginLoadedState(storeID: storeID, personID: personID));
        } catch (exception) {
          log("Error thrown while Verifying Cafe Owner! => $exception");
          emit(CafeLoginErrorState(error: exception.toString()));
        }
      } else {
        //TODO emit LoginrequiredVerification state again here!!!
        emit(
          CafeLoginRequiredVerificationState(
              firebaseUser: user, storeID: storeID, personID: personID),
        );
      }
    }
  }

  Future<void> _updateCafeOwnerDetails(
      {required String email,
      required String uid,
      required String personID}) async {
    try {
      final docRef = _firestore.collection('cafeOwner').doc('SMVDU$personID');
      await docRef
          .update({"Email": email, "UID": uid, "DefinedRole": "cafeOwner"});
    } catch (e) {
      log("Exception while updating details of the CafeOwner in LoginCubit!");
      rethrow;
    }
  }

  Future<String> _getCafeOwnerName({required String personID}) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('CafeOwner').doc('SMVDU$personID').get();
      String cafeOwnerName = documentSnapshot['Name'];
      return cafeOwnerName;
    } catch (e) {
      log("Exception while retrieving name of the CafeOwner in LoginCubit!");
      rethrow;
    }
  }

  Future<String> _getStoreID({required String personID}) async {
    try {
      final docSnapshot =
          await _firestore.collection('CafeOwner').doc('SMVDU$personID').get();
      String storeID = docSnapshot['CafeID'];
      log(storeID);
      return storeID;
    } catch (e) {
      log('Got Exception while fetching Store ID from Firestore');
      rethrow;
    }
  }

  String getPersonID(String email) {
    String id = "";

    for (int i = 0; i < email.length; i++) {
      if (email[i] == '@') {
        break;
      }
      id += email[i];
    }
    return id;
  }

  Future<bool> isDefinedRole_User(String personID) async {
    final documentSnapshot =
        await _firestore.collection('Users').doc('SMVDU$personID').get();
    if (documentSnapshot.exists) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> isDefinedRole_cafeOwner(String personID) async {
    final documentSnapshot =
        await _firestore.collection('CafeOwner').doc('SMVDU$personID').get();
    if (documentSnapshot.exists) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    emit(LoginLoggedOutState());
  }
}

class TimerCubit extends Cubit<bool> {
  TimerCubit() : super(false);

  void enableResendButton() {
    emit(true);
  }
}

class ResendVerificationCubit extends Cubit<bool> {
  ResendVerificationCubit() : super(false);

  void resendVerification() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
      emit(true);
    } else {
      print("User is Null");
    }
  }
}

class PasswordVisibility extends Cubit<bool> {
  PasswordVisibility() : super(true);

  void toggleVisibility() {
    emit(!state);
  }
}

class ConfirmPasswordVisibility extends Cubit<bool> {
  ConfirmPasswordVisibility() : super(true);

  void toggleVisibility() {
    emit(!state);
  }
}

class OldpasswordVisibility extends Cubit<bool> {
  OldpasswordVisibility() : super(true);

  void toggleVisibility() {
    emit(!state);
  }
}
