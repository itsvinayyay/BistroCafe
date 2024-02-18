import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/common_cubits/login_cubit/login_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginCubit extends Cubit<LoginState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  LoginCubit() : super(LoginSplashState()) {
    initializeLogin();
  }

  /// Initializes the login process asynchronously with a delay of 4 seconds.
  ///
  /// This method checks the user's authentication status, role, and login information.
  /// Depending on the conditions, it emits various login states such as
  /// [LoginInitialState], [LoginLoggedInState], [CafeLoginLoadedState], [LoginRequiredVerificationState],
  /// and [CafeLoginRequiredVerificationState]. Additionally, it handles the case when
  /// the user is logged out with the [LoginLoggedOutState].
  void initializeLogin() async {
    // Introducing a delay of 4 seconds to simulate an asynchronous process.
    Future.delayed(const Duration(seconds: 4), () async {
      // Retrieve the current authenticated user.
      User? currentuser = _auth.currentUser;

      // Check if the user has a Normal User role.
      bool isUser = await _getUserRole();

      // Check if the user is logging in for the first time.
      bool isLoggedInFirstTime = await _getLoggedInInfo();

      // Handling the login states based on different conditions.
      if (isLoggedInFirstTime) {
        //If the User is using the applicatio for the very first time after installing.
        emit(LoginInitialState());
      } else {
        if (currentuser != null) {
          // Extract the person ID based on the user's email.
          String personID = _getPersonID(email: currentuser.email!);

          if (currentuser.emailVerified) {
            //If the User's Email is verified
            if (isUser) {
              // Emit the state for a logged-in user.
              emit(LoginLoggedInState(
                firebaseUser: currentuser,
                personID: personID,
              ));
            } else {
              // Retrieve the store number for a non-user.
              String storeNumber = await _getStoreID(personID: personID);
              // Emit the Logged In State for the Cafe owner.
              emit(
                CafeLoginLoadedState(storeID: storeNumber, personID: personID),
              );
            }
          } else {
            if (isUser) {
              // Emit the state indicating verification is required for a user.
              emit(
                LoginRequiredVerificationState(
                  firebaseUser: currentuser,
                  personID: personID,
                ),
              );
            } else {
              // Retrieve the store number for a non-user requiring verification.
              String storeNumber = await _getStoreID(personID: personID);
              // Emit the CafeLoginRequiredVerificationState indicating verification is required for the Cafe owner.
              emit(CafeLoginRequiredVerificationState(
                  firebaseUser: currentuser,
                  storeID: storeNumber,
                  personID: personID));
            }
          }
        } else {
          // Emit the state for a logged-out user.
          emit(LoginLoggedOutState());
        }
      }
    });
  }

  /// Signs in a user with the provided email and password, handling user role-specific logic.
  ///
  /// This method initiates the sign-in process using Firebase Authentication with the given [email]
  /// and [password]. It then checks if the user has a defined role as a regular user using
  /// [_isDefinedRoleUser]. Based on the conditions, it sets the user role and login information
  /// using [_setUserRole] and [_setLoggedInInfo] respectively. Finally, it emits appropriate
  /// states like [LoginLoggedInState], [LoginRequiredVerificationState], or [LoginErrorState]
  /// based on the outcome of the sign-in process.
  ///
  /// Parameters:
  /// - [email]: The email of the user attempting to sign in.
  /// - [password]: The password associated with the user's account.
  void signInUserWithEmail(
      {required String email, required String password}) async {
    // Emitting a loading state to indicate the start of the sign-in process.
    emit(LoginLoadingState());

    try {
      // Signing in with Firebase Authentication.
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // Extracting the person ID from the email.
      String personID = _getPersonID(email: email);

      // Checking if the user has a defined role as a regular user.
      bool definedRoleUser = await _isDefinedRoleUser(personID);

      if (definedRoleUser) {
        // Setting the user role to 'true' and login information to 'false'.
        await _setUserRole(true);
        await _setLoggedInInfo(false);

        // Checking if the user's email is verified.
        if (_auth.currentUser!.emailVerified) {
          // Emitting the state for a successfully logged-in user.
          emit(LoginLoggedInState(
            firebaseUser: userCredential.user!,
            personID: personID,
          ));
        } else {
          // Emitting the state indicating verification is required for the user.
          emit(LoginRequiredVerificationState(
            firebaseUser: userCredential.user!,
            personID: personID,
          ));
        }
      } else {
        // Emitting an error state for users without the defined role.
        emit(LoginErrorState(error: "You're not a User!"));
      }
    } on FirebaseAuthException catch (exception) {
      // Emitting an error state for FirebaseAuth exceptions.
      emit(LoginErrorState(error: exception.message.toString()));
    }
  }

  /// Signs in a cafe owner with the provided email and password, handling cafe owner-specific logic.
  ///
  /// This method initiates the sign-in process using Firebase Authentication with the given [email]
  /// and [password]. It then checks if the cafe owner has a defined role using [_isDefinedRoleCafeOwner].
  /// Based on the conditions, it sets the user role, login information, and emits appropriate states like
  /// [CafeLoginLoadedState], [CafeLoginRequiredVerificationState], or [CafeLoginErrorState]
  /// based on the outcome of the sign-in process.
  ///
  /// Parameters:
  /// - [email]: The email of the cafe owner attempting to sign in.
  /// - [password]: The password associated with the cafe owner's account.
  void signInCafeOwnerwithEmail(String email, String password) async {
    // Emitting a loading state to indicate the start of the sign-in process for cafe owners.
    emit(CafeLoginLoadingState());

    try {
      // Signing in with Firebase Authentication.
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // Checking if the person is not null.
      if (userCredential.user != null) {
        // Extracting the person ID from the email.
        String personID = _getPersonID(email: email);

        // Checking if the cafe owner has a defined role.
        bool definedRoleCafeOwner = await _isDefinedRoleCafeOwner(personID);

        if (definedRoleCafeOwner) {
          // Retrieving the store ID associated with the cafe owner.
          String storeID = await _getStoreID(personID: personID);

          // Setting the user role to 'false' and login information to 'false'.
          await _setUserRole(false);
          await _setLoggedInInfo(false);

          // Checking if the cafe owner's email is verified.
          if (_auth.currentUser!.emailVerified) {
            // Emitting the state for a successfully logged-in cafe owner.
            emit(CafeLoginLoadedState(storeID: storeID, personID: personID));
          } else {
            // Sending email verification and emitting the state indicating verification is required.
            await userCredential.user!.sendEmailVerification();
            emit(CafeLoginRequiredVerificationState(
                firebaseUser: userCredential.user!,
                storeID: storeID,
                personID: personID));
          }
        } else {
          // Emitting an error state for cafe owners without the defined role.
          emit(CafeLoginErrorState(error: "You're not a Cafe Owner"));
        }
      }
    } on FirebaseAuthException catch (exception) {
      // Emitting an error state for FirebaseAuth exceptions.
      emit(LoginErrorState(error: exception.message.toString()));
    }
  }

  /// Signs up a user with the provided email, password, and name, handling user-specific logic.
  ///
  /// This method initiates the sign-up process using Firebase Authentication with the given [email]
  /// and [password]. After successful account creation, it updates the user's display name and
  /// adds details to the 'Users' collection using [_updateUserDetails]. It then sends a verification
  /// email to the user and sets user role and login information using [_setUserRole] and [_setLoggedInInfo].
  /// Finally, it emits the [LoginRequiredVerificationState] to indicate that email verification is required.
  ///
  /// Parameters:
  /// - [email]: The email for the new user account.
  /// - [password]: The password for the new user account.
  /// - [name]: The display name for the new user account.
  void signUpUserWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    // Emitting a loading state to indicate the start of the user sign-up process.
    emit(LoginLoadingState());

    try {
      // Creating a new account for the user with Firebase Authentication.
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        // Extracting the unique identifier (UID) of the user.
        String uid = userCredential.user!.uid;

        // Getting the person ID from the email.
        String personID = _getPersonID(email: email);

        // Adding the user's name to the authentication profile.
        userCredential.user!.updateDisplayName(name);

        // Updating user details in the 'Users' collection.
        await _updateUserDetails(
          personID: personID,
          email: email,
          uid: uid,
          name: name,
          definedRole: 'User',
        );

        // Sending a verification email to the user.
        await userCredential.user!.sendEmailVerification();

        // Setting user role to 'true' and login information to 'false'.
        await _setUserRole(true);
        await _setLoggedInInfo(false);

        // Emitting the state indicating that email verification is required.
        emit(
          LoginRequiredVerificationState(
            firebaseUser: userCredential.user!,
            personID: personID,
          ),
        );
      }
    } on FirebaseAuthException catch (exception) {
      // Logging and emitting an error state for FirebaseAuth exceptions during sign-up.
      log("Exception thrown while signing up a user in Login Cubit");
      emit(LoginErrorState(error: exception.message.toString()));
    }
  }

  /// Verifies the email of the currently signed-in user.
  ///
  /// This method initiates the verification process by reloading the current user's information
  /// and checking if their email has been verified. It introduces a delay of 5 seconds using
  /// [Future.delayed] to allow time for the user's email verification status to be updated.
  /// Depending on the verification status, it emits either [LoginLoggedInState] or
  /// [LoginRequiredVerificationState] to represent a successful verification or the need for
  /// email verification, respectively.
  ///
  /// Parameters:
  /// - [personID]: The unique identifier for the user derived from their email.
  void verifyUser({required String personID}) async {
    // Emitting a loading state to indicate the start of the verification process.
    emit(LoginLoadingState());

    // Checking if there is a currently signed-in user.
    if (_auth.currentUser != null) {
      // Introducing a delay of 5 seconds to allow time for email verification status update.
      await Future.delayed(const Duration(seconds: 5));

      // Reloading the current user's information.
      await _auth.currentUser!.reload();

      // Retrieving the updated user information.
      User user = _auth.currentUser!;

      // Checking if the user's email has been verified.
      if (user.emailVerified) {
        // Emitting the state for a successfully verified user.
        emit(LoginLoggedInState(
          firebaseUser: user,
          personID: personID,
        ));
      } else {
        // Emitting the state indicating that email verification is required.
        emit(
          LoginRequiredVerificationState(
            firebaseUser: user,
            personID: personID,
          ),
        );
      }
    }
  }

  /// Verifies the email of the currently signed-in cafe owner.
  ///
  /// This method initiates the verification process by reloading the current user's information
  /// and checking if their email has been verified. It introduces a delay of 8 seconds using
  /// [Future.delayed] to allow time for the user's email verification status to be updated.
  /// Depending on the verification status, it updates the name of the cafe owner in Firebase
  /// Authentication, updates the details in Firebase Firestore using [_updateCafeOwnerDetails],
  /// and emits either [CafeLoginLoadedState] or [CafeLoginRequiredVerificationState] to represent
  /// a successful verification or the need for email verification, respectively.
  ///
  /// Parameters:
  /// - [personID]: The unique identifier for the cafe owner derived from their email.
  /// - [storeID]: The identifier for the cafe owned by the cafe owner.
  void verifyCafeOwner(
      {required String personID, required String storeID}) async {
    // Emitting a loading state to indicate the start of the cafe owner verification process.
    emit(CafeLoginLoadingState());

    // Checking if there is a currently signed-in user.
    if (_auth.currentUser != null) {
      // Introducing a delay of 8 seconds to allow time for email verification status update.
      await Future.delayed(const Duration(seconds: 8));

      // Reloading the current user's information.
      await _auth.currentUser!.reload();
      User user = _auth.currentUser!;

      // Checking if the user's email has been verified.
      if (user.emailVerified) {
        try {
          // Retrieving the name of the cafe owner from Firebase Firestore.
          String firestoreName = await _getCafeOwnerName(personID: personID);

          // Updating the display name of Cafe Owner in Firebase Authentication.
          user.updateDisplayName(firestoreName);

          // Retrieving the UID and email of the cafe owner.
          String uid = user.uid;
          String email = user.email!;

          // Updating the details of the cafe owner in Firebase Firestore.
          await _updateCafeOwnerDetails(
              email: email, uid: uid, personID: personID);

          // Emitting the state for a successfully verified cafe owner.
          emit(CafeLoginLoadedState(storeID: storeID, personID: personID));
        } catch (exception) {
          // Logging and emitting an error state if an exception occurs during verification.
          log("Error thrown while Verifying Cafe Owner (Error from Login Cubit) => $exception");
          emit(CafeLoginErrorState(error: exception.toString()));
        }
      } else {
        // Emitting the state indicating that email verification is required.
        emit(
          CafeLoginRequiredVerificationState(
              firebaseUser: user, storeID: storeID, personID: personID),
        );
      }
    }
  }

  /// Signs out the currently authenticated user.
  ///
  /// This method signs out the user using Firebase Authentication and emits
  /// [LoginLoggedOutState] to indicate a successful sign-out.
  Future<void> signOut() async {
    // Signing out the currently authenticated user.
    await _auth.signOut();

    // Emitting the state indicating a successful sign-out.
    emit(LoginLoggedOutState());
  }

  /// Updates details of a cafe owner in the 'cafeOwner' collection of Firestore.
  ///
  /// This method updates the details of a cafe owner by updating a document in the 'cafeOwner'
  /// collection with a unique identifier (DocID) derived from the cafe owner's personID. The
  /// details include the cafe owner's [email], [uid], and the defined role set to 'cafeOwner'.
  ///
  /// Parameters:
  /// - [email]: The email associated with the cafe owner account.
  /// - [uid]: The unique identifier (UID) of the cafe owner.
  /// - [personID]: The unique identifier for the cafe owner derived from their email.
  Future<void> _updateCafeOwnerDetails({
    required String email,
    required String uid,
    required String personID,
  }) async {
    try {
      // Creating a reference to the document in the 'cafeOwner' collection.
      final docRef = _firestore.collection('cafeOwner').doc('SMVDU$personID');

      // Updating details of the cafe owner in the Firestore document.
      await docRef
          .update({"Email": email, "UID": uid, "DefinedRole": "cafeOwner"});
    } catch (e) {
      // Logging and rethrowing exceptions encountered during cafe owner details update.
      log("Exception while updating details of the CafeOwner in LoginCubit!");
      rethrow;
    }
  }

  /// Retrieves the name of a cafe owner from the 'CafeOwner' collection of Firestore.
  ///
  /// This method retrieves the name of a cafe owner by fetching a document from the 'CafeOwner'
  /// collection with a unique identifier (DocID) derived from the cafe owner's personID.
  ///
  /// Parameters:
  /// - [personID]: The unique identifier for the cafe owner derived from their email.
  ///
  /// Returns:
  /// A [Future<String>] representing the name of the cafe owner.
  Future<String> _getCafeOwnerName({required String personID}) async {
    try {
      // Fetching a document from the 'CafeOwner' collection based on the personID.
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('CafeOwner').doc('SMVDU$personID').get();

      // Extracting the cafe owner's name from the document.
      String cafeOwnerName = documentSnapshot['Name'];

      // Returning the retrieved cafe owner's name.
      return cafeOwnerName;
    } catch (e) {
      // Logging and rethrowing exceptions encountered during cafe owner name retrieval.
      log("Exception while retrieving the name of the CafeOwner in LoginCubit!");
      rethrow;
    }
  }

  /// Retrieves the store ID associated with a cafe owner from the 'CafeOwner' collection of Firestore.
  ///
  /// This method fetches a document from the 'CafeOwner' collection based on the personID,
  /// extracting and returning the store ID associated with the cafe owner.
  ///
  /// Parameters:
  /// - [personID]: The unique identifier for the cafe owner derived from their email.
  ///
  /// Returns:
  /// A [Future<String>] representing the store ID associated with the cafe owner.
  Future<String> _getStoreID({required String personID}) async {
    try {
      // Fetching a document from the 'CafeOwner' collection based on the personID.
      final docSnapshot =
          await _firestore.collection('CafeOwner').doc('SMVDU$personID').get();

      // Extracting the store ID associated with the cafe owner from the document.
      String storeID = docSnapshot['CafeID'];

      // Logging the retrieved store ID.
      log(storeID);

      // Returning the retrieved store ID.
      return storeID;
    } catch (e) {
      // Logging and rethrowing exceptions encountered during store ID retrieval.
      log('Got Exception while fetching Store ID from Firestore');
      rethrow;
    }
  }

  /// Checks if a user with the specified personID has a defined role in the 'Users' collection.
  ///
  /// This method fetches a document from the 'Users' collection based on the personID
  /// and checks if the document exists. If the document exists, it indicates that the user
  /// has a defined role, and the method returns `true`. Otherwise, it returns `false`.
  ///
  /// Parameters:
  /// - [personID]: The unique identifier for the user derived from their email.
  ///
  /// Returns:
  /// A [Future<bool>] representing whether the user has a defined role (`true`) or not (`false`).
  Future<bool> _isDefinedRoleUser(String personID) async {
    // Fetching a document from the 'Users' collection based on the personID.
    final documentSnapshot =
        await _firestore.collection('Users').doc('SMVDU$personID').get();

    // Checking if the document exists, indicating a defined role for the user.
    if (documentSnapshot.exists) {
      return true;
    } else {
      return false;
    }
  }

  /// Checks if a cafe owner with the specified personID has a defined role in the 'CafeOwner' collection.
  ///
  /// This method fetches a document from the 'CafeOwner' collection based on the personID
  /// and checks if the document exists. If the document exists, it indicates that the cafe owner
  /// has a defined role, and the method returns `true`. Otherwise, it returns `false`.
  ///
  /// Parameters:
  /// - [personID]: The unique identifier for the cafe owner derived from their email.
  ///
  /// Returns:
  /// A [Future<bool>] representing whether the cafe owner has a defined role (`true`) or not (`false`).
  Future<bool> _isDefinedRoleCafeOwner(String personID) async {
    // Fetching a document from the 'CafeOwner' collection based on the personID.
    final documentSnapshot =
        await _firestore.collection('CafeOwner').doc('SMVDU$personID').get();

    // Checking if the document exists, indicating a defined role for the cafe owner.
    if (documentSnapshot.exists) {
      return true;
    } else {
      return false;
    }
  }

  /// Updates user details in the 'Users' collection of Firestore.
  ///
  /// This method updates the user details by setting a document in the 'Users' collection
  /// with a unique identifier (DocID) derived from the person's ID. The details include
  /// the user's [name], [definedRole], [personID], [email], and [uid].
  ///
  /// Parameters:
  /// - [personID]: The unique identifier for the user derived from their email.
  /// - [email]: The email associated with the user account.
  /// - [uid]: The unique identifier (UID) of the user.
  /// - [name]: The display name of the user.
  /// - [definedRole]: The defined role of the user (e.g., 'User' or 'Cafe Owner').
  Future<void> _updateUserDetails({
    required String personID,
    required String email,
    required String uid,
    required String name,
    required String definedRole,
  }) async {
    try {
      // Setting user details in the 'Users' collection of Firestore.
      await _firestore.collection('Users').doc('SMVDU$personID').set({
        'Name': name,
        'DefinedRole': definedRole,
        'PersonID': personID,
        'Email': email,
        'UID': uid,
      });
    } catch (e) {
      // Logging and rethrowing exceptions encountered during user details update.
      log("Exception thrown while updating User Details (Error from Login Cubit)");
      rethrow;
    }
  }

  /// Sets the user role information indicating whether the user has a specific role.
  ///
  /// This method asynchronously obtains the shared preferences instance and sets
  /// the boolean value associated with the 'isUser' key to the provided [value].
  ///
  /// Parameters:
  /// - [value]: A [bool] representing whether the user has a specific role.
  ///
  /// Returns:
  /// A [Future] representing the asynchronous completion of setting the user role information.
  Future<void> _setUserRole(bool value) async {
    // Obtain the shared preferences instance.
    final prefs = await SharedPreferences.getInstance();

    // Set the boolean value associated with the 'isUser' key to the provided value.
    await prefs.setBool('isUser', value);
  }

  /// Retrieves the user role information indicating whether the user has a specific role.
  ///
  /// This method asynchronously obtains the shared preferences instance and retrieves
  /// the boolean value associated with the 'isUser' key. If the key doesn't exist,
  /// it provides a default value of `false`. The boolean value represents whether the user
  /// has a specific role or not.
  ///
  /// Returns:
  /// A [Future] of [bool] representing whether the user has a specific role.
  Future<bool> _getUserRole() async {
    // Obtain the shared preferences instance.
    final prefs = await SharedPreferences.getInstance();

    // Retrieve the boolean value associated with the 'isUser' key.
    // If the key doesn't exist, provide a default value of `false`.
    return prefs.getBool('isUser') ?? false;
  }

  /// Sets the login information indicating whether the user is logging in for the first time.
  ///
  /// This method asynchronously obtains the shared preferences instance and sets
  /// the boolean value associated with the 'isFirstTime' key to the provided [value].
  ///
  /// Parameters:
  /// - [value]: A [bool] representing whether the user is logging in for the first time.
  ///
  /// Returns:
  /// A [Future] representing the asynchronous completion of setting the login information.
  Future<void> _setLoggedInInfo(bool value) async {
    // Obtain the shared preferences instance.
    final prefs = await SharedPreferences.getInstance();

    // Set the boolean value associated with the 'isFirstTime' key to the provided value.
    await prefs.setBool('isFirstTime', value);
  }

  /// Retrieves the login information indicating whether the user is logging in for the first time.
  ///
  /// This method asynchronously obtains the shared preferences instance and retrieves
  /// the boolean value associated with the 'isFirstTime' key. If the key doesn't exist,
  /// it provides a default value of `true`. The boolean value represents whether the user
  /// is logging in for the first time or not.
  ///
  /// Returns:
  /// A [Future] of [bool] representing whether the user is logging in for the first time.
  Future<bool> _getLoggedInInfo() async {
    // Obtain the shared preferences instance.
    final prefs = await SharedPreferences.getInstance();

    // Retrieve the boolean value associated with the 'isFirstTime' key.
    // If the key doesn't exist, provide a default value of `true`.
    return prefs.getBool('isFirstTime') ?? true;
  }

  /// Retrieves the person ID from the given email address.
  ///
  /// This method extracts the person ID by iterating through the characters
  /// of the provided email address until it encounters the '@' symbol. It
  /// stops the iteration at that point and converts the person ID to lowercase
  /// before returning it.
  ///
  /// Parameters:
  /// - [email]: The email address from which to extract the person ID.
  ///
  /// Returns:
  /// A [String] representing the extracted person ID.
  String _getPersonID({required String email}) {
    // Initialize an empty string to store the person ID.
    String personID = "";

    // Iterate through the characters of the email address.
    for (int i = 0; i < email.length; i++) {
      // Break the loop when the '@' symbol is encountered.
      if (email[i] == '@') {
        break;
      }

      // Concatenate the current character to the person ID.
      personID += email[i];
    }

    // Convert the person ID to lowercase.
    personID.toLowerCase();

    // Return the extracted and lowercase person ID.
    return personID;
  }
}

