import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/extensions/date_extensions.dart';
import '../../../core/extensions/string_extensions.dart';
import '../../../domain/entities/participant.dart';
import '../../../domain/entities/review.dart';
import '../../../domain/entities/travel.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/register_travel_provider.dart';
import '../../providers/review_provider.dart';
import '../../providers/travel_list_provider.dart';
import '../../providers/user_preferences_provider.dart';
import '../../widgets/fab_page.dart';

/// The Home Page of the app
class HomePage extends StatelessWidget {
  /// Constant constructor
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;

    return FabPage(
      title: as.title_home,
      floatingActionButton: Column(
        children: [
          FloatingActionButton(
            child: const Icon(Icons.update),
            onPressed: () async {
              final travelListProvider = Provider.of<TravelListProvider>(
                context,
                listen: false,
              );

              await travelListProvider.update();
            },
          ),
        ],
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
                  as.my_travels,
                  style: Theme.of(context).textTheme.displayMedium,
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

  Future<Review?> showReviewModal(BuildContext context) async {
    await showModalBottomSheet<Review>(
      context: context,
      builder: (context) {
        return ReviewModal(travel: travel);
      },
    );

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await showReviewModal(context);
        debugPrint('Travel widget clicked');
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) {
        //       return TravelRoutePage(
        //         stops: travel.stops,
        //         travelTitle: travel.travelTitle,
        //       );
        //     },
        //   ),
        // );
      },
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.all(32.0),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).primaryColor.withOpacity(0.35),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                travel.travelTitle.capitalizedAndSpaced,
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              const Padding(padding: EdgeInsets.all(12)),

              _StopWidget(
                label: travel.stops.first.place.toString(),
                icon: const Icon(Icons.circle_outlined, color: Colors.blue),
                date: travel.stops.first.arriveDate!,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: const Icon(Icons.route),
              ),

              _StopWidget(
                label: travel.stops.last.place.toString(),
                icon: const Icon(Icons.pin_drop, color: Colors.red),
                date: travel.stops.last.leaveDate!,
              ),

              const Padding(padding: EdgeInsets.all(16)),

              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _ParticipantsWidget(participants: travel.participants),
                    _FinishTravelButton(travel: travel),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FinishTravelButton extends StatelessWidget {
  const _FinishTravelButton({required this.travel});

  final Travel travel;

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;

    return InkWell(
      onTap: () async {
        final registerTravelState = Provider.of<RegisterTravelProvider>(
          context,
          listen: false,
        );

        await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    as.finish_travel_confirm,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Icon(Icons.warning, color: Colors.orange, size: 28),
                ],
              ),
              actionsAlignment: MainAxisAlignment.spaceAround,
              actions: [
                TextButton(
                  onPressed: () {
                    context.pop(false);
                  },

                  child: Text(as.no),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(padding: EdgeInsets.all(12)),
                  onPressed: () async {
                    await registerTravelState.finishTravel(travel);
                    context.pop(false);
                  },

                  child: Text(as.yes),
                ),
              ],
            );
          },
        );
      },
      borderRadius: BorderRadius.circular(16),

      child: ElevatedButton(
        onPressed: () {},
        child: Text(
          as.finish_travel,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ),
    );
  }
}

class _StopWidget extends StatelessWidget {
  const _StopWidget({
    required this.label,
    required this.icon,
    required this.date,
  });

  final String label;
  final Widget icon;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final locale = Provider.of<UserPreferencesProvider>(
      context,
      listen: false,
    ).languageCode;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        icon,
        const Padding(padding: EdgeInsets.all(6)),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: BoxBorder.all(
                  color: Theme.of(
                    context,
                  ).inputDecorationTheme.enabledBorder!.borderSide.color,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              height: 50,
              child: Text(label),
            ),

            Padding(padding: EdgeInsets.all(6)),

            Text(date.getFormattedDate(locale)),
          ],
        ),
      ],
    );
  }
}

class _ParticipantsWidget extends StatelessWidget {
  const _ParticipantsWidget({required this.participants});

  final List<Participant> participants;
  static const int _maxParticipants = 3;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 50,
      child: Stack(
        alignment: Alignment.center,
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
      ),
    );
  }
}

class ReviewModal extends StatefulWidget {
  const ReviewModal({super.key, required this.travel});

  final Travel travel;

  @override
  State<ReviewModal> createState() => _ReviewModalState();
}

class _ReviewModalState extends State<ReviewModal> {
  @override
  Widget build(BuildContext context) {
    final reviewState = Provider.of<ReviewProvider>(context);
    final as = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(
        decelerationRate: ScrollDecelerationRate.normal,
      ),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    context.pop();
                  },
                  icon: Icon(Icons.close),
                ),
                Text(
                  as.give_a_review,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ],
            ),
            Padding(padding: EdgeInsets.all(16)),
            StarRating(
              size: 52,
              color: Colors.yellow.shade800,
              rating: reviewState.reviewRate.toDouble(),
              onRatingChanged: (r) {
                reviewState.reviewRate = r.toInt();
              },
            ),
            Padding(padding: EdgeInsets.all(16)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  as.detail_review,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                Padding(padding: EdgeInsets.all(6)),

                /// TODO: make this a textformfield with validation
                TextField(
                  controller: reviewState.reviewController,
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  maxLength: 500,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hint: Text(
                      as.review,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.all(16)),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Builder(
                //   builder: (context) {
                //     print(
                //       'reviewState.images.isEmpty:
                //       ${reviewState.images.isEmpty}',
                //     );
                //
                //     if (reviewState.images.isNotEmpty) {
                //       return _PhotosWidget(photos: reviewState.images);
                //     }
                //
                //     return Container();
                //   },
                // ),
                InkWell(
                  onTap: () async {
                    await reviewState.pickReviewImage();
                  },
                  borderRadius: BorderRadius.circular(32),
                  child: Container(
                    decoration: BoxDecoration(
                      border: BoxBorder.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    padding: EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(
                          size: 42,
                          Icons.camera_alt,
                          color: Theme.of(context).primaryColor,
                        ),
                        Text(as.add_photo),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Padding(padding: EdgeInsets.all(16)),
            InkWell(
              onTap: () async {
                // await reviewState.addReview();
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.all(22),
                child: Center(
                  child: Text(
                    as.send_review,

                    /// TODO: theme
                    style: TextStyle(
                      color: Theme.of(context).cardColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
