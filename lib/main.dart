import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'modules/travel/travel_repository.dart';
import 'modules/travel/travel_use_cases.dart';
import 'presentation/providers/login_provider.dart';
import 'presentation/providers/register_travel_provider.dart';
import 'presentation/providers/travel_list_provider.dart';
import 'presentation/providers/user_preferences_provider.dart';
import 'presentation/widgets/my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize Firebase App
  await Firebase.initializeApp();

  /// Instantiate dependencies needed for dependency injection
  final travelRepository = TravelRepositoryImpl();
  final travelUseCases = TravelUseCasesImpl(travelRepository);

  /// Build App
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TravelListProvider(travelUseCases),
        ),
        ChangeNotifierProvider(
          create: (context) => RegisterTravelProvider(travelUseCases),
        ),
        ChangeNotifierProvider(create: (context) => UserPreferencesProvider()),
        ChangeNotifierProvider(create: (context) => LoginProvider()),
      ],
      child: const MyApp(),
    ),
  );

  /// Resets the database (only for testing, this shall be removed when in production)
  // await DBConnection().getDatabase(reset: true);

  /// Initialize dotenv
  await dotenv.load(fileName: '.env');
}
