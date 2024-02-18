/// Abstract class representing various states for the Forgot Password feature.
abstract class ForgotPasswordStates {}

/// Initial state for the Forgot Password feature.
class ForgotPasswordInitialState extends ForgotPasswordStates {}

/// State indicating that the Forgot Password operation is in progress.
class ForgotPasswordLoadingState extends ForgotPasswordStates {}

/// State indicating that the Forgot Password operation has successfully completed.
class ForgotPasswordLoadedState extends ForgotPasswordStates {}

/// State indicating an error during the Forgot Password operation, with an optional [error] message.
class ForgotPasswordErrorState extends ForgotPasswordStates {
  /// The error message associated with the Forgot Password operation.
  final String error;

  // Constructs a [ForgotPasswordErrorState] with the provided [error] message.
  ForgotPasswordErrorState(this.error);
}
