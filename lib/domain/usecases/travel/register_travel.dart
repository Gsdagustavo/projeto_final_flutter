import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../core/exceptions/failure.dart';
import '../../../core/extensions/string_extensions.dart';
import '../../entities/enums.dart';
import '../../entities/participant.dart';
import '../../entities/travel.dart';
import '../../repositories/travel/travel_repository.dart';

/// Use case for registering a new [Travel].
class RegisterTravel {
  /// Repository to handle travel persistence.
  final TravelRepository _travelRepository;

  /// Creates an instance of [RegisterTravel].
  RegisterTravel(this._travelRepository);

  /// Registers a new travel, performing all necessary validations.
  ///
  /// Returns a [Failure] if any validation fails.
  Future<Either<Failure<TravelRegisterError>, void>> call(Travel travel) async {
    if (travel.travelTitle.trim().isEmpty) {
      return Left(
        Failure<TravelRegisterError>(TravelRegisterError.invalidTravelTitle),
      );
    }

    if (travel.stops.isEmpty || travel.stops.length < 2) {
      return Left(
        Failure<TravelRegisterError>(TravelRegisterError.notEnoughStops),
      );
    }

    if (travel.participants.isEmpty) {
      return Left(
        Failure<TravelRegisterError>(TravelRegisterError.noParticipants),
      );
    }

    if (!isParticipantInfoValid(travel.participants)) {
      return Left(
        Failure<TravelRegisterError>(
          TravelRegisterError.invalidParticipantData,
        ),
      );
    }

    travel.stops.first.type = TravelStopType.start;
    travel.stops.last.type = TravelStopType.end;
    travel.stops.map((e) => e.type = TravelStopType.stop);

    final finalTravel = travel.copyWith(
      participants: _validateParticipants(travel.participants),
    );

    debugPrint('Travel that is going to be registered: $finalTravel');

    await _travelRepository.registerTravel(travel: finalTravel);
    return Right(null);
  }

  /// Validates and formats participant names.
  List<Participant> _validateParticipants(List<Participant> participants) {
    return participants
        .map((p) => p.copyWith(name: p.name.capitalizedAndSpaced))
        .toList();
  }

  /// Checks if all participants have valid information.
  bool isParticipantInfoValid(List<Participant> participants) {
    return participants.every((p) {
          if (p.name.isEmpty || p.name.length < 3) {
            debugPrint('${p.name} is an invalid name');
            return false;
          }
          if (p.age < 0 || p.age >= 120) {
            debugPrint('${p.age} is an invalid age');
            return false;
          }
          return true;
        }) &&
        participants.isNotEmpty;
  }
}

/// Errors that can occur during travel registration.
enum TravelRegisterError {
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
