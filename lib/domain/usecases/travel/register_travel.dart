import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/extensions/string_extensions.dart';
import '../../entities/enums.dart';
import '../../entities/participant.dart';
import '../../entities/travel.dart';
import '../../repositories/travel/travel_repository.dart';

class RegisterTravel {
  final TravelRepository _travelRepository;

  /// Default constructor
  RegisterTravel(this._travelRepository);

  Future<Either<Failure<TravelRegisterError>, void>> call(Travel travel) async {
    /// No title
    if (travel.travelTitle.trim().isEmpty) {
      return Left(
        Failure<TravelRegisterError>(TravelRegisterError.invalidTitle),
      );
    }

    /// No stops
    if (travel.stops.isEmpty || travel.stops.length < 2) {
      return Left(
        Failure<TravelRegisterError>(TravelRegisterError.notEnoughStops),
      );
    }

    /// No participants
    if (travel.participants.isEmpty) {
      return Left(
        Failure<TravelRegisterError>(TravelRegisterError.noParticipants),
      );
    }

    /// A(some) participant(s) has invalid data
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

    /// Register travel
    await _travelRepository.registerTravel(travel: finalTravel);
    return Right(null);
  }

  List<Participant> _validateParticipants(List<Participant> participants) {
    return participants.map((p) {
      return p.copyWith(name: p.name.capitalizedAndSpaced);
    }).toList();
  }

  bool isParticipantInfoValid(List<Participant> participants) {
    return participants.every((p) {
          /// Invalid name
          if (p.name.isEmpty) {
            debugPrint('${p.name} is an invalid name');
            return false;
          }

          /// Short name
          if (p.name.length < 3) {
            debugPrint('${p.name} is an invalid name');
            return false;
          }

          /// Invalid age
          if (p.age < 0 || p.age >= 120) {
            debugPrint('${p.age} is an invalid age');
            return false;
          }

          return true;
        }) &&
        participants.isNotEmpty;
  }
}

class Failure<T> {
  final T type;
  final Map<String, dynamic>? params;

  Failure(this.type, {this.params});
}

enum TravelRegisterError {
  invalidTitle,
  notEnoughStops,
  noParticipants,
  invalidParticipantData,
  invalidStopDates,
}
