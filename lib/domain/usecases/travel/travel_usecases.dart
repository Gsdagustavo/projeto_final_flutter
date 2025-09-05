import '../../repositories/travel/travel_repository.dart';
import 'delete_travel.dart';
import 'find_travels_by_title.dart';
import 'finish_travel.dart';
import 'get_all_travels.dart';
import 'register_travel.dart';
import 'start_travel.dart';
import 'update_travel_title.dart';

/// Aggregates all travel-related use cases for easy injection and access.
class TravelUseCases {
  /// Use case for deleting a travel.
  final DeleteTravel deleteTravel;

  /// Use case for finding travels by title.
  final FindTravelsByTitle findTravelsByTitle;

  /// Use case for retrieving all travels.
  final GetAllTravels getAllTravels;

  /// Use case for finishing a travel.
  final FinishTravel finishTravel;

  /// Use case for starting a travel.
  final StartTravel startTravel;

  /// Use case for updating a travel's title.
  final UpdateTravelTitle updateTravelTitle;

  /// Use case for registering a new travel.
  final RegisterTravel registerTravel;

  /// Creates a [TravelUseCases] instance with all required use cases.
  const TravelUseCases({
    required this.deleteTravel,
    required this.findTravelsByTitle,
    required this.getAllTravels,
    required this.finishTravel,
    required this.startTravel,
    required this.updateTravelTitle,
    required this.registerTravel,
  });

  /// Factory constructor to create [TravelUseCases] with a single repository.
  factory TravelUseCases.create(TravelRepository repository) {
    return TravelUseCases(
      deleteTravel: DeleteTravel(repository),
      findTravelsByTitle: FindTravelsByTitle(repository),
      getAllTravels: GetAllTravels(repository),
      finishTravel: FinishTravel(repository),
      startTravel: StartTravel(repository),
      updateTravelTitle: UpdateTravelTitle(repository),
      registerTravel: RegisterTravel(repository),
    );
  }
}
