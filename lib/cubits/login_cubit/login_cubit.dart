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

  late String storeID;

  void initializeLogin() async {
    User? currentuser = _auth.currentUser;
    bool isUser = await getBoolPreference();

    if (currentuser != null && currentuser!.emailVerified == false) {
      emit(LoginrequiredVerificationState(
        firebaseUser: currentuser,
        isUser: isUser,
      ));
    } else if (currentuser != null) {
      emit(LoginLoggedInState(firebaseUser: currentuser, isUser: isUser));
      final userEmail = (state as LoginLoggedInState).firebaseUser.email;
      String rollNo = "";
      for (int i = 0; i < userEmail!.length; i++) {
        if (userEmail[i] == '@') {
          break;
        }
        rollNo = rollNo + userEmail[i];
      }
      rollNo.toLowerCase();
      print(rollNo);
      storeID = await getStoreID(rollNo);
    } else {
      emit(LoginLoggedOutState());
    }
  }

  // String definedRole = "";
  // void getDefinedRole(String ID) async{
  //   final snapshotRef = FirebaseFirestore.instance.collection('User');
  // }
  Future<bool> getBoolPreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isUser') ??
        false; // Provide a default value if the key doesn't exist.
  }

  Future<void> setBoolPreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isUser', value);
  }

  Future<String> getStoreID(String ID) async {
    if (state is LoginLoggedInState) {
      bool isUser = await getBoolPreference();

      if (isUser == false) {
        final snapshotRef = await FirebaseFirestore.instance
            .collection('CafeOwner')
            .doc('SMVDU$ID')
            .get();
        if (snapshotRef.exists) {
          final data = snapshotRef.data();
          String storeID = data!['CafeID'];
          return storeID;
        } else {
          print("Cafe Owner Doesn't exists!");
          return "Error0";
        }
      } else {
        print("Person is the User not Cafe Owner while fetching Store ID");
        return "Error1";
      }
    } else {
      print("Not Logged In while fetching Store ID");
      return "Error2";
    }
  }

  String getEntryNo() {
    if (state is LoginLoggedInState) {
      final userEmail = (state as LoginLoggedInState).firebaseUser.email;
      String rollNo = "";
      for (int i = 0; i < userEmail!.length; i++) {
        if (userEmail[i] == '@') {
          break;
        }
        rollNo = rollNo + userEmail[i];
      }
      rollNo.toLowerCase();
      return rollNo;
    } else if (state is LoginrequiredVerificationState) {
      final userEmail =
          (state as LoginrequiredVerificationState).firebaseUser.email;
      String rollNo = "";
      for (int i = 0; i < userEmail!.length; i++) {
        if (userEmail[i] == '@') {
          break;
        }
        rollNo = rollNo + userEmail[i];
      }
      rollNo.toLowerCase();
      return rollNo;
    } else if (state is LoginuserNotVerifiedState) {
      final userEmail = (state as LoginuserNotVerifiedState).firebaseUser.email;
      String rollNo = "";
      for (int i = 0; i < userEmail!.length; i++) {
        if (userEmail[i] == '@') {
          break;
        }
        rollNo = rollNo + userEmail[i];
      }
      rollNo.toLowerCase();
      return rollNo;
    } else {
      print("Error in getting the roll number! ${state.toString()}");
      return "Error!";
    }
  }

  //Sign In for User Role!!
  void signinwith_Email(String Email, String Password) async {
    emit(LoginLoadingState());
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: Email, password: Password);
      if (userCredential.user != null) {
        String email = _auth.currentUser!.email!;
        String personID = getPersonID(email);
        bool definedRole_User = await isDefinedRole_User(personID);
        if (_auth.currentUser!.emailVerified) {

          if(definedRole_User){
            await setBoolPreference(true);
            emit(LoginLoggedInState(
                firebaseUser: userCredential.user!, isUser: true));
          }
          else{
            emit(LoginErrorState(error: "You're not a 'User', proceed with other Roles!"));
          }
        }
        else {
          //TODO check here also if the person is User or CafeOwner
          if(definedRole_User){
            await userCredential.user!.sendEmailVerification();
            await setBoolPreference(true);
            emit(LoginrequiredVerificationState(
                firebaseUser: userCredential.user!, isUser: true));
          }
          else{
            emit(LoginErrorState(error: "You're not a User and your email is not verified, Try with other roles."));
          }
        }
      }
    } on FirebaseAuthException catch (exception) {
      emit(LoginErrorState(error: exception.message.toString()));
    }
  }

  //Method to Sign In a User!
  void store_signinwith_Email(String Email, String Password) async {
    emit(LoginLoadingState());
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: Email, password: Password);

      //Checking if the person is not null
      if (userCredential.user != null) {
        String email = userCredential.user!.email!;
        String personID = getPersonID(email);
        bool definedRole_cafeOwner = await isDefinedRole_cafeOwner(personID);
        //Checking if the person's email is Verified or not?
        if (_auth.currentUser!.emailVerified) {

          //Checking if the person is cafeOwner or not?
          if(definedRole_cafeOwner){
            await setBoolPreference(false);
            emit(LoginLoggedInState(
                firebaseUser: userCredential.user!, isUser: false));
          }
          else{
            emit(LoginErrorState(error: "You are not a 'Cafe Owner', try for other roles!"));
          }

        }
        else {
          if(definedRole_cafeOwner){
            await userCredential.user!.sendEmailVerification();
            await setBoolPreference(false);
            emit(LoginrequiredVerificationState(
                firebaseUser: userCredential.user!, isUser: false));
          }
          else{
            emit(LoginErrorState(error: "You're not a 'Cafe Owner' and your email is also not verified!"));
          }
        }
      }
    } on FirebaseAuthException catch (exception) {
      emit(LoginErrorState(error: exception.message.toString()));
    }
  }

  //Method to Sign Up a User!
  void signupwith_Email(String Email, String Password, String Name) async {
    emit(LoginLoadingState());
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: Email, password: Password);

      if (userCredential.user != null) {
        String email = userCredential.user!.email!;
        String uid = userCredential.user!.uid;

        //Getting the personID
        String personID = getPersonID(email);

        //Adding name here in Authentication!
        userCredential.user!.updateDisplayName(Name);

        //Adding a documnet in 'Users' collection
        _firestore.collection('Users').doc('SMVDU$personID').set({
          'Name' : Name,
          'DefinedRole' : 'User',
          'PersonID' : personID,
          'Email' : email,
          'UID' : uid,
        });

        //Sending user the verification link
        await userCredential.user!.sendEmailVerification();

        //Setting the in the device storage that the Person is a User!
        await setBoolPreference(true);
        emit(LoginrequiredVerificationState(
            firebaseUser: userCredential.user!, isUser: true));
      }
    } on FirebaseAuthException catch (exception) {
      emit(LoginErrorState(error: exception.message.toString()));
    }
  }

  //Method to verify User!!!
  void verifyUser(String entryNo) async {
    emit(LoginLoadingState());

    if (_auth.currentUser != null) {
      await Future.delayed(Duration(seconds: 5));

      await _auth.currentUser!.reload();
      print("verification ${_auth.currentUser!.emailVerified}");
      User user = _auth.currentUser!;

      await Future.delayed(Duration(seconds: 5));

      await _auth.currentUser!.reload();
      print("verification ${_auth.currentUser!.emailVerified}");

      if (user.emailVerified) {
        print("User Verified!!");
      } else {
        print("User Not Verified!!!!!!!!!!!!!!!!!!!!!!!!");
      }
      if (user.emailVerified) {
        emit(LoginLoggedInState(firebaseUser: user, isUser: true));
      } else {
        emit(LoginuserNotVerifiedState(firebaseUser: user));
        //TODO emit LoginrequiredVerification state again here!!!
        emit(LoginrequiredVerificationState(firebaseUser: user, isUser: true));
      }
    }
  }

  void verifycafeOwner(String ID) async {
    emit(LoginLoadingState());
    if (_auth.currentUser != null) {
      await Future.delayed(Duration(seconds: 8));

      await _auth.currentUser!.reload();
      User user = _auth.currentUser!;
      // print("verification ${_auth.currentUser!.emailVerified}");
      // User user = _auth.currentUser!;
      //
      // await Future.delayed(Duration(seconds: 5));
      //
      //
      // if (user.emailVerified) {
      //   print("User Verified!!");
      // } else {
      //   print("User Not Verified!!!!!!!!!!!!!!!!!!!!!!!!");
      // }
      if (user.emailVerified) {
        try {
          if (user != null) {


            String firestoreName = "";

            final docUser = FirebaseFirestore.instance
                .collection("CafeOwner")
                .doc("SMVDU$ID");
            final docUserSnapshot = await docUser.get();
            if (docUserSnapshot.exists) {
              final data = docUserSnapshot.data();
              firestoreName = data!['Name'];
            }
            user.updateDisplayName(firestoreName);
            String uid = user.uid;
            String email = user.email!;

            final json = {
              "Email": email,
              "UID": uid,
              "DefinedRole": "cafeOwner"
            };
            await docUser.update(json);
            emit(LoginLoggedInState(firebaseUser: user, isUser: false));
          } else {
            print("Current user is NULL!");
          }
        } catch (exception) {
          print(exception);
          emit(LoginErrorState(error: exception.toString()));
        }
      } else {
        emit(LoginuserNotVerifiedState(firebaseUser: user));
        //TODO emit LoginrequiredVerification state again here!!!
        emit(LoginrequiredVerificationState(firebaseUser: user, isUser: false));
      }
    }
  }

  String getPersonID(String email){
    String id = "";

    for(int i=0; i<email.length; i++){
      if(email[i] == '@'){
        break;
      }
      id+=email[i];
    }
    return id;
  }

  Future<bool> isDefinedRole_User(String personID) async{
    final documentSnapshot = await _firestore.collection('Users').doc('SMVDU$personID').get();
    if(documentSnapshot.exists){
      return true;
    }
    else{
      return false;
    }
  }
  Future<bool> isDefinedRole_cafeOwner(String personID) async{
    final documentSnapshot = await _firestore.collection('CafeOwner').doc('SMVDU$personID').get();
    if(documentSnapshot.exists){
      return true;
    }
    else{
      return false;
    }
  }

  void signOut() async {
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

class SignInErrorsCubit extends Cubit<List<String>>{
  SignInErrorsCubit() : super([]);


  void addSignInError(String error){
    state.add(error);
    emit(state);
  }

  void removeSignInError(String error){
    state.remove(error);
    emit(state);
  }

  void deleteSignInError(String error){
    state.clear();
    emit(state);
  }
}

class PasswordVisibility extends Cubit<bool>{
  PasswordVisibility() : super(true);

  void toggleVisibility(){
    print(!state);
    emit(!state);
  }
}
