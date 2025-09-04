import '../../entities/travel.dart';
import '../../repositories/travel/travel_repository.dart';

class UpdateTravelTitle {
  final TravelRepository __travelRepository;

  /// Default constructor
  UpdateTravelTitle(this.__travelRepository);

  Future<void> call(Travel travel) async {
    if (!_validateTravelTitle(travel.travelTitle)) {
      throw Exception('Invalid travel name');
    }

    await __travelRepository.updateTravelTitle(travel);
  }

  bool _validateTravelTitle(String title) {
    if (title.trim().isEmpty) {
      // throw TravelRegisterException('Invalid travel name');
      return false;
    }

    /// TODO: add more validations

    return true;
  }
}
