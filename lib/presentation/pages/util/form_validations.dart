import '../../../l10n/app_localizations.dart';

/// Provides form field validation methods with localized error messages.
///
/// Each validator returns:
/// - `null` if the value is valid.
/// - A localized error message (from [AppLocalizations]) if invalid.
class FormValidations {
  final AppLocalizations _as;

  /// Creates a new instance of [FormValidations].
  ///
  /// Requires an [AppLocalizations] object to fetch localized error messages.
  const FormValidations(this._as);

  static const int _minParticipantAge = 0;
  static const int _maxParticipantAge = 120;

  static const int _minReviewCharacters = 5;
  static const int _maxReviewCharacters = 500;

  /// Validates an email address.
  ///
  /// Returns:
  /// - `null` if [email] is not empty and contains '@'.
  /// - A localized error message otherwise.
  String? emailValidator(String? email) {
    if (email == null || email.isEmpty || !email.contains('@')) {
      return _as.invalid_email;
    }
    return null;
  }

  /// Validates a password.
  ///
  /// Returns:
  /// - `null` if [password] is not empty.
  /// - A localized error message otherwise.
  String? passwordValidator(String? password) {
    if (password == null || password.isEmpty) {
      return _as.invalid_password;
    }
    return null;
  }

  /// Validates a travel title.
  ///
  /// Returns:
  /// - `null` if [travelTitle] is not empty.
  /// - A localized error message otherwise.
  ///
  /// Notes:
  /// - Minimum length validation is commented out but may be reintroduced.
  String? travelTitleValidator(String? travelTitle) {
    if (travelTitle == null || travelTitle.trim().isEmpty) {
      return _as.invalid_travel_title;
    }
    return null;
  }

  /// Validates a participant name.
  ///
  /// Returns:
  /// - `null` if [participantName] has at least 3 characters.
  /// - A localized error message otherwise.
  String? participantNameValidator(String? participantName) {
    if (participantName == null ||
        participantName.isEmpty ||
        participantName.length < 3) {
      return _as.err_invalid_participant_name;
    }
    return null;
  }

  /// Validates a participant age.
  ///
  /// Returns:
  /// - `null` if [participantAge] is a valid integer between
  ///   [_minParticipantAge] and [_maxParticipantAge].
  /// - A localized error message otherwise.
  String? participantAgeValidator(String? participantAge) {
    if (participantAge == null) {
      return _as.err_invalid_participant_age;
    }

    final intParticipantAge = int.tryParse(participantAge);
    if (intParticipantAge == null) {
      return _as.err_invalid_participant_age;
    }

    if (!intParticipantAge.isBetween(_minParticipantAge, _maxParticipantAge)) {
      return _as.err_invalid_participant_age;
    }

    return null;
  }

  /// Validates a review text.
  ///
  /// Returns:
  /// - `null` if [review] is not empty, has at least [_minReviewCharacters],
  ///   and no more than [_maxReviewCharacters].
  /// - A localized error message otherwise.
  ///
  /// Notes:
  /// - Minimum length validation is currently commented out.
  /// - The error message for exceeding max characters is not yet localized.
  String? reviewValidator(String? review) {
    if (review == null) {
      return _as.err_invalid_review_data;
    }

    /// TODO: intl
    if (review.trim().length > _maxReviewCharacters) {
      return 'Review must have at most $_minReviewCharacters characters';
    }

    return null;
  }
}

/// Extension for numeric range checking.
extension on num {
  /// Returns `true` if the number is between [min] and [max], inclusive.
  bool isBetween(num min, num max) {
    return this >= min && this <= max;
  }
}
