import '../../entities/travel.dart';
import '../../repositories/travel/travel_repository.dart';

/// Use case for updating the title of a [Travel].
class UpdateTravelTitle {
  /// Repository to handle travel persistence.
  final TravelRepository _travelRepository;

  /// Creates an instance of [UpdateTravelTitle].
  UpdateTravelTitle(this._travelRepository);

  /// Updates the travel title after validating it.
  ///
  /// Throws an [Exception] if the title is invalid.
  Future<void> call(Travel travel) async {
    if (!_validateTravelTitle(travel.travelTitle)) {
      throw Exception('Invalid travel name');
    }

    await _travelRepository.updateTravelTitle(travel);
  }

  /// Validates the travel title.
  bool _validateTravelTitle(String title) {
    return title.trim().isNotEmpty;
  }
}
