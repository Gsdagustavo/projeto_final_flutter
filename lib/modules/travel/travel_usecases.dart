import '../../entities/travel.dart';
import 'travel_repository.dart';

abstract class TravelUseCases {
  Future<void> registerTravel(Travel travel);

  Future<List<Travel>> getAllTravels();
}

class TravelUseCasesImpl implements TravelUseCases {
  final TravelRepository travelRepository;

  TravelUseCasesImpl(this.travelRepository);

  @override
  Future<void> registerTravel(Travel travel) async {
    /// No title
    if (travel.travelTitle.trim().isEmpty) {
      throw _TravelRegisterException('Invalid travel name');
    }

    /// Invalid start date
    if (travel.startDate == null) {
      throw _TravelRegisterException('Invalid travel start date');
    }

    /// Invalid end date
    if (travel.endDate == null) {
      throw _TravelRegisterException('Invalid travel end date');
    }

    /// No participants
    if (travel.participants.isEmpty) {
      throw _TravelRegisterException(
        'Travel must contain at least 1 participant',
      );
    }

    /// No stops
    if (travel.stops.isEmpty) {
      throw _TravelRegisterException('Travel must contain at least 1 stop');
    }

    await travelRepository.registerTravel(travel: travel);
  }

  @override
  Future<List<Travel>> getAllTravels() async {
    return await travelRepository.getAllTravels();
  }
}

class _TravelRegisterException implements Exception {
  final String message;

  _TravelRegisterException(this.message);
}
