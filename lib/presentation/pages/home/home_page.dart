import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/extensions/date_extensions.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/review.dart';
import '../../../domain/entities/travel.dart';
import '../../../l10n/app_localizations.dart';
import '../../extensions/enums_extensions.dart';
import '../../providers/review_provider.dart';
import '../../providers/travel_list_provider.dart';
import '../../providers/user_preferences_provider.dart';
import '../../widgets/fab_page.dart';
import '../util/form_validations.dart';

/// The Home Page of the app
class HomePage extends StatefulWidget {
  /// Constant constructor
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formKey = GlobalKey<FormState>();
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;

    return FabPage(
      title: as.title_home,
      floatingActionButton: FloatingActionButton(
        onPressed: () async =>
            await context.read<TravelListProvider>().update(),
      ),
      body: Consumer<TravelListProvider>(
        builder: (context, travelListProvider, child) {
          if (travelListProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final travels = travelListProvider.travels;

          /// TODO:
          // if (travels.isEmpty) {
          //   return Center(
          //     child: Lottie.asset('assets/animations/traveler.json'),
          //   );
          // }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: travels.length,
            separatorBuilder: (_, __) => const SizedBox(height: 26),
            itemBuilder: (context, index) {
              return _TravelWidget(travel: travels[index]);
            },
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
    final as = AppLocalizations.of(context)!;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),

        /// TODO: navigate to travel details when on tap
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
        child: Column(
          children: [
            Stack(
              children: [
                Builder(
                  builder: (context) {
                    if (travel.photos.isEmpty) {
                      return Image.asset('assets/images/placeholder.png');
                    }

                    return ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: Image.file(travel.photos.first!),
                    );
                  },
                ),

                Positioned(
                  top: 12,
                  left: 12,
                  child: _TravelStatusWidget(status: travel.status),
                ),

                Positioned(
                  right: 12,
                  top: 12,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: IconButton(
                      /// TODO: implement onPressed
                      onPressed: () {},
                      icon: Icon(Icons.more_vert),
                    ),
                  ),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.all(8)),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                spacing: 16,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TODO: theme
                  Text(travel.travelTitle, style: TextStyle(fontSize: 18)),
                  Row(
                    children: [
                      const Icon(Icons.location_on),
                      const Padding(padding: EdgeInsets.all(4)),
                      Builder(
                        builder: (context) {
                          if (travel.stops.last.place.city! !=
                              travel.stops.first.place.city!) {
                            return Row(
                              children: [
                                Text(travel.stops.first.place.city!),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: Icon(Icons.arrow_forward, size: 12),
                                ),
                                Text(travel.stops.last.place.city!),
                              ],
                            );
                          }

                          return Text(travel.stops.first.place.city!);
                        },
                      ),
                    ],
                  ),

                  Stack(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today),
                          const Padding(padding: EdgeInsets.all(4)),
                          Consumer<UserPreferencesProvider>(
                            builder: (_, state, __) {
                              return Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: travel.startDate!.getMonthDay(
                                        state.languageCode,
                                      ),
                                    ),
                                    const TextSpan(text: ' - '),
                                    TextSpan(
                                      text: travel.endDate!.getMonthDay(
                                        state.languageCode,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Theme.of(context).cardColor.withOpacity(0.7),
                            border: BoxBorder.all(
                              color: Theme.of(context).iconTheme.color!,
                              width: 1,
                            ),
                          ),
                          child: Text('${travel.stops.length} ${as.stops}'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TravelStatusWidget extends StatelessWidget {
  const _TravelStatusWidget({super.key, required this.status});

  final TravelStatus status;

  @override
  Widget build(BuildContext context) {
    final Color color;

    switch (status) {
      case TravelStatus.upcoming:
        color = Colors.lightBlueAccent.shade400.withOpacity(0.8);
        break;

      case TravelStatus.ongoing:
        color = Colors.green.withOpacity(0.8);
        break;

      case TravelStatus.finished:
        color = Colors.grey.withOpacity(0.8);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.getIntlTravelStatus(context),
        style: Theme.of(context).textTheme.labelLarge,
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
    final as = AppLocalizations.of(context)!;
    final validations = FormValidations(as);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(
        decelerationRate: ScrollDecelerationRate.normal,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    context.pop();
                  },
                  icon: const Icon(Icons.close),
                ),
                Text(
                  as.give_a_review,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.all(16)),
            Consumer<ReviewProvider>(
              builder: (_, reviewState, __) {
                return StarRating(
                  size: 52,
                  color: Colors.yellow.shade800,
                  rating: reviewState.reviewRate.toDouble(),
                  onRatingChanged: (r) {
                    reviewState.reviewRate = r.toInt();
                  },
                );
              },
            ),
            const Padding(padding: EdgeInsets.all(16)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  as.detail_review,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const Padding(padding: EdgeInsets.all(6)),
                Consumer<ReviewProvider>(
                  builder: (_, reviewState, __) {
                    return Form(
                      key: reviewState.key,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        validator: validations.reviewValidator,
                        controller: reviewState.reviewController,
                        onTapOutside: (_) => FocusScope.of(context).unfocus(),
                        maxLength: 500,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hint: Text(
                            as.review,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.all(16)),

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
                Consumer<ReviewProvider>(
                  builder: (_, reviewState, __) {
                    return InkWell(
                      onTap: () async {
                        await reviewState.pickReviewImage();
                      },
                      borderRadius: BorderRadius.circular(32),
                      child: Container(
                        decoration: BoxDecoration(
                          border: BoxBorder.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(32),
                        ),
                        padding: const EdgeInsets.all(24),
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
                    );
                  },
                ),
              ],
            ),

            const Padding(padding: EdgeInsets.all(16)),
            Consumer<ReviewProvider>(
              builder: (_, reviewState, __) {
                return InkWell(
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
