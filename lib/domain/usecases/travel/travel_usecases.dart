import '../../repositories/travel/travel_repository.dart';
import 'delete_travel.dart';
import 'find_travels_by_title.dart';
import 'finish_travel.dart';
import 'get_all_travels.dart';
import 'register_travel.dart';
import 'start_travel.dart';
import 'update_travel_title.dart';

class TravelUseCases {
  final DeleteTravel deleteTravel;
  final FindTravelsByTitle findTravelsByTitle;
  final GetAllTravels getAllTravels;
  final FinishTravel finishTravel;
  final StartTravel startTravel;
  final UpdateTravelTitle updateTravelTitle;
  final RegisterTravel registerTravel;

  const TravelUseCases({
    required this.deleteTravel,
    required this.findTravelsByTitle,
    required this.getAllTravels,
    required this.finishTravel,
    required this.startTravel,
    required this.updateTravelTitle,
    required this.registerTravel,
  });

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
