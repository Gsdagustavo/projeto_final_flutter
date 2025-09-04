/// A custom exception that will be thrown if any travel data is invalid
class TravelRegisterException implements Exception {
  /// The error message
  final String message;

  /// Default constructor
  TravelRegisterException(this.message);
}