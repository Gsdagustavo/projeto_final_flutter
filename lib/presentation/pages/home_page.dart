import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/participant.dart';
import '../../domain/entities/travel.dart';
import '../../l10n/app_localizations.dart';
import '../providers/travel_list_provider.dart';
import '../util/string_extensions.dart';
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
  const _TravelWidget({super.key, required this.travel});

  final Travel travel;

  String _formatDate({required DateTime date, required String locale}) {
    final dateFormat = DateFormat('EEE, dd MMMM', locale);
    return dateFormat.format(date);
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final formattedStartDate = _formatDate(
      date: travel.startDate!,
      locale: locale,
    );

    final participants = travel.participants;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(formattedStartDate, style: TextStyle(fontSize: 24)),

        Padding(padding: EdgeInsets.all(12)),

        Row(
          children: [
            Text('${travel.startDate!.hour}:${travel.startDate!.minute}'),
            // Text('${travel.}')
          ],
        ),
      ],
    );
  }
}

class ParticipantPfp extends StatelessWidget {
  const ParticipantPfp({super.key, required this.participant});

  final Participant participant;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(child: Text(participant.name.getUppercaseInitial()));
  }
}
