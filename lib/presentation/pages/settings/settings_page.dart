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

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  File? _profilePicture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final image = await UserPreferencesService().getCurrentProfilePicture();
      if (mounted) setState(() => _profilePicture = image);
    });
  }

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;
    final loginProvider = Provider.of<LoginProvider>(context);
    final user = loginProvider.loggedUser!;

    const defaultPfpPath = 'assets/images/default_profile_picture.png';
    final backgroundImage = _profilePicture != null
        ? FileImage(_profilePicture!)
        : const AssetImage(defaultPfpPath) as ImageProvider;

    final locale = Localizations.localeOf(context).toString();

    final creationTime = user.metadata.creationTime;

    final formattedCreationTime = creationTime != null
        ? creationTime.getFormattedDateWithYear(locale)
        : 'N/A';

    return FabPage(
      title: as.title_settings,
      children: [
        Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 32,
                          backgroundImage: backgroundImage,
                        ),
                        InkWell(
                          onTap: () async {
                            final image = await FileService().pickImage();
                            await UserPreferencesService().saveProfilePicture(
                              image,
                            );
                            setState(() => _profilePicture = image);
                          },
                          child: CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.edit,
                              size: 16,
                              color: Theme
                                  .of(context)
                                  .primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.all(16)),
                    Text(user.email!),
                  ],
                ),
              ),
            ),
            Padding(padding: EdgeInsets.all(16)),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      as.account,
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleMedium,
                    ),
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: Text(user.email ?? 'N/A'),
                    ),
                    const Divider(color: Colors.grey),
                    ListTile(
                      leading: const Icon(Icons.date_range),
                      title: Text(formattedCreationTime),
                    ),
                  ],
                ),
              ),
            ),
            Padding(padding: EdgeInsets.all(16)),

            Card(
              child: ListTile(
                leading: const Icon(Icons.language),
                title: Text(as.language),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => LanguageSelectionSheet(),
                  );
                },
              ),
            ),
            Padding(padding: EdgeInsets.all(16)),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final logout = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(as.logout),
                        content: Text(as.logout_confirmation),
                        actionsAlignment: MainAxisAlignment.spaceBetween,
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: Text(as.no),
                          ),

                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: Text(as.yes),
                          ),
                        ],
                      );
                    },
                  );

                  if (logout!) {
                    context.go(Routes.auth);
                    await loginProvider.signOut();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(as.logout),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class LanguageSelectionSheet extends StatelessWidget {
  final locales = AppLocalizations.supportedLocales;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: locales.map((lang) {
        return ListTile(
          title: Text(languageGetters[lang.languageCode]!(loc)),
          onTap: () async {
            final newLocale = Locale(lang.languageCode);
            final userPreferencesState = Provider.of<UserPreferencesProvider>(
              context,
              listen: false,
            );

            await userPreferencesState.changeLanguageCode(
              languageCode: newLocale.languageCode,
            );

            Navigator.pop(context);
          },
        );
      }).toList(),
    );
  }
}

final Map<String, String Function(AppLocalizations)> languageGetters = {
  'en': (loc) => loc.language_en,
  'pt': (loc) => loc.language_pt,
  'es': (loc) => loc.language_es,
};
