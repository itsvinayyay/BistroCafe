abstract class DeactivateAccountStates {}

class DeactivateAccountInitialState extends DeactivateAccountStates {}

class DeactivateAccountLoadingState extends DeactivateAccountStates {}

class DeactivateAccountLoadedState extends DeactivateAccountStates {}

class DeactivateAccountErrorState extends DeactivateAccountStates {
  final String error;
  DeactivateAccountErrorState(this.error);
}
