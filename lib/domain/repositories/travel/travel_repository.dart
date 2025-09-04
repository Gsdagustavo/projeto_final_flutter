import '../../../data/models/travel_model.dart';
import '../../entities/travel.dart';

/// This interface defines all necessary methods to register a [Travel]
/// and get all [Travels]
abstract interface class TravelRepository {
  /// Register a new travel
  ///
  /// [travel]: The travel which will be registered
  Future<void> registerTravel({required Travel travel});

  Future<void> deleteTravel(Travel travel);

  /// Returns a [List] of [Travel] containing all registered travels
  Future<List<Travel>> getAllTravels();

  Future<void> startTravel(Travel travel);

  Future<void> finishTravel(Travel travel);

  Future<void> updateTravelTitle(Travel travel);

  Future<List<TravelModel>> findTravelsByTitle(String title);
}
