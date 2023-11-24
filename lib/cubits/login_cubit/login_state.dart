import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class LoginState{}

class LoginInitialState extends LoginState{}

class LoginLoadingState extends LoginState{}

class LoginLoggedInState extends LoginState{
  final User firebaseUser;
  final bool isUser;
  LoginLoggedInState({required this.firebaseUser, required this.isUser});
}
class LoginrequiredVerificationState extends LoginState{
  final User firebaseUser;
  final bool isUser;
  LoginrequiredVerificationState({required this.firebaseUser, required this.isUser});
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




