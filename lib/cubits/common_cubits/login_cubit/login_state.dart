import 'package:firebase_auth/firebase_auth.dart';

abstract class LoginState {}


class LoginSplashState extends LoginState{}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginLoggedInState extends LoginState {
  final User firebaseUser;
  final String personID;
  
  LoginLoggedInState(
      {required this.firebaseUser,
      required this.personID,
      });
}

class LoginRequiredVerificationState extends LoginState {
  final User firebaseUser;
  final String personID;
 
  LoginRequiredVerificationState(
      {required this.firebaseUser,
      required this.personID,
      });
}

class LoginUserNotVerifiedState extends LoginState {
  final User firebaseUser;
  LoginUserNotVerifiedState({required this.firebaseUser});
}

class LoginLoggedOutState extends LoginState {}

class LoginErrorState extends LoginState {
  String error;
  LoginErrorState({required this.error});
}

class CafeLoginLoadingState extends LoginState {}

class CafeLoginLoadedState extends LoginState {
  
  final String storeID;
  final String personID;
  CafeLoginLoadedState(
      {
      required this.storeID,
      required this.personID});
}

class CafeLoginRequiredVerificationState extends LoginState {
  final User firebaseUser;
  final String storeID;
  final String personID;
  CafeLoginRequiredVerificationState(
      {required this.firebaseUser,
      required this.storeID,
      required this.personID});
}

class CafeLoginErrorState extends LoginState {
  final String error;
  CafeLoginErrorState({required this.error});
}
