import 'package:flutter/material.dart';

import '../../../services/auth_service.dart';
import '../home_page.dart';
import 'auth_page_switcher.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String routeName = '/splashScreen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    AuthService().currentUser().then((user) {
      if (user == null) {
        Navigator.pushReplacementNamed(context, AuthPageSwitcher.routeName);
      } else {
        Navigator.pushNamed(context, HomePage.routeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
