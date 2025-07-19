import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/login_provider.dart';
import '../home_page.dart';
import 'auth_page_switcher.dart';

/// A default Splash Screen that will be shown very briefly when the app is
/// initialized
///
/// This page will redirect the user to the [HomePage], if the user has logged
/// in previously, or the [AuthPageSwitcher] page if not
class SplashScreen extends StatefulWidget {
  /// Constant constructor
  const SplashScreen({super.key});

  /// The route of the page
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
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
