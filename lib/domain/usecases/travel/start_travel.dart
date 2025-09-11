import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../core/exceptions/failure.dart';
import '../../entities/enums.dart';
import '../../entities/errors.dart';
import '../../entities/travel.dart';
import '../../repositories/travel/travel_repository.dart';

/// Use case for starting a [Travel].
class StartTravel {
  /// Repository to handle travel persistence.
  final TravelRepository _travelRepository;

  /// Creates an instance of [StartTravel].
  StartTravel(this._travelRepository);

  /// Starts the travel by updating its status and start date.
  ///
  /// Throws an [Exception] if the travel has already started or finished.
  Future<Either<Failure<TravelError>, void>> call(Travel travel) async {
    debugPrint('Travel that is going to be started: ${travel.status}');

    final now = DateTime.now();

    if (travel.status == TravelStatus.ongoing) {
      return Left(Failure(TravelError.alreadyStarted));
    }

    if (travel.status == TravelStatus.finished) {
      return Left(Failure(TravelError.alreadyFinished));
    }

    travel.startDate = now;
    travel.status = TravelStatus.ongoing;

    await _travelRepository.startTravel(travel);
    return Right(null);
  }
}


