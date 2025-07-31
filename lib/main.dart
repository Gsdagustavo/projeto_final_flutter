import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'data/local/database/database.dart';
import 'domain/entities/address.dart';
import 'domain/entities/enums.dart';
import 'domain/entities/participant.dart';
import 'domain/entities/place.dart';
import 'domain/entities/travel.dart';
import 'domain/entities/travel_stop.dart';
import 'modules/travel/travel_repository.dart';
import 'modules/travel/travel_use_cases.dart';
import 'presentation/providers/language_code_provider.dart';
import 'presentation/providers/register_travel_provider.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/providers/travel_list_provider.dart';
import 'presentation/widgets/my_app.dart';
import 'services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  final travelRepository = TravelRepositoryImpl();
  final travelUseCases = TravelUseCasesImpl(travelRepository);

  // await AuthService().signInWithEmailAndPassword(
  //   email: 'test@gmail.com',
  //   password: '123456',
  // );

  await DBConnection().getDatabase(reset: true);

  await travelUseCases.registerTravel(mockTravel);

  final travels = await travelUseCases.getAllTravels();
  debugPrint('Travels:\n$travels');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TravelListProvider(travelUseCases),
        ),
        ChangeNotifierProvider(
          create: (context) => RegisterTravelProvider(travelUseCases),
        ),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => LanguageCodeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

final mockTravel = Travel(
  travelTitle: 'oie',
  participants: [Participant(name: 'Oie', age: 15)],
  startDate: DateTime.now(),
  endDate: DateTime.now().add(Duration(days: 15)),
  transportType: TransportType.cruise,
  stops: [
    TravelStop(
      experiences: [
        Experience.visitLocalEstablishments,
        Experience.visitHistoricalPlaces,
      ],
      type: TravelStopType.start,
      arriveDate: DateTime.now().add(Duration(days: 2)),
      leaveDate: DateTime.now().add(Duration(days: 4)),
      place: Place(
        address: Address(
          tourism: 'Parque Nacional',
          city: 'Chapada dos Veadeiros',
          state: 'Goiás',
          country: 'Brasil',
          countryCode: 'BR',
        ),
        placeId: 1001,
        osmType: 'node',
        lat: -14.05,
        lon: -47.6,
        category: 'natural',
        type: 'park',
        placeRank: '25',
        addresstype: 'natural_feature',
        name: 'Cachoeira Santa Bárbara',
        displayName: 'Cachoeira Santa Bárbara, Chapada dos Veadeiros, GO',
      ),
    ),
    TravelStop(
      experiences: [
        Experience.alternativeCuisines,
        Experience.contactWithNature,
      ],
      type: TravelStopType.stop,
      arriveDate: DateTime.now().add(Duration(days: 5)),
      leaveDate: DateTime.now().add(Duration(days: 6)),
      place: Place(
        address: Address(
          tourism: 'Centro Histórico',
          city: 'Ouro Preto',
          state: 'Minas Gerais',
          country: 'Brasil',
          countryCode: 'BR',
        ),
        placeId: 1002,
        osmType: 'way',
        lat: -20.385,
        lon: -43.512,
        category: 'tourism',
        type: 'historic',
        placeRank: '30',
        addresstype: 'town',
        name: 'Igreja São Francisco de Assis',
        displayName: 'Igreja São Francisco de Assis, Ouro Preto, MG',
      ),
    ),
    TravelStop(
      experiences: [Experience.contactWithNature],
      type: TravelStopType.end,
      arriveDate: DateTime.now().add(Duration(days: 7)),
      leaveDate: DateTime.now().add(Duration(days: 9)),
      place: Place(
        address: Address(
          tourism: 'Praia',
          city: 'Florianópolis',
          state: 'Santa Catarina',
          country: 'Brasil',
          countryCode: 'BR',
        ),
        placeId: 1003,
        osmType: 'node',
        lat: -27.595,
        lon: -48.548,
        category: 'natural',
        type: 'beach',
        placeRank: '20',
        addresstype: 'resort',
        name: 'Praia Mole',
        displayName: 'Praia Mole, Florianópolis, SC',
      ),
    ),
  ],
);
