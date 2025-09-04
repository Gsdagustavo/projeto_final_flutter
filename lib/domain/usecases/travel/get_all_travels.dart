import '../../entities/travel.dart';
import '../../repositories/travel/travel_repository.dart';

class GetAllTravels {
  final TravelRepository _travelRepository;

  /// Default constructor
  GetAllTravels(this._travelRepository);

  Future<List<Travel>> call() async {
    return await _travelRepository.getAllTravels();
  }
}
