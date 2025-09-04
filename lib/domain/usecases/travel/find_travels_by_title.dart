import '../../entities/travel.dart';
import '../../repositories/travel/travel_repository.dart';

class FindTravelsByTitle {
  final TravelRepository _travelRepository;

  /// Default constructor
  FindTravelsByTitle(this._travelRepository);

  Future<List<Travel>> call(String title) async {
    if (title.trim().isEmpty) {
      return [];
    }

    return await _travelRepository
        .findTravelsByTitle(title)
        .then((value) => value.map((e) => e.toEntity()).toList());
  }
}