/// A [Cubit] to manage the state of a timer, specifically for enabling or disabling a resend button.
///
/// This [TimerCubit] extends [Cubit<bool>] and is initialized with an initial state of `false`,
/// indicating that the resend button is initially disabled. It provides a method [enableResendButton]
/// to update the state and enable the resend button.
class TimerCubit extends Cubit<bool> {
  /// Constructor for [TimerCubit].
  ///
  /// Initializes the [TimerCubit] with an initial state of `false`.
  TimerCubit() : super(false);

  /// Enables the resend button by updating the state to `true`.
  void enableResendButton() {
    emit(true);
  }
}

/// A [Cubit] to manage the state of resending email verification.
///
/// This [ResendVerificationCubit] extends [Cubit<bool>] and is initialized with an initial state of `false`,
/// indicating that the resend verification process is not active. It provides a method [resendVerification]
/// to resend email verification for the current user and updates the state to `true` upon successful resend.
class ResendVerificationCubit extends Cubit<bool> {
  ResendVerificationCubit() : super(false);

  /// Resends email verification for the current user and updates the state to `true` upon success.
  ///
  /// This method checks if the current user is not null, and if so, it triggers the
  /// resend email verification process using [sendEmailVerification]. If the process is successful,
  /// it updates the state to `true`. If the user is null, it logs a message indicating that the user is null.
  void resendVerification() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
      emit(true);
    } else {
      log("User is Null");
    }
  }
}
