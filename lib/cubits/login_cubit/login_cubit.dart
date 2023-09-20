import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_cafe/cubits/login_cubit/login_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginCubit extends Cubit<LoginState> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  LoginCubit() : super(LoginInitialState()){
    {

      User? currentuser = _auth.currentUser;

      if (currentuser != null  && currentuser!.emailVerified==false) {
        emit(LoginuserNotVerifiedState(
            firebaseUser: currentuser
        ));
      } else if(currentuser!=null){
        emit(LoginLoggedInState(firebaseUser: currentuser));
      } else {
        emit(LoginLoggedOutState());
      }

    }
  }

  String getEntryNo() {
    if (state is LoginLoggedInState) {
      final userEmail = (state as LoginLoggedInState).firebaseUser.email;
      String rollNo = "";
      for (int i = 0; i < 8; i++) {
        rollNo = rollNo + userEmail![i];
      }
      rollNo.toLowerCase();
      return rollNo;
    }
    else{
      print("Error in getting the roll number!");
      return "Error!";
    }
  }




  void signinwith_Email(String Email, String Password) async{
    emit(LoginLoadingState());
    try{
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: Email, password: Password);

      if(userCredential.user!=null){
        emit(LoginLoggedInState(firebaseUser: userCredential.user!));
      }
      else{
        print("Login was unsuccessful!");

      }
    } on FirebaseAuthException catch(exception){
      emit(LoginErrorState(error: exception.message.toString()));
    }
  }

  void signupwith_Email(String Email, String Password, String Name) async {
    emit(LoginLoadingState());
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: Email, password: Password);

      if (userCredential.user != null) {
        //Adding name here!
        userCredential.user!.updateDisplayName(Name);
        //Sending user the verification link
        await userCredential.user!.sendEmailVerification();
        emit(LoginrequiredVerificationState(firebaseUser: userCredential.user!));
      }
    } on FirebaseAuthException catch (exception) {
      emit(LoginErrorState(error: exception.message.toString()));
    }
  }

  void verifyUser(String entryNo) async{
    emit(LoginLoadingState());
    if(_auth.currentUser !=null){
      User user = _auth.currentUser!;
      await Future.delayed(Duration(seconds: 2));
      await user.reload();


      await user.reload();
      if(user.emailVerified){
        print("User Verified!!");
      } else{
        print("User Not Verified!!!!!!!!!!!!!!!!!!!!!!!!");
      }
      await Future.delayed(Duration(seconds: 1));

      await user.reload();

      await Future.delayed(Duration(seconds: 2));
      if(user.emailVerified){
        try{
          if (user != null) {
            String name = user.displayName!;
            String uid = user.uid;
            String email = user.email!;
            final docUser =
            FirebaseFirestore.instance.collection("Users").doc("SMVDU$entryNo");
            final json = {
              "Name": name,
              "EntryNo.": entryNo,
              "Email": email,
              "UID": uid,
              "DefinedRole.": "User"
            };
            await docUser.set(json);
            emit(LoginLoggedInState(firebaseUser: user));
          } else {
            print("Current user is NULL!");
          }
        } catch (exception){
          emit(LoginErrorState(error: exception.toString()));
        }

      }
      else{
        emit(LoginuserNotVerifiedState(
          firebaseUser: user
        ));
      }
    }
  }


  void signOut() async{
    await _auth.signOut();
    emit(LoginLoggedOutState());
  }
}


