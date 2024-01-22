abstract class UserNameStates {
  final String userName;
  UserNameStates(this.userName);
}

class UserNameInitialState extends UserNameStates {
  UserNameInitialState() : super('');
}

class UserNameLoadingState extends UserNameStates {
  UserNameLoadingState(super.userName);
}

class UserNameLoadedState extends UserNameStates {
  UserNameLoadedState(super.userName);
}

class UserNameErrorState extends UserNameStates {
  final String error;
  UserNameErrorState(super.userName, this.error);
}
