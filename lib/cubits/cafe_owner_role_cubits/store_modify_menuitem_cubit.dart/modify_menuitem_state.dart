/// Represents the states for modifying menu items.
abstract class ModifyMenuItemStates {}

/// Initial state for modifying menu items.
class ModifyMenuItemInitialState extends ModifyMenuItemStates {}

/// Loading state while modifying menu items.
class ModifyMenuItemLoadingState extends ModifyMenuItemStates {}

/// Loaded state after successfully modifying menu items.
class ModifyMenuItemLoadedState extends ModifyMenuItemStates {}

/// Error state when an exception occurs during the modification of menu items.
class ModifyMenuItemErrorState extends ModifyMenuItemStates {
  final String error;
  ModifyMenuItemErrorState(this.error);
}
