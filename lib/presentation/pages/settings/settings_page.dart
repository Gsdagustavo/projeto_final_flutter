import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:provider/provider.dart';

import '../../../core/extensions/date_extensions.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/file_service.dart';
import '../../../services/user_preferences_service.dart';
import '../../providers/login_provider.dart';
import '../../providers/user_preferences_provider.dart';
import '../../util/app_routes.dart';
import '../../widgets/fab_circle_avatar.dart';
import '../../widgets/fab_page.dart';
import '../../widgets/loading_dialog.dart';

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
    final user = loginProvider.loggedUser;

    const defaultPfpPath = 'assets/images/default_profile_picture.png';

    final Widget backgroundImage;
    if (_profilePicture != null) {
      backgroundImage = Image.file(_profilePicture!);
    } else {
      backgroundImage = Image.asset(defaultPfpPath);
    }

    final locale = Localizations.localeOf(context).toString();

    final creationTime = user?.metadata.creationTime ?? 'N/A';

    final formattedCreationTime = creationTime is DateTime
        ? creationTime.getFormattedDateWithYear(locale)
        : 'N/A';

    return FabPage(
      title: as.title_settings,
      body: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      FabCircleAvatar(
                        radius: 32,
                        child: InstaImageViewer(child: backgroundImage),
                      ),
                      InkWell(
                        onTap: () async {
                          final image = await FileService().pickImage();

                          if (image == null) return;

                          await UserPreferencesService().saveProfilePicture(
                            image,
                          );
                          setState(() => _profilePicture = image);
                        },
                        child: const CircleAvatar(
                          radius: 14,
                          child: Icon(Icons.camera_alt, size: 16),
                        ),
                      ),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.all(16)),
                  Text(user?.email ?? 'N/A'),
                ],
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.all(16)),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    as.account,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.email),
                        title: Text(as.email),
                        subtitle: Text(user?.email ?? 'N/A'),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.grey),
                  Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.date_range),
                        title: Text(as.account_creation),
                        subtitle: Text(formattedCreationTime),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.all(16)),
          Card(
            child: ListTile(
              leading: const Icon(Icons.language),
              title: Text(as.language),
              subtitle: Text(
                _languageGetters[Localizations.localeOf(context).languageCode]!(
                  as,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => _LanguageSelectionSheet(),
                );
              },
            ),
          ),
          const Padding(padding: EdgeInsets.all(16)),
          const _LogoutButton(),
        ],
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () async {
            final logout = await showDialog<bool>(
              context: context,
              builder: (context) {
                /// TODO: implement OkCancel dialog
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

            if (logout ?? false) {
              await showLoadingDialog(
                context: context,
                function: () async {
                  await context.read<LoginProvider>().signOut();
                },
              );
              context.go(Routes.auth);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: const Padding(
                  padding: EdgeInsets.only(left: 32),
                  child: Icon(Icons.logout),
                ),
              ),
              Text(as.logout),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageSelectionSheet extends StatelessWidget {
  final locales = AppLocalizations.supportedLocales;

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: locales.map((lang) {
          return ListTile(
            title: Text(_languageGetters[lang.languageCode]!(as)),
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
      ),
    );
  }
}

final Map<String, String Function(AppLocalizations)> _languageGetters = {
  'en': (loc) => loc.language_en,
  'pt': (loc) => loc.language_pt,
  'es': (loc) => loc.language_es,
};
