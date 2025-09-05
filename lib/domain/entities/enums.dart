/// Enum representing the types of transport available for a [Travel].
///
/// Each value represents a different mode of transportation that can be used
/// during a travel.
enum TransportType {
  /// Travel by car.
  car,

  /// Travel by bike.
  bike,

  /// Travel by bus.
  bus,

  /// Travel by plane.
  plane,

  /// Travel by cruise ship.
  cruise,
}

/// Enum representing the different experiences that a [Travel]
/// can include.
///
/// Each value represents a type of experience that can be associated
/// with a travel stop.
enum Experience {
  /// Cultural immersion experiences.
  cultureImmersion,

  /// Trying alternative or local cuisines.
  alternativeCuisines,

  /// Visiting historical places or landmarks.
  visitHistoricalPlaces,

  /// Visiting local establishments such as markets or shops.
  visitLocalEstablishments,

  /// Contact with nature or outdoor activities.
  contactWithNature,

  /// Participation in social events.
  socialEvents,
}

/// Enum representing the type of a [TravelStop].
///
/// Each value indicates the position or role of the stop in the travel.
enum TravelStopType {
  /// The starting point of the travel.
  start,

  /// A regular stop or checkpoint during the travel.
  stop,

  /// The ending point of the travel.
  end,
}

/// Enum representing the status of a [Travel].
///
/// Each value indicates the current state of a travel.
enum TravelStatus {
  /// The travel is planned but has not started yet.
  upcoming,

  /// The travel is currently ongoing.
  ongoing,

  /// The travel has finished.
  finished,
}
