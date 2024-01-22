abstract class ModifyMenuItemStates {}

class ModifyMenuItemInitialState extends ModifyMenuItemStates {}

class ModifyMenuItemLoadingState extends ModifyMenuItemStates {}

class ModifyMenuItemLoadedState extends ModifyMenuItemStates {}

class ModifyMenuItemErrorState extends ModifyMenuItemStates {
  final String error;
  ModifyMenuItemErrorState(this.error);
}
