/// Abstract class representing the various states for the change password feature.
abstract class ChangePasswordStates {}

/// Initial state indicating that the change password feature is in its initial state.
class ChangePasswordInitialState extends ChangePasswordStates {}

/// Loading state indicating that the change password operation is in progress.
class ChangePasswordLoadingState extends ChangePasswordStates {}

/// Loaded state indicating that the change password operation was successfully completed.
class ChangePasswordLoadedState extends ChangePasswordStates {}

/// Error state indicating that an error occurred during the change password operation.
class ChangePasswordErrorState extends ChangePasswordStates {
  /// The error message describing the reason for the failure.
  final String error;

  // Constructor to initialize the error state with the provided error message.
  ChangePasswordErrorState(this.error);
}
