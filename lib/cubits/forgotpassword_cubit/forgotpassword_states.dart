abstract class ForgotPasswordStates {}

class ForgotPasswordInitialState extends ForgotPasswordStates {}

class ForgotPasswordLoadingState extends ForgotPasswordStates {}

class ForgotPasswordLoadedState extends ForgotPasswordStates {}

class ForgotPasswordErrorState extends ForgotPasswordStates {
  final String error;
  ForgotPasswordErrorState(this.error);
}
