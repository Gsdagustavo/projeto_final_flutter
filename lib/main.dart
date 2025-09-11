import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'data/local/database/database.dart';
import 'data/repositories/review/sqlite_review_repository.dart';
import 'data/repositories/travel/sqlite_travel_repository.dart';
import 'domain/usecases/review/review_use_cases.dart';
import 'domain/usecases/travel/travel_usecases.dart';
import 'presentation/providers/login_provider.dart';
import 'presentation/providers/map_markers_provider.dart';
import 'presentation/providers/register_travel_provider.dart';
import 'presentation/providers/review_provider.dart';
import 'presentation/providers/travel_list_provider.dart';
import 'presentation/providers/user_preferences_provider.dart';
import 'presentation/util/mock_data.dart';
import 'presentation/widgets/my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize Firebase App
  await Firebase.initializeApp();

  /// Instantiate dependencies needed for dependency injection
  final travelRepository = SQLiteTravelRepository();
  final travelUseCases = TravelUseCases.create(travelRepository);

  final reviewRepository = SQLiteReviewRepository();
  final reviewUseCases = ReviewUseCases.create(reviewRepository);

  // await testDB(travelUseCases);

  /// Build App
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MapMarkersProvider()),
        ChangeNotifierProvider(
          create: (context) => TravelListProvider(travelUseCases),
        ),
        ChangeNotifierProvider(
          create: (context) => RegisterTravelProvider(travelUseCases),
        ),
        ChangeNotifierProvider(create: (context) => UserPreferencesProvider()),
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(
          create: (context) => ReviewProvider(reviewUseCases),
        ),
      ],
      child: const MyApp(),
    ),
  );

  /// Initialize dotenv
  await dotenv.load(fileName: '.env');
}

Future<void> testDB(TravelUseCases travelUseCases) async {
  final db = await DBConnection().getDatabase(delete: true);
  await DBConnection().printAllTables(db);

  final travels = await generateSampleTravels();
  travels.forEach(travelUseCases.registerTravel.call);
}
