enum TravelError {
  notStartedYet,
  alreadyStarted,
  alreadyFinished,

  /// The travel title is empty or invalid.
  invalidTravelTitle,

  /// The travel has fewer than two stops (start and end required).
  notEnoughStops,

  /// The travel has no participants.
  noParticipants,

  /// One or more participants have invalid data (e.g., age, name).
  invalidParticipantData,

  /// Invalid or inconsistent stop dates.
  invalidStopDates,
}
