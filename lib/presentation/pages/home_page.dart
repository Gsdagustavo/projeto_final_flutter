import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:provider/provider.dart';

import '../../core/extensions/string_extensions.dart';
import '../../domain/entities/participant.dart';
import '../../domain/entities/review.dart';
import '../../domain/entities/travel.dart';
import '../../l10n/app_localizations.dart';
import '../providers/register_travel_provider.dart';
import '../providers/travel_list_provider.dart';
import '../providers/review_provider.dart';
import 'register_travel_page.dart';
import 'travel_route_page.dart';
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
                  as.my_travels,
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
    return InkWell(
      onTap: () {
        print('Travel widget clicked');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return TravelRoutePage(
                stops: travel.stops,
                travelTitle: travel.travelTitle,
              );
            },
          ),
        );
      },
      child: SingleChildScrollView(
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
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
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
                      style: const TextStyle(fontSize: 14),
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
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),

              const Padding(padding: EdgeInsets.all(16)),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ParticipantsWidget(participants: travel.participants),
                  Padding(padding: EdgeInsets.all(12)),
                  InkWell(
                    onTap: () async {
                      print('Review button clicked');
                      await showReviewModal(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),

                      child: Text('Add Review'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Review?> showReviewModal(BuildContext context) async {
    await showModalBottomSheet<Review>(
      context: context,
      builder: (context) {
        return ReviewModal(travel: travel);
      },
    );

    return null;
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
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close),
                ),
                Text(
                  'Give a Review',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.all(16)),
            StarRating(
              size: 52,
              color: Colors.yellow.shade800,
              rating: reviewState.reviewRate,
              onRatingChanged: (r) {
                reviewState.reviewRate = r;
              },
            ),
            Padding(padding: EdgeInsets.all(16)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Detail Review',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                Padding(padding: EdgeInsets.all(6)),
                TextField(
                  controller: reviewState.reviewController,
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  maxLength: 500,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hint: Text(
                      'Review',
                      style: TextStyle(color: Colors.grey.shade500),
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
                //       'reviewState.images.isEmpty: ${reviewState.images.isEmpty}',
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
                        Text('Add Photo'),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Padding(padding: EdgeInsets.all(16)),
            InkWell(
              onTap: () async {
                await reviewState.addReview();
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
                    'Send Review',
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

// class _PhotosWidget extends StatelessWidget {
//   const _PhotosWidget({super.key, required this.photos});
//
//   final List<File> photos;
//   static const int _maxPhotosShown = 2;
//
//   @override
//   Widget build(BuildContext context) {
//     final minPhotos = min(photos.length, _maxPhotosShown);
//
//     return SizedBox(
//       height: 100,
//       width: minPhotos * 44,
//
//       child: Stack(
//         alignment: Alignment.center,
//         children: List.generate(minPhotos, (index) {
//           return Positioned(
//             left: index * 22,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(24),
//               child: Image.file(photos.first, fit: BoxFit.cover),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }

class _ParticipantsWidget extends StatelessWidget {
  const _ParticipantsWidget({super.key, required this.participants});

  final List<Participant> participants;
  static const int _maxParticipants = 3;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: min(participants.length, _maxParticipants) * 44,
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
