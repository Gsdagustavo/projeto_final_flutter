import '../../../l10n/app_localizations.dart';

class FormValidations {
  final AppLocalizations as;

  const FormValidations(this.as);

  static const int _minParticipantAge = 0;
  static const int _maxParticipantAge = 120;

  String? emailValidator(String? email) {
    if (email == null || email.isEmpty || !email.contains('@')) {
      return as.invalid_email;
    }

    return null;
  }

  String? passwordValidator(String? password) {
    if (password == null || password.isEmpty) {
      /// TODO: intl
      return 'Invalid password';
    }

    return null;
  }

  String? travelTitleValidator(String? travelTitle) {
    if (travelTitle == null || travelTitle.isEmpty || travelTitle.length < 3) {
      return as.invalid_travel_title;
    }

    return null;
  }

  String? participantNameValidator(String? participantName) {
    if (participantName == null ||
        participantName.isEmpty ||
        participantName.length < 3) {
      /// TODO: intl
      return '';
    }

    return null;
  }

  String? participantAgeValidator(String? participantAge) {
    if (participantAge == null ||
        participantAge.isEmpty ||
        participantAge.length < 3) {
      /// TODO: intl
      return '';
    }

    final intParticipantAge = int.tryParse(participantAge);

    if (intParticipantAge == null) {
      /// TODO: intl
      return '';
    }

    if (!intParticipantAge.isBetween(_minParticipantAge, _maxParticipantAge)) {
      /// TODO: intl
      return '';
    }

    return null;
  }
}

extension on num {
  bool isBetween(num min, num max) {
    return this >= min && this <= max;
  }
}
