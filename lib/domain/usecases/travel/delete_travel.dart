import '../../entities/travel.dart';
import '../../repositories/travel/travel_repository.dart';

/// Use case for deleting a [Travel].
class DeleteTravel {
  /// Repository to handle travel persistence.
  final TravelRepository _travelRepository;

  /// Creates an instance of [DeleteTravel].
  DeleteTravel(this._travelRepository);

  /// Deletes the given [travel] from the repository.
  Future<void> call(Travel travel) async {
    await _travelRepository.deleteTravel(travel);
  }
}
