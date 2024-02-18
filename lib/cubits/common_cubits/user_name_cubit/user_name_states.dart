/// Abstract class representing the various states for the user name.
abstract class UserNameStates {
  final String userName;
  UserNameStates(this.userName);
}

/// Initial state for the user name, with an empty string.
class UserNameInitialState extends UserNameStates {
  UserNameInitialState() : super('');
}

/// Loading state for the user name, indicating ongoing data retrieval.
class UserNameLoadingState extends UserNameStates {
  UserNameLoadingState(super.userName);
}

/// Loaded state for the user name, containing the retrieved user name.
class UserNameLoadedState extends UserNameStates {
  UserNameLoadedState(super.userName);
}

/// Error state for the user name, including an error message.
class UserNameErrorState extends UserNameStates {
  final String error;
  UserNameErrorState(super.userName, this.error);
}
