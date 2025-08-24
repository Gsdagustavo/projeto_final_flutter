import 'dart:io';

import '../../../domain/entities/enums.dart';
import '../../../domain/entities/participant.dart';
import '../../../domain/entities/place.dart';
import '../../../domain/entities/review.dart';
import '../../../domain/entities/travel.dart';
import '../../../domain/entities/travel_stop.dart';

final mockTravels = <Travel>[
  // 1. Europe Backpacking
  Travel(
    travelTitle: "Backpacking through Europe",
    status: TravelStatus.upcoming,
    startDate: DateTime(2025, 5, 10),
    endDate: DateTime(2025, 5, 30),
    transportType: TransportType.bike,
    participants: [
      Participant(
        id: null,
        name: "Alice",
        age: 25,
        profilePicture: File("assets/images/alice.png"),
      ),
      Participant(
        id: null,
        name: "Bob",
        age: 28,
        profilePicture: File("assets/images/bob.png"),
      ),
    ],
    stops: [
      TravelStop(
        place: Place(
          id: "paris_fr",
          city: "Paris",
          state: "Île-de-France",
          country: "France",
          countryCode: "FR",
          latitude: 48.8566,
          longitude: 2.3522,
        ),
        arriveDate: DateTime(2025, 5, 10),
        leaveDate: DateTime(2025, 5, 15),
        type: TravelStopType.start,
        reviews: [
          Review(
            description: "Amazing city, loved the Eiffel Tower at night!",
            author: Participant(
              name: "Alice",
              age: 25,
              profilePicture: File("assets/images/alice.png"),
            ),
            reviewDate: DateTime(2025, 5, 15),
            travelStopId: 0,
            stars: 5,
          ),
        ],
      ),
      TravelStop(
        place: Place(
          id: "berlin_de",
          city: "Berlin",
          state: "Berlin",
          country: "Germany",
          countryCode: "DE",
          latitude: 52.5200,
          longitude: 13.4050,
        ),
        arriveDate: DateTime(2025, 5, 16),
        leaveDate: DateTime(2025, 5, 20),
        type: TravelStopType.stop,
      ),
    ],
  ),

  // 2. Brazil Vacation
  Travel(
    travelTitle: "Summer Vacation in Brazil",
    status: TravelStatus.ongoing,
    startDate: DateTime(2024, 12, 20),
    endDate: DateTime(2025, 1, 5),
    transportType: TransportType.plane,
    participants: [
      Participant(
        id: null,
        name: "Carlos",
        age: 30,
        profilePicture: File("assets/images/carlos.png"),
      ),
    ],
    stops: [
      TravelStop(
        place: Place(
          id: "rio_br",
          city: "Rio de Janeiro",
          state: "RJ",
          country: "Brazil",
          countryCode: "BR",
          latitude: -22.9068,
          longitude: -43.1729,
        ),
        arriveDate: DateTime(2024, 12, 20),
        leaveDate: DateTime(2024, 12, 28),
        type: TravelStopType.start,
        reviews: [
          Review(
            description:
                "Copacabana beach was fantastic, carnival vibes everywhere!",
            author: Participant(
              name: "Carlos",
              age: 30,
              profilePicture: File("assets/images/carlos.png"),
            ),
            reviewDate: DateTime(2024, 12, 28),
            travelStopId: 0,
            stars: 4,
          ),
        ],
      ),
      TravelStop(
        place: Place(
          id: "salvador_br",
          city: "Salvador",
          state: "BA",
          country: "Brazil",
          countryCode: "BR",
          latitude: -12.9777,
          longitude: -38.5016,
        ),
        arriveDate: DateTime(2024, 12, 29),
        leaveDate: DateTime(2025, 1, 5),
        type: TravelStopType.end,
      ),
    ],
  ),

  // 3. Ski Trip in Switzerland
  Travel(
    travelTitle: "Ski Trip in Switzerland",
    status: TravelStatus.finished,
    startDate: DateTime(2024, 1, 10),
    endDate: DateTime(2024, 1, 20),
    transportType: TransportType.car,
    participants: [
      Participant(
        id: null,
        name: "Diana",
        age: 27,
        profilePicture: File("assets/images/diana.png"),
      ),
    ],
    stops: [
      TravelStop(
        place: Place(
          id: "zermatt_ch",
          city: "Zermatt",
          state: "Valais",
          country: "Switzerland",
          countryCode: "CH",
          latitude: 46.0207,
          longitude: 7.7491,
        ),
        arriveDate: DateTime(2024, 1, 10),
        leaveDate: DateTime(2024, 1, 20),
        type: TravelStopType.start,
        reviews: [
          Review(
            description:
                "Ski slopes were incredible, and the fondue was great!",
            author: Participant(
              name: "Diana",
              age: 27,
              profilePicture: File("assets/images/diana.png"),
            ),
            reviewDate: DateTime(2024, 1, 20),
            travelStopId: 0,
            stars: 5,
          ),
        ],
      ),
    ],
  ),

  // 4. Cruise in the Caribbean
  Travel(
    travelTitle: "Caribbean Cruise",
    status: TravelStatus.upcoming,
    startDate: DateTime(2025, 11, 1),
    endDate: DateTime(2025, 11, 14),
    transportType: TransportType.cruise,
    participants: [
      Participant(
        id: null,
        name: "Evelyn",
        age: 35,
        profilePicture: File("assets/images/evelyn.png"),
      ),
      Participant(
        id: null,
        name: "Frank",
        age: 40,
        profilePicture: File("assets/images/frank.png"),
      ),
    ],
    stops: [
      TravelStop(
        place: Place(
          id: "nassau_bs",
          city: "Nassau",
          state: "New Providence",
          country: "Bahamas",
          countryCode: "BS",
          latitude: 25.0443,
          longitude: -77.3504,
        ),
        arriveDate: DateTime(2025, 11, 1),
        leaveDate: DateTime(2025, 11, 5),
        type: TravelStopType.start,
      ),
      TravelStop(
        place: Place(
          id: "san_juan_pr",
          city: "San Juan",
          state: "PR",
          country: "Puerto Rico",
          countryCode: "PR",
          latitude: 18.4655,
          longitude: -66.1057,
        ),
        arriveDate: DateTime(2025, 11, 6),
        leaveDate: DateTime(2025, 11, 10),
        type: TravelStopType.stop,
      ),
      TravelStop(
        place: Place(
          id: "miami_us",
          city: "Miami",
          state: "FL",
          country: "USA",
          countryCode: "US",
          latitude: 25.7617,
          longitude: -80.1918,
        ),
        arriveDate: DateTime(2025, 11, 11),
        leaveDate: DateTime(2025, 11, 14),
        type: TravelStopType.end,
      ),
    ],
  ),

  // 5. Road Trip across the US
  Travel(
    travelTitle: "USA Road Trip",
    status: TravelStatus.ongoing,
    startDate: DateTime(2025, 3, 1),
    endDate: DateTime(2025, 4, 1),
    transportType: TransportType.car,
    participants: [
      Participant(
        id: null,
        name: "George",
        age: 33,
        profilePicture: File("assets/images/george.png"),
      ),
    ],
    stops: [
      TravelStop(
        place: Place(
          id: "nyc_us",
          city: "New York",
          state: "NY",
          country: "USA",
          countryCode: "US",
          latitude: 40.7128,
          longitude: -74.0060,
        ),
        arriveDate: DateTime(2025, 3, 1),
        leaveDate: DateTime(2025, 3, 7),
        type: TravelStopType.start,
      ),
      TravelStop(
        place: Place(
          id: "chicago_us",
          city: "Chicago",
          state: "IL",
          country: "USA",
          countryCode: "US",
          latitude: 41.8781,
          longitude: -87.6298,
        ),
        arriveDate: DateTime(2025, 3, 8),
        leaveDate: DateTime(2025, 3, 15),
        type: TravelStopType.stop,
      ),
      TravelStop(
        place: Place(
          id: "la_us",
          city: "Los Angeles",
          state: "CA",
          country: "USA",
          countryCode: "US",
          latitude: 34.0522,
          longitude: -118.2437,
        ),
        arriveDate: DateTime(2025, 3, 20),
        leaveDate: DateTime(2025, 4, 1),
        type: TravelStopType.end,
      ),
    ],
  ),
];
