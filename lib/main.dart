import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'ui/providers/register_travel_provider.dart';
import 'ui/providers/theme_provider.dart';
import 'ui/widgets/my_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RegisterTravelProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
