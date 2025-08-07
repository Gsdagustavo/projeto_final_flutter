import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return Container(
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.green,
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.circle_outlined, color: Colors.blue),
              Padding(padding: EdgeInsets.all(6)),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: BoxBorder.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                height: 50,
                child: Text(
                  travel.stops.first.place.toString(),
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),

          Icon(Icons.route),

          Row(
            children: [
              Icon(Icons.pin_drop, color: Colors.red),
              Padding(padding: EdgeInsets.all(6)),

              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: BoxBorder.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                height: 50,
                child: Text(
                  travel.stops.last.place.toString(),
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),

          Padding(padding: EdgeInsets.all(12)),

          _ParticipantsWidget(participants: travel.participants),
        ],
      ),
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
        clipBehavior: Clip.none,
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

          if (participants.length > 2)
            CircleAvatar(radius: 20, child: Text('...')),
        ],
      ),
    );
  }
}
