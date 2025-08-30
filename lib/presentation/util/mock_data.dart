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
      startDate: DateTime(2025, 8, 30),
      endDate: DateTime(2026, 9, 1),
      transportType: TransportType.plane,
      status: TravelStatus.upcoming,
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
          arriveDate: DateTime(2025, 8, 30, 9, 0),
          leaveDate: DateTime(2026, 8, 30, 18, 0),
        ),
        TravelStop(
          experiences: [Experience.visitLocalEstablishments],
          place: Place(
            id: 'p2',
            city: 'Niterói',
            state: 'RJ',
            country: 'Brazil',
            countryCode: 'BR',
            latitude: -22.8832,
            longitude: -43.1034,
          ),
          type: TravelStopType.stop,
          arriveDate: DateTime(2025, 8, 31, 9, 0),
          leaveDate: DateTime(2026, 8, 31, 17, 0),
        ),
        TravelStop(
          experiences: [Experience.alternativeCuisines],
          place: Place(
            id: 'p3',
            city: 'Angra dos Reis',
            state: 'RJ',
            country: 'Brazil',
            countryCode: 'BR',
            latitude: -23.0064,
            longitude: -44.3186,
          ),
          type: TravelStopType.end,
          arriveDate: DateTime(2025, 9, 1, 10, 0),
          leaveDate: DateTime(2026, 9, 1, 20, 0),
        ),
      ],
    ),
    Travel(
      photos: [],
      travelTitle: 'Discovering Paris',
      startDate: DateTime(2026, 3, 5),
      endDate: DateTime(2026, 3, 15),
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
            id: 'p4',
            city: 'Paris',
            state: 'Île-de-France',
            country: 'France',
            countryCode: 'FR',
            latitude: 48.8566,
            longitude: 2.3522,
          ),
          type: TravelStopType.start,
          arriveDate: DateTime(2026, 3, 5, 8, 0),
          leaveDate: DateTime(2026, 3, 8, 20, 0),
        ),
        TravelStop(
          experiences: [Experience.cultureImmersion],
          place: Place(
            id: 'p5',
            city: 'Versailles',
            state: 'Île-de-France',
            country: 'France',
            countryCode: 'FR',
            latitude: 48.8049,
            longitude: 2.1204,
          ),
          type: TravelStopType.stop,
          arriveDate: DateTime(2026, 3, 9, 9, 0),
          leaveDate: DateTime(2026, 3, 11, 18, 0),
        ),
        TravelStop(
          experiences: [Experience.socialEvents],
          place: Place(
            id: 'p6',
            city: 'Lyon',
            state: 'Auvergne-Rhône-Alpes',
            country: 'France',
            countryCode: 'FR',
            latitude: 45.7640,
            longitude: 4.8357,
          ),
          type: TravelStopType.end,
          arriveDate: DateTime(2026, 3, 12, 10, 0),
          leaveDate: DateTime(2026, 3, 15, 22, 0),
        ),
      ],
    ),
  ];
}
