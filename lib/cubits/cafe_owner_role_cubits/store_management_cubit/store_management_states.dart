abstract class ManagementStates {}

class ManagementInitialState extends ManagementStates {}

class ManagementLoadingState extends ManagementStates {}

class ManagementLoadedState extends ManagementStates {}

class ManagementErrorState extends ManagementStates {
  final String error;
  ManagementErrorState({required this.error});
}
