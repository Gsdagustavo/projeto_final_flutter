import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
import '../../providers/login_provider.dart';
import '../../util/app_routes.dart';
import '../../widgets/fab_auth_animation.dart';
import '../../widgets/loading_dialog.dart';
import '../../widgets/modals.dart';
import '../util/form_validations.dart';
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

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController(text: 'test@gmail.com');
  final _passwordController = TextEditingController(text: '123456');

  bool _obscurePassword = true;

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    final as = AppLocalizations.of(context)!;

    final email = _emailController.text;
    final password = _passwordController.text;

    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    await showLoadingDialog(
      context: context,
      function: () => loginProvider.signInWithEmailAndPassword(
        email: email,
        password: password,
      ),
    );

    if (!mounted) return;

    if (loginProvider.hasError) {
      await showDialog(
        context: context,
        builder: (context) => ErrorModal(message: loginProvider.errorMsg),
      );

      return;
    }

    await showDialog(
      context: context,
      builder: (context) => SuccessModal(message: as.logged_in_successfully),
    );

    if (!mounted) return;

    context.go(AppRoutes.home);
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext modalContext) {
    final as = AppLocalizations.of(modalContext)!;
    final validations = FormValidations(as);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                as.login,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Padding(padding: EdgeInsets.all(12)),

              const Center(
                child: FabAuthAnimation(
                  asset: 'assets/animations/traveler.json',
                  height: 300,
                ),
              ),

              const Padding(padding: EdgeInsets.all(12)),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    /// Email text field
                    TextFormField(
                      validator: validations.emailValidator,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      onTapUpOutside: (_) =>
                          FocusScope.of(modalContext).unfocus(),
                      decoration: InputDecoration(
                        hintText: as.email,
                        prefixIcon: const Icon(Icons.email),
                      ),
                    ),

                    const Padding(padding: EdgeInsets.all(18)),

                    /// Password text field
                    TextFormField(
                      validator: validations.passwordValidator,
                      controller: _passwordController,
                      onTapUpOutside: (_) =>
                          FocusScope.of(modalContext).unfocus(),
                      decoration: InputDecoration(
                        hintText: as.password,
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
                      ),
                      child: Text(as.login),
                    ),
                  ),

                  const Padding(padding: EdgeInsets.all(16)),

                  /// 'Forgot your password?' button
                  TextButton(
                    child: Text(as.forgot_your_password),
                    onPressed: () {
                      modalContext.push(
                        '${AppRoutes.auth}${AppRoutes.forgotPassword}',
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
