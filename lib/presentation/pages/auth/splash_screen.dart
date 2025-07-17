import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/login_provider.dart';
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = Provider.of<LoginProvider>(
        context,
        listen: false,
      ).loggedUser;
      if (user == null) {
        Navigator.pushReplacementNamed(context, AuthPageSwitcher.routeName);
      } else {
        Navigator.pushReplacementNamed(context, HomePage.routeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
