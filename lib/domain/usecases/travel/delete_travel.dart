import '../../entities/travel.dart';
import '../../repositories/travel/travel_repository.dart';

class DeleteTravel {
  final TravelRepository _travelRepository;

  /// Default constructor
  DeleteTravel(this._travelRepository);

  Future<void> call(Travel travel) async {
    await _travelRepository.deleteTravel(travel);
  }
}
