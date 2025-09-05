import '../../entities/travel.dart';
import '../../repositories/travel/travel_repository.dart';

/// Use case for retrieving all travels.
class GetAllTravels {
  /// Repository to handle travel persistence.
  final TravelRepository _travelRepository;

  /// Creates an instance of [GetAllTravels].
  GetAllTravels(this._travelRepository);

  /// Returns a list of all registered travels.
  Future<List<Travel>> call() async {
    return await _travelRepository.getAllTravels();
  }
}
