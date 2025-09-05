import 'package:flutter/material.dart';
import '../../entities/enums.dart';
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
  Future<void> call(Travel travel) async {
    debugPrint('Travel that is going to be started: ${travel.status}');

    final now = DateTime.now();

    if (travel.status == TravelStatus.ongoing) {
      throw Exception('Travel has already started');
    }

    if (travel.status == TravelStatus.finished) {
      throw Exception('Travel has already been finished');
    }

    travel.startDate = now;
    travel.status = TravelStatus.ongoing;

    await _travelRepository.startTravel(travel);
  }
}
