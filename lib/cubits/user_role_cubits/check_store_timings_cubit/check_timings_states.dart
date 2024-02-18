/// Abstract base class representing different states for checking store timings.
abstract class CheckTimingsStates {}

/// Initial state for checking store timings.
class CheckTimingsInitialState extends CheckTimingsStates {}

/// State indicating that the process of checking store timings is in progress.
class CheckTimingsLoadingState extends CheckTimingsStates {}

/// State indicating that the store timings check process is successfully completed.
class CheckTimingsLoadedState extends CheckTimingsStates {}

/// State representing an error in the store timings check process.
class CheckTimingsErrorState extends CheckTimingsStates {
  // A heading describing the error.
  final String heading;

  // A subheading providing additional details about the error.
  final String subHeading;

  // Constructor for [CheckTimingsErrorState].
  CheckTimingsErrorState({required this.heading, required this.subHeading});
}
