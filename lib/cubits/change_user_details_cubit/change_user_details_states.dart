abstract class ChangeUserDetailsStates {}

class UserDetailsInitialState extends ChangeUserDetailsStates {}

class UserDetailsLoadingState extends ChangeUserDetailsStates {}

class UserDetailsLoadedState extends ChangeUserDetailsStates {}

class UserDetailsErrorState extends ChangeUserDetailsStates {
  final String error;
  UserDetailsErrorState(this.error);
}
