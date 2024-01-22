abstract class ChangePasswordStates {}

class ChangePasswordInitialState extends ChangePasswordStates {}

class ChangePasswordLoadingState extends ChangePasswordStates {}

class ChangePasswordLoadedState extends ChangePasswordStates {}

class ChangePasswordErrorState extends ChangePasswordStates {
  final String error;

  ChangePasswordErrorState(this.error);
}
