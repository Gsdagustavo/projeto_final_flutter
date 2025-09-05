import '../../entities/travel.dart';
import '../../repositories/travel/travel_repository.dart';

/// Use case for finding travels by their title.
class FindTravelsByTitle {
  /// Repository to handle travel persistence.
  final TravelRepository _travelRepository;

  /// Creates an instance of [FindTravelsByTitle].
  FindTravelsByTitle(this._travelRepository);

  /// Finds all travels whose title matches [title].
  ///
  /// Returns an empty list if [title] is empty.
  Future<List<Travel>> call(String title) async {
    if (title.trim().isEmpty) return [];
    return await _travelRepository
        .findTravelsByTitle(title)
        .then((value) => value.map((e) => e.toEntity()).toList());
  }
}
