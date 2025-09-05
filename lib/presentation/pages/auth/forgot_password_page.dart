import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
import '../../providers/login_provider.dart';
import '../../widgets/loading_dialog.dart';
import '../../widgets/modals.dart';
import '../../widgets/theme_toggle_button.dart';
import '../util/form_validations.dart';

/// A password recovery page
///
/// Contains a text field for the [email] that will have the password recovered
class ForgotPasswordPage extends StatefulWidget {
  /// Constant constructor
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext modalContext) {
    final as = AppLocalizations.of(modalContext)!;
    final validations = FormValidations(as);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actionsPadding: const EdgeInsets.only(right: 22),
        actions: [const ThemeToggleButton()],
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
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Padding(padding: EdgeInsets.all(70)),

                Text(as.insert_your_email),

                const Padding(padding: EdgeInsets.all(12)),

                /// Form
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,

                  /// Email text field
                  child: TextFormField(
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
                ),

                const Padding(padding: EdgeInsets.all(12)),

                _SendRecoveryCodeButton(
                  formKey: _formKey,
                  emailController: _emailController,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SendRecoveryCodeButton extends StatelessWidget {
  const _SendRecoveryCodeButton({
    required this.formKey,
    required this.emailController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;

    return Consumer<LoginProvider>(
      builder: (_, loginProvider, __) {
        return ElevatedButton(
          onPressed: () async {
            if (!formKey.currentState!.validate()) return;

            await showLoadingDialog(
              context: context,
              function: () => loginProvider.sendPasswordResetEmail(
                email: emailController.text,
              ),
            );

            if (loginProvider.hasError) {
              if (!context.mounted) return;

              await showDialog(
                context: context,
                builder: (context) =>
                    ErrorModal(message: loginProvider.errorMsg),
              );

              return;
            }

            if (!context.mounted) return;

            await showDialog(
              context: context,
              builder: (context) => SuccessModal(
                message: as.recovery_code_sent_to(emailController.text),
              ),
            );
          },
          child: Text(as.send_recovery_code),
        );
      },
    );
  }
}
