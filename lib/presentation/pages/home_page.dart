import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/extensions/string_extensions.dart';
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
        child: const Icon(Icons.update),
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

                const Padding(padding: EdgeInsets.all(12)),

                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return const Padding(padding: EdgeInsets.all(26));
                    },
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: const EdgeInsets.all(32.0),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).focusColor,
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              travel.travelTitle.capitalizedAndSpaced,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const Padding(padding: EdgeInsets.all(12)),

            Row(
              children: [
                const Icon(Icons.circle_outlined, color: Colors.blue),
                Padding(padding: const EdgeInsets.all(6)),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  height: 50,
                  child: Text(
                    travel.stops.first.place.toString(),
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: const Icon(Icons.route),
            ),

            Row(
              children: [
                const Icon(Icons.pin_drop, color: Colors.red),
                const Padding(padding: EdgeInsets.all(6)),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: BoxBorder.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  height: 50,
                  child: Text(
                    travel.stops.last.place.toString(),
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),

            const Padding(padding: EdgeInsets.all(16)),

            SizedBox(
              height: 30,
              width: 30,
              child: _ParticipantsWidget(participants: travel.participants),
            ),
          ],
        ),
      ),
    );
  }
}

class _ParticipantsWidget extends StatelessWidget {
  const _ParticipantsWidget({super.key, required this.participants});

  final List<Participant> participants;
  static const int _maxParticipants = 3;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: List.generate(min(participants.length, _maxParticipants), (
        index,
      ) {
        return Positioned(
          left: index * 22,
          child: CircleAvatar(
            backgroundImage: FileImage(participants[index].profilePicture),
          ),
        );
      }),
    );
  }
}
