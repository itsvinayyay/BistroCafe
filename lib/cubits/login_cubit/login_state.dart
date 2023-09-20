import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class LoginState{}

class LoginInitialState extends LoginState{}

class LoginLoadingState extends LoginState{}

class LoginLoggedInState extends LoginState{
  final User firebaseUser;
  LoginLoggedInState({required this.firebaseUser});
}
class LoginrequiredVerificationState extends LoginState{
  final User firebaseUser;
  LoginrequiredVerificationState({required this.firebaseUser});
}


class LoginuserNotVerifiedState extends LoginState{
  final User firebaseUser;
  LoginuserNotVerifiedState({required this.firebaseUser});

}

class LoginLoggedOutState extends LoginState{}


class LoginErrorState extends LoginState{
  String error;
  LoginErrorState({required this.error});
}



