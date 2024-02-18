/// Abstract class representing the different states for changing user details.
abstract class ChangeUserDetailsStates {}

/// Represents the initial state before any changes are initiated.
class UserDetailsInitialState extends ChangeUserDetailsStates {}

/// Represents the state when user details change is in progress.
class UserDetailsLoadingState extends ChangeUserDetailsStates {}

/// Represents the state when user details change is successfully completed.
class UserDetailsLoadedState extends ChangeUserDetailsStates {}

/// Represents the state when an error occurs during user details change.
class UserDetailsErrorState extends ChangeUserDetailsStates {
  // Error message associated with the error state.
  final String error;

  // Constructor to initialize the error state with a specific error message.
  UserDetailsErrorState(this.error);
}
