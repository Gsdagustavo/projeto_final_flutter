import 'dart:io';

import '../../../domain/entities/enums.dart';
import '../../../domain/entities/participant.dart';
import '../../../domain/entities/place.dart';
import '../../../domain/entities/review.dart';
import '../../../domain/entities/travel.dart';
import '../../../domain/entities/travel_stop.dart';

final mockTravels = <Travel>[
  Travel(
    travelTitle: "Backpacking through Europe",
    isFinished: false,
    startDate: DateTime(2025, 5, 10),
    endDate: DateTime(2025, 5, 30),
    transportType: TransportType.bike,
    // <- wait, not in your enum! let's fix
    participants: [
      Participant(
        id: null, // also let DB assign if needed
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
            // must reference stop, but DB will resolve — use placeholder
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

  Travel(
    travelTitle: "Summer Vacation in Brazil",
    isFinished: true,
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
            // placeholder
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
];
