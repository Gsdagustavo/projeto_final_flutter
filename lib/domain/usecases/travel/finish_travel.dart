import 'package:flutter/material.dart';

import '../../entities/enums.dart';
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
  /// Throws an [Exception] if the travel has not started or is already finished.
  Future<void> call(Travel travel) async {
    debugPrint('Travel that is going to be finished: ${travel.status}');

    final now = DateTime.now();

    if (travel.status == TravelStatus.upcoming) {
      throw Exception('Travel has not started yet');
    }

    if (travel.status == TravelStatus.finished) {
      throw Exception('Travel has already been finished');
    }

    travel.endDate = now;
    travel.status = TravelStatus.finished;

    await _travelRepository.finishTravel(travel);
  }
}
