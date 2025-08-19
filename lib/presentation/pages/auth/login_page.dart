import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
import '../../providers/login_provider.dart';
import '../../widgets/custom_dialog.dart';
import '../home_page.dart';
import 'forgot_password_page.dart';

/// A [Login] page
///
/// Contains text fields for [email] and [password]
///
/// Contains also a button to realize the [Login] and a
/// '[Forgot Your Password?]' button, that redirects the user to the
/// [ForgotPasswordPage]
class LoginPage extends StatefulWidget {
  /// Constant constructor
  const LoginPage({super.key});

  /// The route of the page
  static const String routeName = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController(text: 'test@gmail.com');
  final _passwordController = TextEditingController(text: '123456');

  bool _obscurePassword = true;

  String? _emailValidator(String? email) {
    if (email == null || email.isEmpty || !email.contains('@')) {
      return 'Invalid Email';
    }

    return null;
  }

  String? _passwordValidator(String? password) {
    if (password == null || password.isEmpty) {
      return 'Invalid Password';
    }

    return null;
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    final as = AppLocalizations.of(context)!;

    final email = _emailController.text;
    final password = _passwordController.text;

    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    await loginProvider.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (!mounted) return;

    if (loginProvider.hasError) {
      unawaited(
        showDialog(
          context: context,
          builder: (_) => CustomDialog(
            title: as.warning,
            content: Text(loginProvider.errorMsg),
            isError: true,
          ),
        ),
      );

      return;
    }

    await showDialog(
      context: context,
      builder: (_) => CustomDialog(
        title: 'Login',
        content: Text(as.logged_in_successfully),
      ),
    );

    context.go(HomePage.routeName);
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Login',
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),

                const Padding(padding: EdgeInsets.all(86)),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      /// Email text field
                      TextFormField(
                        validator: _emailValidator,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        onTapUpOutside: (_) => FocusScope.of(context).unfocus(),
                        decoration: InputDecoration(
                          hintText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.email),
                        ),
                      ),

                      const Padding(padding: EdgeInsets.all(18)),

                      /// Password text field
                      TextFormField(
                        validator: _passwordValidator,
                        controller: _passwordController,
                        onTapUpOutside: (_) => FocusScope.of(context).unfocus(),
                        decoration: InputDecoration(
                          hintText: as.password,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            onPressed: _togglePasswordVisibility,
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                        ),

                        obscureText: _obscurePassword,
                      ),
                    ],
                  ),
                ),

                const Padding(padding: EdgeInsets.all(16)),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text('Login'),
                      ),
                    ),

                    const Padding(padding: EdgeInsets.all(16)),

                    /// 'Forgot your password?' button
                    TextButton(
                      child: Text(as.forgot_your_password),
                      onPressed: () {
                        context.go(ForgotPasswordPage.routeName);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
