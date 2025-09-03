import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:provider/provider.dart';

import '../../../core/extensions/date_extensions.dart';
import '../../../domain/entities/participant.dart';
import '../../../domain/entities/review.dart';
import '../../../domain/entities/travel.dart';
import '../../../domain/entities/travel_stop.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/file_service.dart';
import '../../extensions/enums_extensions.dart';
import '../../providers/review_provider.dart';
import '../../providers/travel_list_provider.dart';
import '../../providers/user_preferences_provider.dart';
import '../../widgets/custom_dialog.dart';
import '../../widgets/fab_circle_avatar.dart';
import '../../widgets/fab_page.dart';
import '../../widgets/loading_dialog.dart';
import '../util/form_validations.dart';
import '../util/travel_utils.dart';
import 'register_travel_page.dart';

class TravelDetailsPage extends StatefulWidget {
  const TravelDetailsPage({super.key, required this.travel});

  final Travel travel;

  @override
  State<TravelDetailsPage> createState() => _TravelDetailsPageState();
}

class _TravelDetailsPageState extends State<TravelDetailsPage> {
  String locale = 'en';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      setState(() {
        locale = context.read<UserPreferencesProvider>().languageCode;
      });

      await context.read<ReviewProvider>().getReviewsByTravel(widget.travel);
    });
  }

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;

    return FabPage(
      title: widget.travel.travelTitle,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.read<ReviewProvider>().getReviewsByTravel(
            widget.travel,
          );
        },
      ),
      body: Column(
        spacing: 8,
        children: [
          Builder(
            builder: (context) {
              if (widget.travel.photos.isEmpty) {
                return InstaImageViewer(
                  child: Image.asset('assets/images/placeholder.png'),
                );
              }

              return InstaImageViewer(
                child: Image.file(widget.travel.photos.first!),
              );
            },
          ),

          _TravelTitleWidget(travel: widget.travel),

          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(cardPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 16,
                      children: [
                        Row(
                          spacing: 8,
                          children: [
                            const Icon(Icons.calendar_today, size: 16),
                            Text(
                              as.duration,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        Text(
                          '${widget.travel.totalDuration} ${as.days.toLowerCase()}',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(cardPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 16,
                      children: [
                        Row(
                          spacing: 8,
                          children: [
                            const Icon(Icons.people, size: 16),
                            Text(
                              as.participants,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        Text(
                          '${widget.travel.participants.length} ${as.participants.toLowerCase()}',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(cardPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 16,
                      children: [
                        Row(
                          spacing: 8,
                          children: [
                            const Icon(Icons.airplanemode_active, size: 16),
                            Text(
                              as.transport,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        Text(
                          widget.travel.transportType.getIntlTransportType(
                            context,
                          ),
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(cardPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 16,
                      children: [
                        Row(
                          spacing: 8,
                          children: [
                            const Icon(Icons.location_on, size: 16),
                            Text(
                              as.countries,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        Text(
                          '${widget.travel.numCountries} ${as.countries.toLowerCase()}',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(cardPadding),
            child: Builder(
              builder: (context) {
                final countries = widget.travel.countries;

                if (countries.isEmpty) {
                  return const SizedBox.shrink();
                }

                return SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 16,
                    children: List.generate(countries.length, (index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.transparent,
                        ),
                        child: Text(
                          countries[index]!,
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                      );
                    }),
                  ),
                );
              },
            ),
          ),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(cardPadding),
              child: Column(
                children: [
                  Row(
                    spacing: 8,
                    children: [
                      const Icon(Icons.calendar_today),
                      Text(
                        as.travel_dates,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.all(12)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        as.start,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      Text(
                        widget.travel.startDate.getFormattedDateWithYear(
                          locale,
                        ),
                      ),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.all(6)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        as.end,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      Text(
                        widget.travel.endDate.getFormattedDateWithYear(locale),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(cardPadding),
              child: Column(
                children: [
                  Row(
                    spacing: 8,
                    children: [
                      const Icon(Icons.location_on),
                      Text(
                        as.travel_route,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),

                  _StopStepperWidget(travel: widget.travel, locale: locale),
                ],
              ),
            ),
          ),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(cardPadding),
              child: Column(
                children: [
                  Row(
                    spacing: 8,
                    children: [
                      const Icon(Icons.reviews),
                      Text(as.reviews),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Consumer<ReviewProvider>(
                          builder: (_, state, __) {
                            return Text('${state.reviews.length}');
                          },
                        ),
                      ),
                    ],
                  ),

                  Consumer<ReviewProvider>(
                    builder: (_, state, __) {
                      if (state.reviews.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Column(
                            spacing: 12,
                            children: [
                              const Icon(Icons.reviews, size: 42),
                              Text(as.no_reviews),
                            ],
                          ),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Column(
                          children: [
                            Row(
                              spacing: 8,
                              children: [
                                StarRating(
                                  starCount: 5,
                                  rating: state.rate,
                                  size: 22,
                                ),
                                Text(
                                  state.rate.toStringAsFixed(2),
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                Text(
                                  as.based_on_reviews(state.reviews.length),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),

                            ListView.separated(
                              separatorBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  child: const Divider(),
                                );
                              },
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: state.reviews.length,
                              itemBuilder: (context, index) {
                                debugPrint('$index');
                                final review = state.reviews[index];
                                return ReviewListItem(
                                  review: review,
                                  locale: locale,
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(cardPadding),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  await showLoadingDialog(
                    context: context,
                    function: () async {
                      await onTravelDeleted(context, widget.travel);
                    },
                  );
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: const Padding(
                        padding: EdgeInsets.only(left: 32),
                        child: Icon(Icons.delete),
                      ),
                    ),
                    Text(as.delete_travel),
                  ],
                ),
              ),
            ),
          ),
          const Padding(padding: EdgeInsetsGeometry.all(12)),
        ],
      ),
    );
  }
}

class _StopStepperWidget extends StatefulWidget {
  const _StopStepperWidget({
    super.key,
    required this.locale,
    required this.travel,
  });

  final Travel travel;
  final String locale;

  @override
  State<_StopStepperWidget> createState() => _StopStepperWidgetState();
}

class _StopStepperWidgetState extends State<_StopStepperWidget> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final stops = widget.travel.stops;
    debugPrint('Stops: ${widget.travel.stops}');

    return Stepper(
      stepIconHeight: 60,
      currentStep: index,
      physics: const NeverScrollableScrollPhysics(),
      type: StepperType.vertical,
      onStepTapped: (value) {
        setState(() {
          index = value;
        });
      },
      onStepContinue: () {
        if (index != stops.length - 1) {
          setState(() {
            index++;
          });
        }
      },
      onStepCancel: () {
        if (index != 0) {
          setState(() {
            index--;
          });
        }
      },
      stepIconBuilder: (stepIndex, stepState) {
        /// First stop
        if (stepIndex == 0) {
          return const Icon(Icons.start, color: Colors.blueAccent);
        }

        /// Last stop
        if (stepIndex == stops.length - 1) {
          return const Icon(Icons.flag, color: Colors.grey);
        }

        /// Middle stop
        return const Icon(Icons.location_on, color: Colors.green);
      },
      steps: [
        for (final stop in stops)
          Step(
            subtitle: Text(stop.type.getIntlTravelStopType(context)),
            title: Text('${stop.place.country}, ${stop.place.city}'),
            label: const Icon(Icons.reviews),
            content: Column(
              children: [
                Row(
                  spacing: 8,
                  children: [
                    const Icon(Icons.access_time_filled),
                    Text(
                      stop.arriveDate!.getFormattedDateWithYear(widget.locale),
                    ),
                    IconButton(
                      onPressed: () async {
                        await showReviewModal(context, widget.travel, stop);
                      },
                      icon: const Icon(Icons.reviews),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class ReviewListItem extends StatelessWidget {
  const ReviewListItem({super.key, required this.review, required this.locale});

  final Review review;
  final String locale;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      leading: FabCircleAvatar(
        child: InstaImageViewer(
          child: Image.file(review.author.profilePicture),
        ),
      ),

      title: Text(
        review.author.name,
        style: Theme.of(context).textTheme.titleLarge,
      ),

      trailing: IconButton(
        onPressed: () {
          /// TODO: remove review
          debugPrint('Remove review');
        },
        icon: const Icon(FontAwesomeIcons.remove),
      ),

      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 8,
              children: [
                StarRating(
                  mainAxisAlignment: MainAxisAlignment.start,
                  starCount: 5,
                  rating: review.stars.toDouble(),
                  size: 18,
                ),
                Text(review.reviewDate.getMonthDay(locale)),
                const Icon(Icons.circle, size: 4),
                const Icon(Icons.location_on, size: 12),
                Text(review.travelStop.place.city ?? ''),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text(review.description),
          ),

          if (review.images.isNotEmpty) ...[
            const SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: review.images.length,
                separatorBuilder: (context, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final photo = review.images[index];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: InstaImageViewer(
                      child: Image.file(
                        photo,
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ReviewModal extends StatefulWidget {
  const ReviewModal({super.key, required this.travel, required this.stop});

  final Travel travel;
  final TravelStop stop;

  @override
  State<ReviewModal> createState() => _ReviewModalState();
}

class _ReviewModalState extends State<ReviewModal> {
  final _formKey = GlobalKey<FormState>();
  final _reviewController = TextEditingController();
  double _reviewRate = 5;
  final _images = <File>[];

  Participant? _author;

  Future<void> addImage() async {
    final image = await FileService().pickImage();

    if (image == null) return;

    setState(() {
      _images.add(image);
    });
  }

  Future<void> removeImage(File image) async {
    setState(() {
      _images.removeWhere((element) => image == element);
    });
  }

  Future<void> onSubmit() async {
    final as = AppLocalizations.of(context)!;
    debugPrint('submit button tap');

    if (!_formKey.currentState!.validate()) {
      await showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
            title: as.warning,
            content: Text(as.err_invalid_review_data),
          );
        },
      );

      return;
    }

    if (_author == null) {
      await showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
            title: as.warning,
            content: Text(as.err_invalid_review_author),
          );
        },
      );

      return;
    }

    final reviewState = context.read<ReviewProvider>();

    final review = Review(
      description: _reviewController.text,
      author: _author!,
      reviewDate: DateTime.now(),
      travelStop: widget.stop,
      stars: _reviewRate.toInt(),
      images: _images,
    );

    await showLoadingDialog(
      context: context,
      function: () async => await reviewState.addReview(review),
    );

    if (reviewState.hasError) {
      await showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
            isError: true,
            title: as.warning,
            content: Text('${as.error_review}: ${reviewState.errorMessage}'),
          );
        },
      );

      return;
    }

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(title: Text(as.review_registered));
      },
    );

    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      _author = widget.travel.participants.first;
    });
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;
    final validations = FormValidations(as);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
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
                      Navigator.of(context).pop();
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
              Align(
                alignment: Alignment.centerLeft,
                child: Consumer<ReviewProvider>(
                  builder: (_, state, __) {
                    return DropdownButtonFormField<Participant>(
                      icon: const Icon(Icons.arrow_downward),
                      value: _author,
                      items: [
                        for (final participant in widget.travel.participants)
                          DropdownMenuItem(
                            value: participant,
                            child: Text(participant.name),
                          ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _author = value;
                        });
                      },
                    );
                  },
                ),
              ),

              const Padding(padding: EdgeInsets.all(16)),
              Consumer<ReviewProvider>(
                builder: (_, reviewState, __) {
                  return RatingStars(
                    starCount: 5,
                    value: _reviewRate,
                    animationDuration: Duration(seconds: 1),
                    starSize: 36,
                    valueLabelVisibility: false,
                    onValueChanged: (r) {
                      setState(() {
                        _reviewRate = r;
                      });
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
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          validator: validations.reviewValidator,
                          controller: _reviewController,
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
                  Consumer<ReviewProvider>(
                    builder: (_, reviewState, __) {
                      return InkWell(
                        onTap: () async {
                          await addImage();
                        },
                        borderRadius: BorderRadius.circular(32),
                        child: Container(
                          decoration: BoxDecoration(
                            border: BoxBorder.all(
                              color: Theme.of(context).highlightColor,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            spacing: 16,
                            children: [
                              const Icon(size: 42, Icons.camera_alt),
                              Text(as.add_photo),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.all(12)),
              Builder(
                builder: (_) {
                  if (_images.isEmpty) return const SizedBox.shrink();

                  return GridView.builder(
                    shrinkWrap: true,
                    itemCount: _images.length,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                    itemBuilder: (context, index) {
                      final image = _images[index];
                      return Stack(
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: InstaImageViewer(
                                  child: Image.file(image, fit: BoxFit.cover),
                                ),
                              ),
                              Positioned(
                                left: 4,
                                top: 4,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    onPressed: () async {
                                      await removeImage(image);
                                    },
                                    icon: const Icon(FontAwesomeIcons.remove),
                                    constraints: const BoxConstraints(),
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              const Padding(padding: EdgeInsets.all(16)),
              Consumer<ReviewProvider>(
                builder: (_, reviewState, __) {
                  return Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onSubmit,
                      child: Text(as.send_review),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<Review?> showReviewModal(
  BuildContext context,
  Travel travel,
  TravelStop stop,
) async {
  await showModalBottomSheet<Review>(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return ReviewModal(travel: travel, stop: stop);
    },
  );

  return null;
}

class _TravelTitleWidget extends StatefulWidget {
  const _TravelTitleWidget({super.key, required this.travel});

  final Travel travel;

  @override
  State<_TravelTitleWidget> createState() => _TravelTitleWidgetState();
}

class _TravelTitleWidgetState extends State<_TravelTitleWidget> {
  final formKey = GlobalKey<FormState>();
  final travelTitleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    travelTitleController.text = widget.travel.travelTitle;
  }

  Future<void> onTravelTitleUpdated() async {
    if (!formKey.currentState!.validate()) {
      /// TODO: show error dialog
      return;
    }

    /// Travel title is the same
    if (travelTitleController.text == widget.travel.travelTitle) {
      return;
    }

    widget.travel.travelTitle = travelTitleController.text;

    final state = context.read<TravelListProvider>();
    await state.updateTravelTitle(widget.travel);

    final as = AppLocalizations.of(context)!;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(as.travel_title_updated),
              const Icon(Icons.check, color: Colors.green),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;
    final validations = FormValidations(as);

    return Padding(
      padding: const EdgeInsets.all(cardPadding),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Form(
            key: formKey,
            child: TextFormField(
              decoration: InputDecoration(
                constraints: const BoxConstraints(
                  maxWidth: 300,
                  maxHeight: 100,
                ),
                labelText: as.travel_title,
              ),
              controller: travelTitleController,
              validator: validations.travelTitleValidator,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          IconButton(
            onPressed: onTravelTitleUpdated,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
    );
  }
}
