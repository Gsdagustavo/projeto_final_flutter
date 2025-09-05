/// A custom exception that will be thrown if a language code is invalid
class InvalidLanguageCodeException implements Exception {
  /// The error message
  final String message;

  /// Default constructor
  InvalidLanguageCodeException(this.message);
}
