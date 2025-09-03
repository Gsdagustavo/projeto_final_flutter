import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:persistent_header_adaptive/persistent_header_adaptive.dart';
import 'package:provider/provider.dart';

import '../../../core/extensions/date_extensions.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/travel.dart';
import '../../../l10n/app_localizations.dart';
import '../../extensions/enums_extensions.dart';
import '../../providers/travel_list_provider.dart';
import '../../providers/user_preferences_provider.dart';
import '../../util/app_routes.dart';
import '../../widgets/custom_dialog.dart';
import '../../widgets/fab_page.dart';
import '../../widgets/loading_dialog.dart';
import '../../widgets/ok_cancel_dialog.dart';
import '../util/travel_utils.dart';
import '../util/ui_utils.dart';

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

    return Consumer<TravelListProvider>(
      builder: (_, state, __) {
        if (state.isLoading) {
          return const Center(child: LoadingDialog());
        }

        return FabPage(
          title: as.title_home,
          floatingActionButton: FloatingActionButton(
            onPressed: () async => await state.update(),
          ),
          body: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.travels.length,
            separatorBuilder: (_, __) => const SizedBox(height: 26),
            itemBuilder: (context, index) {
              return _TravelWidget(travel: state.travels[index]);
            },
          ),

          slivers: [
            AdaptiveHeightSliverPersistentHeader(
              floating: true,
              needRepaint: true,
              child: Padding(
                padding: const EdgeInsets.only(top: 32),
                child: Padding(
                  padding: const EdgeInsets.all(cardPadding),
                  child: TextField(
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                    controller: searchController,
                    onChanged: (value) async {
                      await state.searchTravel(searchController.text);
                    },
                    decoration: InputDecoration(
                      /// TODO: intl
                      hintText: 'Search...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        onPressed: () async {
                          await state.clearSearch();
                          searchController.clear();
                        },
                        icon: const Icon(FontAwesomeIcons.remove),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TravelWidget extends StatefulWidget {
  const _TravelWidget({required this.travel});

  final Travel travel;

  @override
  State<_TravelWidget> createState() => _TravelWidgetState();
}

class _TravelWidgetState extends State<_TravelWidget> {
  Future<void> onTravelFinished() async {
    if (widget.travel.status == TravelStatus.upcoming) {
      await showDialog(
        context: context,
        builder: (context) => CustomDialog(
          isError: true,

          /// TODO: intl
          title: 'Warning',
          content: Text(
            /// TODO: intl
            'The travel ${widget.travel.travelTitle} has not started yet',
          ),
        ),
      );

      return;
    }

    if (widget.travel.status == TravelStatus.finished) {
      await showDialog(
        context: context,
        builder: (context) => CustomDialog(
          isError: true,

          /// TODO: intl
          title: 'Warning',
          content: Text(
            /// TODO: intl
            'The travel ${widget.travel.travelTitle} has already been finished',
          ),
        ),
      );

      return;
    }

    final result = await showOkCancelDialog(
      context,

      /// TODO: intl
      title: Text('Finish travel ${widget.travel.travelTitle}?'),
    );

    if (result == null || !result) {
      return;
    }

    final state = context.read<TravelListProvider>();

    // await showLoadingModalBottomSheet(
    //   context: context,
    //   function: state.finishTravel(widget.travel),
    // );

    if (state.hasError) {
      await showDialog(
        context: context,
        builder: (context) => CustomDialog(
          isError: true,

          /// TODO: intl
          title: 'Warning',
          content: Text('Error: ${state.errorMessage}'),
        ),
      );
    }
  }

  Future<void> onTravelStarted() async {
    final result = await showOkCancelDialog(
      context,

      /// TODO: intl
      title: Text('Start travel ${widget.travel.travelTitle}?'),
    );

    if (result == null || !result) {
      return;
    }

    final state = context.read<TravelListProvider>();

    await state.startTravel(widget.travel);

    if (state.hasError) {
      await showDialog(
        context: context,
        builder: (context) => CustomDialog(
          isError: true,

          /// TODO: intl
          title: 'Warning',
          content: Text('Error: ${state.errorMessage}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          context.push(Routes.travelDetails, extra: widget.travel);
        },
        child: Column(
          children: [
            Stack(
              children: [
                Builder(
                  builder: (context) {
                    if (widget.travel.photos.isEmpty) {
                      return Image.asset('assets/images/placeholder.png');
                    }

                    return ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: Image.file(widget.travel.photos.first!),
                    );
                  },
                ),

                Positioned(
                  top: 12,
                  left: 12,
                  child: _TravelStatusWidget(status: widget.travel.status),
                ),

                Positioned(
                  right: 12,
                  top: 12,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Consumer<TravelListProvider>(
                      builder: (_, state, __) {
                        return PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (context) => <PopupMenuEntry>[
                            if (widget.travel.status ==
                                TravelStatus.upcoming) ...[
                              PopupMenuItem(
                                child: ListTile(
                                  leading: const Icon(FontAwesomeIcons.play),
                                  title: Text(as.start_travel),
                                  onTap: onTravelStarted,
                                ),
                              ),
                            ] else if (widget.travel.status ==
                                TravelStatus.ongoing) ...[
                              PopupMenuItem(
                                child: ListTile(
                                  leading: const Icon(FontAwesomeIcons.flag),
                                  title: Text(as.finish_travel),
                                  onTap: onTravelFinished,
                                ),
                              ),
                            ],

                            PopupMenuItem(
                              child: ListTile(
                                leading: const Icon(FontAwesomeIcons.route),
                                title: Text(as.view_travel_route),
                                onTap: () {
                                  context.push(
                                    Routes.travelRoute,
                                    extra: widget.travel,
                                  );
                                },
                              ),
                            ),

                            PopupMenuItem(
                              child: ListTile(
                                leading: const Icon(Icons.delete),
                                title: Text(as.delete_travel),
                                onTap: () async => onTravelDeleted(
                                  context,
                                  widget.travel,
                                  popContext: false,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
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
                  Text(
                    widget.travel.travelTitle,
                    style: TextStyle(fontSize: 18),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.location_on),
                      const Padding(padding: EdgeInsets.all(4)),
                      Builder(
                        builder: (context) {
                          if (widget.travel.stops.last.place.city! !=
                              widget.travel.stops.first.place.city!) {
                            return Row(
                              children: [
                                Text(widget.travel.stops.first.place.city!),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: Icon(Icons.arrow_forward, size: 12),
                                ),
                                Text(widget.travel.stops.last.place.city!),
                              ],
                            );
                          }

                          return Text(widget.travel.stops.first.place.city!);
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
                                      text: widget.travel.startDate.getMonthDay(
                                        state.languageCode,
                                      ),
                                    ),
                                    const TextSpan(text: ' - '),
                                    TextSpan(
                                      text: widget.travel.endDate.getMonthDay(
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
                          child: Text(as.stop(widget.travel.stops.length)),
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
