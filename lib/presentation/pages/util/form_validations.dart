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
      return as.invalid_password;
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
      return as.err_invalid_participant_name;
    }

    return null;
  }

  String? participantAgeValidator(String? participantAge) {
    if (participantAge == null ||
        participantAge.isEmpty ||
        participantAge.length < 3) {
      return as.err_invalid_participant_age;
    }

    final intParticipantAge = int.tryParse(participantAge);

    if (intParticipantAge == null) {
      return as.err_invalid_participant_age;
    }

    if (!intParticipantAge.isBetween(_minParticipantAge, _maxParticipantAge)) {
      return as.err_invalid_participant_age;
    }

    return null;
  }
}

extension on num {
  bool isBetween(num min, num max) {
    return this >= min && this <= max;
  }
}
