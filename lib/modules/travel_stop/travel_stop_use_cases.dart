import '../../domain/entities/travel_stop.dart';
import 'travel_stop_repository.dart';

abstract interface class TravelStopUseCases {
  Future<void> registerTravelStops({
    required Iterable<TravelStop> stops,
    required int travelId,
  });

  Future<List<TravelStop>?> getTravelStops();
}

final class TravelStopUseCasesImpl implements TravelStopUseCases {
  final TravelStopRepositoryImpl _travelStopRepository;

  TravelStopUseCasesImpl(this._travelStopRepository);

  @override
  Future<List<TravelStop>?> getTravelStops() async {
    final stopsModels = await _travelStopRepository.getTravelStops();
    final stops = <TravelStop>[];

    if (stopsModels == null) return null;

    return stopsModels.map((s) => s.toEntity()).toList();
  }

  @override
  Future<void> registerTravelStops({
    required Iterable<TravelStop> stops,
    required int travelId,
  }) async {
    await _travelStopRepository.registerTravelStops(
      stops: stops,
      travelId: travelId,
    );
  }
}
