import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
import '../../providers/login_provider.dart';
import '../../widgets/custom_dialog.dart';
import '../../widgets/toggle_dark_mode_icon_button.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  static const String routeName = '/forgotPassword';

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  String? _emailValidator(String? email) {
    if (email == null || email.isEmpty) {
      return 'Invalid Email';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.only(right: 22),
        actions: [ToggleDarkModeIconButton()],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  as.forgot_your_password,
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
          
                Padding(padding: EdgeInsets.all(70)),
          
                Text(as.insert_your_email),
          
                Padding(padding: EdgeInsets.all(12)),
          
                /// Form
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
          
                  /// Email text field
                  child: TextFormField(
                    validator: _emailValidator,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    onTapUpOutside: (_) => FocusScope.of(context).unfocus(),
                    decoration: InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                ),
          
                Padding(padding: EdgeInsets.all(12)),
          
                ElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;
          
                    final loginProvider = Provider.of<LoginProvider>(
                      context,
                      listen: false,
                    );
                    await loginProvider.sendPasswordResetEmail(
                      email: _emailController.text,
                    );
          
                    if (loginProvider.hasError) {
                      unawaited(
                        showDialog(
                          context: context,
                          builder: (context) => CustomDialog(
                            title: AppLocalizations.of(context)!.warning,
                            content: Text(loginProvider.errorMsg),
                            isError: true,
                          ),
                        ),
                      );
          
                      return;
                    }
          
                    unawaited(
                      showDialog(
                        context: context,
                        builder: (context) => CustomDialog(
                          title: '',
                          content: Text(
                            '${as.recovery_code_sent_to} ${_emailController.text}',
                          ),
                        ),
                      ),
                    );
                  },
                  child: Text(as.send_recovery_code),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
