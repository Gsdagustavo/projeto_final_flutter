import '../../domain/entities/enums.dart';
import '../../domain/entities/participant.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/travel.dart';
import '../../domain/entities/travel_stop.dart';
import '../../services/file_service.dart';

Future<List<Travel>> generateSampleTravels() async {
  final defaultPfp = await FileService().getDefaultProfilePictureFile();

  return [
    Travel(
      photos: [],
      travelTitle: 'Exploring Rio de Janeiro',
      startDate: DateTime(2025, 1, 10),
      endDate: DateTime(2025, 1, 20),
      transportType: TransportType.plane,
      status: TravelStatus.finished,
      participants: [
        Participant(
          id: 1,
          name: 'Ana Silva',
          age: 25,
          profilePicture: defaultPfp,
        ),
        Participant(
          id: 2,
          name: 'João Souza',
          age: 30,
          profilePicture: defaultPfp,
        ),
      ],
      stops: [
        TravelStop(
          experiences: [Experience.cultureImmersion, Experience.socialEvents],
          place: Place(
            id: 'p1',
            city: 'Rio de Janeiro',
            state: 'RJ',
            country: 'Brazil',
            countryCode: 'BR',
            latitude: -22.9068,
            longitude: -43.1729,
          ),
          type: TravelStopType.start,
        ),
      ],
    ),
    Travel(
      photos: [],
      travelTitle: 'Discovering Paris',
      startDate: DateTime(2025, 3, 5),
      endDate: DateTime(2025, 3, 15),
      transportType: TransportType.plane,
      status: TravelStatus.upcoming,
      participants: [
        Participant(
          id: 3,
          name: 'Marie Dupont',
          age: 28,
          profilePicture: defaultPfp,
        ),
        Participant(
          id: 4,
          name: 'Pierre Martin',
          age: 35,
          profilePicture: defaultPfp,
        ),
      ],
      stops: [
        TravelStop(
          experiences: [
            Experience.alternativeCuisines,
            Experience.visitHistoricalPlaces,
          ],
          place: Place(
            id: 'p2',
            city: 'Paris',
            state: 'Île-de-France',
            country: 'France',
            countryCode: 'FR',
            latitude: 48.8566,
            longitude: 2.3522,
          ),
          type: TravelStopType.start,
        ),
      ],
    ),
  ];
}
