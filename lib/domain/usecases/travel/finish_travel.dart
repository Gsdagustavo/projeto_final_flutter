import 'package:flutter/cupertino.dart';

import '../../entities/enums.dart';
import '../../entities/travel.dart';
import '../../repositories/travel/travel_repository.dart';

class FinishTravel {
  final TravelRepository _travelRepository;

  /// Default constructor
  FinishTravel(this._travelRepository);

  Future<void> call(Travel travel) async {
    debugPrint('Travel that is going to be finished: $travel');

    final now = DateTime.now();

    if (travel.status == TravelStatus.upcoming) {
      /// TODO: intl
      throw Exception('Cannot finish a travel that has not started yet');
    }

    if (travel.status == TravelStatus.finished) {
      /// TODO: intl
      throw Exception('Travel has already finished');
    }

    travel.endDate = now;
    travel.status = TravelStatus.finished;

    await _travelRepository.finishTravel(travel);
  }
}
