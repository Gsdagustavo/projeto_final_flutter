import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../core/exceptions/failure.dart';
import '../../../core/extensions/string_extensions.dart';
import '../../entities/enums.dart';
import '../../entities/errors.dart';
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
  Future<Either<Failure, void>> call(Travel travel) async {
    travel.travelTitle.trim();

    if (travel.startDate.isAfter(travel.endDate)) {
      log(
        '[REGISTER TRAVEL USECASE] travel start date cannot be after travel '
        'end date. start date: ${travel.startDate} '
        '| end date: ${travel.endDate}',
        error: Exception('Invalid travel dates'),
        time: DateTime.now(),
        name: 'Invalid travel dates',
      );

      return Left(Failure(TravelError.invalidTravelTitle));
    }

    if (travel.travelTitle.isEmpty) {
      log(
        '[REGISTER TRAVEL USECASE] invalid travel title: ${travel.travelTitle}',
        error: TravelError.invalidTravelTitle,
        time: DateTime.now(),
        name: 'Invalid travel title',
      );
      return Left(Failure(TravelError.invalidTravelTitle));
    }

    if (travel.stops.isEmpty || travel.stops.length < 2) {
      log(
        '[REGISTER TRAVEL USECASE] not enough stops. '
        'stops: ${travel.stops.length}',
        error: TravelError.notEnoughStops,
        time: DateTime.now(),
        name: 'Not enough stops',
      );
      return Left(Failure(TravelError.notEnoughStops));
    }

    if (travel.participants.isEmpty) {
      log(
        '[REGISTER TRAVEL USECASE] no participants',
        error: TravelError.noParticipants,
        time: DateTime.now(),
        name: 'No participants',
      );
      return Left(Failure(TravelError.noParticipants));
    }

    if (!isParticipantInfoValid(travel.participants)) {
      log(
        '[REGISTER TRAVEL USECASE] invalid participant data',
        error: TravelError.invalidParticipantData,
        time: DateTime.now(),
        name: 'Invalid participant data',
      );
      return Left(Failure(TravelError.invalidParticipantData));
    }

    for (var i = 0; i < travel.stops.length; i++) {
      for (var j = i; j < travel.stops.length; j++) {
        if (i == j) continue;

        if (travel.stops[i].arriveDate!.isAfter(travel.stops[j].arriveDate!)) {
          log(
            '[REGISTER TRAVEL USECASE] invalid travel stop dates '
            '| stop 1 arrive date: ${travel.stops[i].arriveDate} '
            '| stop 2 arrive date: ${travel.stops[j].arriveDate}',
            error: TravelError.invalidStopDates,
            time: DateTime.now(),
            name: 'Invalid travel stop dates',
          );
          return Left(Failure(TravelError.invalidStopDates));
        }

        if (travel.stops[i].leaveDate!.isAfter(travel.stops[j].arriveDate!)) {
          log(
            '[REGISTER TRAVEL USECASE] invalid travel stop dates '
            '| stop 1 leave date: ${travel.stops[i].leaveDate} '
            '| stop 2 arrive date: ${travel.stops[j].arriveDate}',
            error: TravelError.invalidStopDates,
            time: DateTime.now(),
            name: 'Invalid travel stop dates',
          );
          return Left(Failure(TravelError.invalidStopDates));
        }
      }
    }

    travel.stops.map((e) => e.type = TravelStopType.stop);
    travel.stops.first.type = TravelStopType.start;
    travel.stops.last.type = TravelStopType.end;

    final finalTravel = travel.copyWith(
      participants: _validateParticipants(travel.participants),
    );

    log('Travel that is going to be registered: $finalTravel');

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
