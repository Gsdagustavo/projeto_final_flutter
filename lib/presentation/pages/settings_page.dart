import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../providers/language_code_provider.dart';
import '../providers/login_provider.dart';
import 'auth/auth_page_switcher.dart';
import 'fab_page.dart';

/// This is the settings page of the app
///
/// Currently, it does not have any interaction nor action available, but in the
/// future, more features will be added
class SettingsPage extends StatelessWidget {
  /// Constant constructor
  const SettingsPage({super.key});

  /// The route of the page
  static const String routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final as = AppLocalizations.of(context);

    return FabPage(
      title: as!.title_settings,
      body: Consumer<LoginProvider>(
        builder: (_, authProvider, __) {
          final locale = Localizations.localeOf(context).toString();

          final user = authProvider.loggedUser;
          final emailInitial = user != null && user.email != null
              ? user.email![0].toUpperCase()
              : 'N/A';

          final creationTime = user?.metadata.creationTime;
          final lastSignInTime = user?.metadata.lastSignInTime;

          final formattedCreationTime = creationTime != null
              ? DateFormat.yMd(locale).format(creationTime)
              : 'N/A';

          final formattedSignInTime = lastSignInTime != null
              ? DateFormat.yMd(locale).format(lastSignInTime)
              : 'N/A';

          return Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    radius: 50,
                    child: Text(
                      emailInitial,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                      ),
                    ),
                  ),
                ),

                const Padding(padding: EdgeInsets.all(12)),

                Text(
                  as.account,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),

                Padding(padding: EdgeInsets.all(6)),

                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email: ${user?.email ?? 'N/A'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        '${as.account_creation}: $formattedCreationTime',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        '${as.last_sign_in}: $formattedSignInTime',
                        style: const TextStyle(fontSize: 16),
                      ),

                      Padding(padding: EdgeInsets.all(6)),

                      InkWell(
                        onTap: () async {
                          await loginProvider.signOut();

                          if (loginProvider.hasError) {
                            unawaited(
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text(as.warning),
                                  content: Text(loginProvider.errorMsg),
                                ),
                              ),
                            );

                            return;
                          }

                          unawaited(
                            Navigator.pushReplacementNamed(
                              context,
                              AuthPageSwitcher.routeName,
                            ),
                          );
                        },
                        child: Row(
                          spacing: 10,
                          children: [
                            Text(
                              as.exit,
                              style: const TextStyle(color: Colors.red),
                            ),
                            const Icon(
                              Icons.logout,
                              color: Colors.red,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const Padding(padding: EdgeInsets.all(12)),

                Text(
                  as.language,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),

                const Padding(padding: EdgeInsets.all(6)),

                const _LanguagesRadio(),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// This is a custom [Widget] that is used in the [SettingsPage]
///
/// It is a RadioButton that contains values for language codes, allowing
/// the user to dynamically change the current language of the app
class _LanguagesRadio extends StatefulWidget {
  /// Constant constructor
  const _LanguagesRadio();

  @override
  State<_LanguagesRadio> createState() => _LanguagesRadioState();
}

class _LanguagesRadioState extends State<_LanguagesRadio> {
  final locales = AppLocalizations.supportedLocales;
  late String selectedOption;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        selectedOption = Provider.of<LanguageCodeProvider>(
          context,
          listen: false,
        ).languageCode;

        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (_isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Wrap(
          direction: Axis.horizontal,
          children: [
            for (final locale in locales)
              ListTile(
                title: Text(locale.toString().toUpperCase()),
                leading: Radio<String>(
                  value: locale.toString(),
                  groupValue: selectedOption,
                  onChanged: (value) async {
                    setState(() {
                      debugPrint('Value: $value');
                      selectedOption = value.toString();
                    });

                    final languageCodeProvider =
                        Provider.of<LanguageCodeProvider>(
                          context,
                          listen: false,
                        );

                    await languageCodeProvider.changeLanguageCode(
                      languageCode: locale.toString(),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
