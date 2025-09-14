import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:persistent_header_adaptive/persistent_header_adaptive.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/assets_paths.dart';
import '../../../core/extensions/date_extensions.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/travel.dart';
import '../../../l10n/app_localizations.dart';
import '../../extensions/enums_extensions.dart';
import '../../providers/travel_list_provider.dart';
import '../../providers/user_preferences_provider.dart';
import '../../util/app_routes.dart';
import '../../widgets/fab_animated_list.dart';
import '../../widgets/fab_carousel_slider.dart';
import '../../widgets/fab_page.dart';
import '../../widgets/loading_dialog.dart';
import '../../widgets/modals.dart';
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
  final searchFocusNode = FocusNode();

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;

    debugPrint('home page build called');

    return Consumer<TravelListProvider>(
      builder: (_, state, __) {
        if (state.isLoading) {
          return const Center(child: LoadingDialog());
        }

        return FabPage(
          title: as.title_home,
          body: Builder(
            builder: (context) {
              if (state.travels.isEmpty) {
                return Column(
                  children: [
                    Lottie.asset('assets/animations/paperplane.json'),

                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        spacing: 16,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Nenhuma viagem cadastrada',
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                          ),

                          Text.rich(
                            textAlign: TextAlign.center,
                            TextSpan(
                              style: Theme.of(context).textTheme.bodyMedium,
                              children: [
                                TextSpan(text: 'Use a '),
                                TextSpan(
                                  text: 'página de registro de viagem',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      context.go(AppRoutes.registerTravel);
                                    },
                                ),
                                TextSpan(
                                  text: ' para registrar uma agora mesmo',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }

              return FabAnimatedList<Travel>(
                itemData: state.travels,
                itemEquality: (a, b) => a.id == b.id,
                itemBuilder: (context, travel) {
                  return _TravelListItem(travel: travel);
                },
              );
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
                    autofocus: false,
                    focusNode: searchFocusNode,
                    onTapOutside: (_) => searchFocusNode.unfocus(),
                    controller: searchController,
                    onChanged: (value) async {
                      await state.searchTravel(searchController.text);
                    },
                    decoration: InputDecoration(
                      hintText: as.search,
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        onPressed: () async {
                          await state.clearSearch();
                          searchController.clear();
                        },
                        icon: const Icon(FontAwesomeIcons.xmark),
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

class _TravelListItem extends StatefulWidget {
  const _TravelListItem({required this.travel});

  final Travel travel;

  @override
  State<_TravelListItem> createState() => _TravelListItemState();
}

class _TravelListItemState extends State<_TravelListItem> {
  Future<void> _onTravelStarted(Travel travel) async {
    final as = AppLocalizations.of(context)!;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => OkCancelModal(
        title: as.start_travel,
        content: as.start_travel_confirmation(travel.travelTitle),
      ),
    );

    if (result == null || !result) return;

    if (!mounted) return;

    final state = context.read<TravelListProvider>();
    await showLoadingDialog(
      context: context,
      function: () async => await state.startTravel(travel),
    );

    if (state.hasError) {
      if (!mounted) return;
      showErrorSnackBar(context, state.errorMessage!);
      return;
    }

    if (!mounted) return;
    showSuccessSnackBar(context, as.travel_started_successfully);
  }

  Future<void> _onTravelFinished(Travel travel) async {
    final as = AppLocalizations.of(context)!;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => OkCancelModal(
        title: as.finish_travel,
        content: as.finish_travel_confirmation(travel.travelTitle),
      ),
    );

    if (result == null || !result) return;
    if (!mounted) return;

    final state = context.read<TravelListProvider>();
    await showLoadingDialog(
      context: context,
      function: () async => await state.finishTravel(travel),
    );

    if (state.hasError) {
      if (!mounted) return;
      showErrorSnackBar(context, state.errorMessage!);
      return;
    }

    if (!mounted) return;
    showSuccessSnackBar(context, as.travel_finished_successfully);
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.travel.photos;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          context.push(AppRoutes.travelDetails, extra: widget.travel);
        },
        child: Column(
          children: [
            Stack(
              children: [
                if (images.isNotEmpty)
                  FabCarouselSlider(
                    photos: widget.travel.photos,
                    useImageViewer: false,
                  )
                else
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: Image.asset(
                      AssetsPaths.placeholderImage,
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
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
                      color: Theme.of(context).cardColor.withAlpha(180),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Consumer<TravelListProvider>(
                      builder: (_, state, __) {
                        final parentContext = context;
                        return PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                            if (widget.travel.status == TravelStatus.upcoming)
                              PopupMenuItem(
                                child: ListTile(
                                  leading: const Icon(FontAwesomeIcons.play),
                                  title: Text(
                                    AppLocalizations.of(context)!.start_travel,
                                  ),
                                  onTap: () async {
                                    Navigator.of(parentContext).pop();
                                    await _onTravelStarted(widget.travel);
                                  },
                                ),
                              ),
                            if (widget.travel.status == TravelStatus.ongoing)
                              PopupMenuItem(
                                child: ListTile(
                                  leading: const Icon(FontAwesomeIcons.flag),
                                  title: Text(
                                    AppLocalizations.of(context)!.finish_travel,
                                  ),
                                  onTap: () async {
                                    Navigator.of(parentContext).pop();
                                    await _onTravelFinished(widget.travel);
                                  },
                                ),
                              ),
                            PopupMenuItem(
                              child: ListTile(
                                leading: const Icon(FontAwesomeIcons.route),
                                title: Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.view_travel_route,
                                ),
                                onTap: () {
                                  Navigator.of(parentContext).pop();
                                  context.push(
                                    AppRoutes.travelRoute,
                                    extra: widget.travel,
                                  );
                                },
                              ),
                            ),
                            PopupMenuItem(
                              child: ListTile(
                                leading: const Icon(Icons.delete),
                                title: Text(
                                  AppLocalizations.of(context)!.delete_travel,
                                ),
                                onTap: () async {
                                  Navigator.of(parentContext).pop();
                                  await onTravelDeleted(
                                    context,
                                    widget.travel,
                                    popContext: false,
                                  );
                                },
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

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.travel.travelTitle,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 6),

                  Row(
                    children: [
                      const Icon(Icons.location_on),
                      const SizedBox(width: 4),
                      Builder(
                        builder: (context) {
                          final startCity =
                              widget.travel.stops.first.place.city ?? '';
                          final endCity =
                              widget.travel.stops.last.place.city ?? '';
                          if (startCity != endCity) {
                            return Row(
                              children: [
                                Text(startCity),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: Icon(Icons.arrow_forward, size: 12),
                                ),
                                Text(endCity),
                              ],
                            );
                          }
                          return Text(startCity);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Consumer<UserPreferencesProvider>(
                    builder: (_, prefs, __) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${widget.travel.startDate.getMonthDay(prefs.languageCode)} - '
                            '${widget.travel.endDate.getMonthDay(prefs.languageCode)}',
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.people),
                                  Text('${widget.travel.participants.length}'),
                                ],
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Theme.of(
                                    context,
                                  ).cardColor.withAlpha(180),
                                  border: Border.all(
                                    color: Theme.of(context).iconTheme.color!,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.stop(widget.travel.stops.length),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
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
  const _TravelStatusWidget({required this.status});

  final TravelStatus status;

  @override
  Widget build(BuildContext context) {
    final Color color;
    switch (status) {
      case TravelStatus.upcoming:
        color = Colors.lightBlueAccent.shade400.withAlpha(200);
        break;
      case TravelStatus.ongoing:
        color = Colors.green.withAlpha(200);
        break;
      case TravelStatus.finished:
        color = Colors.grey.withAlpha(200);
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
