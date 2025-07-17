import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'modules/travel/travel_repository.dart';
import 'modules/travel/travel_usecases.dart';
import 'presentation/providers/language_code_provider.dart';
import 'presentation/providers/login_provider.dart';
import 'presentation/providers/register_travel_provider.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/widgets/my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  final travelRepository = TravelRepositoryImpl();
  final travelUsecases = TravelUseCasesImpl(travelRepository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => RegisterTravelProvider(travelUsecases),
        ),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => LanguageCodeProvider()),
        ChangeNotifierProvider(create: (context) => LoginProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
