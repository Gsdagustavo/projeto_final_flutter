import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/extensions/date_extensions.dart';
import '../../domain/entities/participant.dart';
import '../../domain/entities/travel.dart';
import '../../l10n/app_localizations.dart';
import '../providers/travel_list_provider.dart';
import 'fab_page.dart';

/// The Home Page of the app
class HomePage extends StatelessWidget {
  /// Constant constructor
  const HomePage({super.key});

  /// The route of the page
  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;

    return FabPage(
      title: as.title_home,

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.update),
        onPressed: () async {
          final travelListProvider = Provider.of<TravelListProvider>(
            context,
            listen: false,
          );

          await travelListProvider.update();
        },
      ),

      body: Consumer<TravelListProvider>(
        builder: (_, travelListProvider, __) {
          if (travelListProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final travels = travelListProvider.travels;

          return Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Travels',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: travels.length,
                    itemBuilder: (context, index) {
                      return _TravelWidget(travel: travels[index]);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TravelWidget extends StatelessWidget {
  const _TravelWidget({required this.travel});

  final Travel travel;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          travel.startDate!.getFormattedDate(locale),
          style: TextStyle(fontSize: 24),
        ),

        Padding(padding: EdgeInsets.all(12)),

        Row(
          children: [
            Text('${travel.startDate!.hour}:${travel.startDate!.minute}'),
          ],
        ),

        _ParticipantsWidget(participants: travel.participants),
      ],
    );
  }
}

class _ParticipantsWidget extends StatelessWidget {
  const _ParticipantsWidget({super.key, required this.participants});

  final List<Participant> participants;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Positioned(
            right: -15,
            child: CircleAvatar(
              backgroundImage: FileImage(participants.first.profilePicture),
            ),
          ),

          Positioned(
            child: CircleAvatar(
              backgroundImage: FileImage(participants.last.profilePicture),
            ),
          ),

          // for (int i = 0; i < participants.length && i < 3; i++)
          //   Positioned(
          //     right: (20 * i) + 40,
          //     child: CircleAvatar(
          //       backgroundImage: FileImage(participants[i].profilePicture),
          //     ),
          //   ),
          //
          // if (participants.length > 3)
          //   CircleAvatar(radius: 20, child: Text('...')),
        ],
      ),
    );
  }
}
