import '../../entities/enums.dart';
import '../../entities/travel.dart';
import '../../repositories/travel/travel_repository.dart';

class StartTravel {
  final TravelRepository _travelRepository;

  /// Default constructor
  StartTravel(this._travelRepository);

  Future<void> call(Travel travel) async {
    print('Travel that is going to be started: ${travel.status}');

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
