import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/extensions/date_extensions.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/file_service.dart';
import '../../../services/user_preferences_service.dart';
import '../../providers/login_provider.dart';
import '../../providers/user_preferences_provider.dart';
import '../../util/app_routes.dart';
import '../../widgets/fab_page.dart';

/// This is the settings page of the app
///
/// Currently, it does not have any interaction nor action available, but in the
/// future, more features will be added
class SettingsPage extends StatefulWidget {
  /// Constant constructor
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  File? _profilePicture;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final image = await UserPreferencesService().getCurrentProfilePicture();

      if (mounted) {
        setState(() {
          _profilePicture = image;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final as = AppLocalizations.of(context);

    return FabPage(
      title: as!.title_settings,
      body: SingleChildScrollView(
        child: Consumer<LoginProvider>(
          builder: (_, authProvider, __) {
            final as = AppLocalizations.of(context)!;

            const defaultPfpPath = 'assets/images/default_profile_picture.png';

            final locale = Localizations.localeOf(context).toString();

            final user = authProvider.loggedUser;

            final creationTime = user?.metadata.creationTime;
            final lastSignInTime = user?.metadata.lastSignInTime;

            final formattedCreationTime = creationTime != null
                ? creationTime.getFormattedDateWithYear(locale)
                : 'N/A';

            final formattedSignInTime = lastSignInTime != null
                ? lastSignInTime.getFormattedDateWithYear(locale)
                : 'N/A';

            final backgroundImage = _profilePicture != null
                ? FileImage(_profilePicture!)
                : const AssetImage(defaultPfpPath) as ImageProvider;

            const double radius = 72;

            return Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Center(
                        child: CircleAvatar(
                          backgroundImage: backgroundImage,
                          radius: radius,
                        ),
                      ),

                      Positioned(
                        bottom: 0,
                        right:
                            MediaQuery.of(context).size.width / 2 - radius - 22,
                        child: InkWell(
                          onTap: () async {
                            /// TODO: show a modal to choose where the image
                            /// is going to be picked from (camera, gallery, etc.)
                            final image = await FileService().pickImage();
                            await UserPreferencesService().saveProfilePicture(
                              image,
                            );

                            setState(() {
                              _profilePicture = image;
                            });
                          },
                          radius: 20,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                            child: Center(
                              child: Icon(
                                Icons.edit,
                                size: 32,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Padding(padding: EdgeInsets.all(16)),

                  Text(
                    as.account,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),

                  Padding(padding: EdgeInsets.all(6)),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Email
                      AccountInfoWidget(
                        icon: Icon(Icons.email),
                        text: Text(
                          '${as.email}: ${user?.email ?? 'N/A'}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),

                      /// Account creation
                      AccountInfoWidget(
                        icon: Icon(Icons.date_range),
                        text: Text(
                          '${as.account_creation}: $formattedCreationTime',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),

                      /// Last sign in
                      AccountInfoWidget(
                        icon: Icon(Icons.assignment_ind_outlined),
                        text: Text(
                          '${as.last_sign_in}: $formattedSignInTime',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),

                      InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () async {
                          context.go(Routes.auth);
                          await loginProvider.signOut();
                        },
                        child: AccountInfoWidget(
                          icon: const Icon(Icons.logout, color: Colors.red),
                          text: Text(
                            as.exit,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Text(
                    as.language,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),

                  const Padding(padding: EdgeInsets.all(6)),

                  const _LanguagesRadio(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class AccountInfoWidget extends StatelessWidget {
  const AccountInfoWidget({super.key, required this.icon, required this.text});

  final Icon icon;
  final Text text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).primaryColor.withOpacity(0.25),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            icon,
            Padding(padding: EdgeInsets.all(6)),
            Expanded(child: text),
          ],
        ),
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
        selectedOption = Provider.of<UserPreferencesProvider>(
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
                        Provider.of<UserPreferencesProvider>(
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
