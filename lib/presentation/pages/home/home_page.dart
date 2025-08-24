import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../core/extensions/date_extensions.dart';
import '../../../domain/entities/review.dart';
import '../../../domain/entities/travel.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/review_provider.dart';
import '../../providers/travel_list_provider.dart';
import '../../providers/user_preferences_provider.dart';
import '../../widgets/theme_toggle_button.dart';
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

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: false,
            snap: false,
            expandedHeight: 120,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Text(
              as.my_travels,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            actions: const [ThemeToggleButton()],
          ),

          Consumer<TravelListProvider>(
            builder: (context, travelListProvider, child) {
              if (travelListProvider.isLoading) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final travels = travelListProvider.travels;

              if (travels.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    /// TODO: add actual travel image
                    child: Lottie.asset('assets/animations/traveler.json'),
                  ),
                );
              }

              return SliverList.separated(
                itemCount: travels.length,
                separatorBuilder: (_, __) => const SizedBox(height: 26),
                itemBuilder: (context, index) {
                  return _TravelWidget(travel: travels[index]);
                },
              );
            },
          ),
        ],
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
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Image.asset(
                    /// TODO: move this to a constant declaration
                    'assets/images/tokyo.jpg',
                    fit: BoxFit.cover,
                  ),
                ),

                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: travel.isFinished
                          ? Colors.green.withOpacity(0.9)
                          : Colors.red.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      /// TODO: intl
                      travel.isFinished ? "Completed" : "Ongoing",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
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
            Padding(padding: EdgeInsets.all(8)),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                spacing: 16,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(travel.travelTitle, style: TextStyle(fontSize: 18)),
                  Row(
                    children: [
                      Icon(Icons.pin_drop),
                      Padding(padding: EdgeInsets.all(4)),
                      Builder(
                        builder: (context) {
                          if (travel.stops.last.place.city! !=
                              travel.stops.first.place.city!) {
                            return Row(
                              children: [
                                Text(travel.stops.first.place.city!),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                  ),
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
                          Icon(Icons.calendar_today),
                          Padding(padding: EdgeInsets.all(4)),
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
                          padding: EdgeInsets.symmetric(
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
                          /// TODO: intl
                          child: Text('${travel.stops.length} stops'),
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
      physics: BouncingScrollPhysics(
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
                  icon: Icon(Icons.close),
                ),
                Text(
                  as.give_a_review,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ],
            ),
            Padding(padding: EdgeInsets.all(16)),
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
            Padding(padding: EdgeInsets.all(16)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  as.detail_review,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                Padding(padding: EdgeInsets.all(6)),
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
                    );
                  },
                ),
              ],
            ),

            Padding(padding: EdgeInsets.all(16)),
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
