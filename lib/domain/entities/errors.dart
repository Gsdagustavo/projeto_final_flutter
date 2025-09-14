/// Represents possible errors that can occur during a travel planning or
/// management process.
///
/// This enum is used to standardize error handling when validating travel data,
/// such as stops, participants, dates, and travel state.
enum TravelError {
  /// The travel has not been started yet.
  ///
  /// This typically occurs when an operation requires the travel to be in
  /// progress but it has not been initiated.
  notStartedYet,

  /// The travel has already been started.
  ///
  /// This error occurs if an operation that requires the travel to be in a
  /// pending state is attempted after it has already started.
  alreadyStarted,

  /// The travel has already finished.
  ///
  /// This error is triggered if an operation that requires the travel to be
  /// active is attempted after it has been completed.
  alreadyFinished,

  /// The travel title is empty or invalid.
  ///
  /// Occurs when creating or updating a travel without a proper title.
  invalidTravelTitle,

  /// The travel has fewer than two stops (start and end required).
  ///
  /// A valid travel route must have at least a start and an end stop.
  notEnoughStops,

  /// The travel has no participants.
  ///
  /// Occurs when attempting to start or manage a travel that has not been
  /// assigned any participants.
  noParticipants,

  /// One or more participants have invalid data.
  ///
  /// Examples include missing or malformed participant names, invalid ages, or
  /// other inconsistencies.
  invalidParticipantData,

  /// Invalid or inconsistent stop dates.
  ///
  /// Occurs when the sequence of stop dates is incorrect
  /// (e.g., a stop date earlier than the previous stop)
  /// or required dates are missing.
  invalidStopDates,
}
