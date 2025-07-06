import '../../entities/travel.dart';
import 'travel_repository.dart';

abstract class TravelUseCases {
  Future<void> registerTravel(Travel travel);
}

class TravelUseCasesImpl implements TravelUseCases {
  final TravelRepository travelRepository;

  TravelUseCasesImpl(this.travelRepository);

  @override
  Future<void> registerTravel(Travel travel) async {
    /// No title
    if (travel.travelTitle.trim().isEmpty) {
      throw Exception('Invalid travel name');
    }

    /// No stops
    if (travel.stops.isEmpty) {
      throw Exception('Travel must contain at least 1 stop');
    }

    /// No participants
    if (travel.participants.isEmpty) {
      throw Exception('Travel must contain at least 1 participant');
    }

    /// Invalid start date
    if (travel.startDate == null) {
      throw Exception('Invalid travel start date');
    }

    /// Invalid end date
    if (travel.endDate == null) {
      throw Exception('Invalid travel end date');
    }

    await travelRepository.registerTravel(travel: travel);
  }
}
