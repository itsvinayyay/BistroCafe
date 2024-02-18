/// Abstract class representing the different states for deactivating user accounts.
abstract class DeactivateAccountStates {}

/// Represents the initial state before any deactivation process is initiated.
class DeactivateAccountInitialState extends DeactivateAccountStates {}

/// Represents the state when the account deactivation process is in progress.
class DeactivateAccountLoadingState extends DeactivateAccountStates {}

/// Represents the state when the account deactivation process is successfully completed.
class DeactivateAccountLoadedState extends DeactivateAccountStates {}

/// Represents the state when an error occurs during the account deactivation process.
class DeactivateAccountErrorState extends DeactivateAccountStates {
  // Error message associated with the error state.
  final String error;

  // Constructor to initialize the error state with a specific error message.
  DeactivateAccountErrorState(this.error);
}
