import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'data/local/modules/travel/travel_repository.dart';
import 'data/local/modules/travel/travel_usecases.dart';
import 'data/remote/modules/auth.dart';
import 'presentation/providers/language_code_provider.dart';
import 'presentation/providers/register_travel_provider.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/widgets/my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  final travelRepository = TravelRepositoryImpl();
  final travelUsecases = TravelUseCasesImpl(travelRepository);

  final user1 = await Auth().signinWithEmailAndPassword(
    email: 'gsdagustavo@gmail.com',
    password: '123456',
  );

  final user2 = await Auth().signinWithEmailAndPassword(
    email: 'gsdagustavawd@gmail.com',
    password: '12',
  );

  debugPrint('User 1: ${user1.toString()}');
  debugPrint('User 2: ${user2.toString()}');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => RegisterTravelProvider(travelUsecases),
        ),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => LanguageCodeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
