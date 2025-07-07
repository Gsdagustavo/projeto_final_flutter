import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'modules/travel/travel_repository.dart';
import 'modules/travel/travel_usecases.dart';
import 'presentation/providers/register_travel_provider.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/widgets/my_app.dart';
import 'services/localization_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final travelRepository = TravelRepositoryImpl();
  final travelUsecases = TravelUseCasesImpl(travelRepository);

  final pos = await LocationService().getCurrentPosition();
  debugPrint('Current position: ${pos.toString()}');

  await LocationService().getAddressByPosition(pos!);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>
              RegisterTravelProvider(travelRepository, travelUsecases),
        ),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
