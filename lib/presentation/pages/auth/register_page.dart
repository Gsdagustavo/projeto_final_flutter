import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
import '../../providers/login_provider.dart';
import '../../widgets/custom_dialog.dart';
import '../home_page.dart';

/// A [Register] page
///
/// Contains text fields for [email] and [password]
///
/// Contains also a button to [Register] the user
/// [ForgotPasswordPage]
class RegisterPage extends StatefulWidget {
  /// Constant constructor
  const RegisterPage({super.key});

  /// The route of the page
  static const String routeName = '/register';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  String? _passwordValidator(String? password) {
    if (password == null || password.isEmpty) {
      return 'Invalid Password';
    }

    if (password.length <= 3) {
      return 'Password too short';
    }

    return null;
  }

  String? _emailValidator(String? email) {
    if (email == null || email.isEmpty) {
      return 'Invalid Email';
    }

    return null;
  }

  void _register() async {
    if (!_formKey.currentState!.validate()) return;

    final as = AppLocalizations.of(context)!;

    final email = _emailController.text;
    final password = _passwordController.text;

    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    /// Try to create user
    await loginProvider.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    /// Check if any error has occurred while trying to create the user
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

    /// Try to sign in
    await loginProvider.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    /// Check if any error has occurred while trying to sign in
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

    /// Shows a successful feedback dialog
    await showDialog(
      context: context,
      builder: (_) => CustomDialog(
        title: as.register,
        content: Text(as.account_created_successfully),
      ),
    );

    /// Shows a dialog for the user to continue to login
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Login'),
        content: Text(as.register_login),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () {
              context.pop();
            },
            child: Text(as.no),
          ),

          ElevatedButton(
            onPressed: () {
              context.go(HomePage.routeName);
            },
            child: Text(as.yes),
          ),
        ],
      ),
    );
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
                Text(
                  as.register,
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Padding(padding: EdgeInsets.all(86)),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: _emailValidator,
                        controller: _emailController,
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
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(as.register),
                      ),
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
