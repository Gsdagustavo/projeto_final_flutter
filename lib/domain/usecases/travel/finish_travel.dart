import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../core/exceptions/failure.dart';
import '../../entities/enums.dart';
import '../../entities/errors.dart';
import '../../entities/travel.dart';
import '../../repositories/travel/travel_repository.dart';

/// Use case for finishing a [Travel].
class FinishTravel {
  /// Repository to handle travel persistence.
  final TravelRepository _travelRepository;

  /// Creates an instance of [FinishTravel].
  FinishTravel(this._travelRepository);

  /// Finishes the travel by updating its status and end date.
  ///
  /// Throws an [Exception] if the travel has not started or is already finished
  Future<Either<Failure<TravelError>, void>> call(Travel travel) async {
    debugPrint('Travel that is going to be finished: ${travel.status}');

    final now = DateTime.now();

    if (travel.status == TravelStatus.upcoming) {
      return Left(Failure(TravelError.notStartedYet));
    }

    if (travel.status == TravelStatus.finished) {
      return Left(Failure(TravelError.alreadyFinished));
    }

    travel.endDate = now;
    travel.status = TravelStatus.finished;

    await _travelRepository.finishTravel(travel);
    return Right(null);
  }
}
