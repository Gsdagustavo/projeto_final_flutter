import 'dart:io';

import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:animated_list_plus/transitions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/enums.dart';
import '../../../domain/entities/participant.dart';
import '../../../domain/entities/travel_stop.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/file_service.dart';
import '../../extensions/enums_extensions.dart';
import '../../providers/map_markers_provider.dart';
import '../../providers/register_travel_provider.dart';
import '../../providers/travel_list_provider.dart';
import '../../util/app_routes.dart';
import '../../widgets/custom_dialog.dart';
import '../../widgets/fab_circle_avatar.dart';
import '../../widgets/fab_page.dart';
import '../../widgets/loading_dialog.dart';
import '../util/form_validations.dart';

const double cardPadding = 16;

class RegisterTravelPage extends StatefulWidget {
  const RegisterTravelPage({super.key});

  @override
  State<RegisterTravelPage> createState() => _RegisterTravelPageState();
}

class _RegisterTravelPageState extends State<RegisterTravelPage> {
  /// Travel title
  final _travelTitleController = TextEditingController();
  final _travelTitleFormKey = GlobalKey<FormState>();

  /// Transport type
  var _selectedTransportType = TransportType.values.first;

  /// Transport types and its icons
  static const _transportTypesIcons = {
    TransportType.bike: Icons.directions_bike,
    TransportType.car: Icons.directions_car,
    TransportType.bus: Icons.directions_bus,
    TransportType.plane: FontAwesomeIcons.plane,
    TransportType.cruise: FontAwesomeIcons.ship,
  };

  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  static const int _maxYear = 2100;
  final DateFormat _dateFormat = DateFormat('MM/dd/yyyy');

  final _participantNameController = TextEditingController();
  final _participantAgeController = TextEditingController();

  Future<void> onParticipantRemovePress(Participant participant) async {
    final as = AppLocalizations.of(context)!;

    final remove = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(as.warning),
          content: Text(
            '${as.remove_participant_confirmation} ${participant.name}?',
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(as.no),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(as.yes),
            ),
          ],
        );
      },
    );

    final state = context.read<RegisterTravelProvider>();
    if (remove ?? false) {
      state.removeParticipant(participant);
    } else {
      await showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
            title: as.warning,
            content: Text(as.err_could_not_add_participant),
            isError: true,
          );
        },
      );
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return _dateFormat.format(date);
  }

  Future<void> _pickDate({required bool isStart}) async {
    final state = context.read<RegisterTravelProvider>();

    final initialDate = DateTime.now();
    var firstDate = DateTime.now();
    var lastDate = DateTime(_maxYear);

    if (isStart && state.endDate != null) {
      lastDate = state.endDate!;
    } else if (!isStart && state.startDate != null) {
      firstDate = state.startDate!;
    }

    DateTime pickInitialDate;
    if (isStart) {
      pickInitialDate = state.startDate ?? initialDate;
      if (pickInitialDate.isAfter(lastDate)) pickInitialDate = lastDate;
      if (pickInitialDate.isBefore(firstDate)) pickInitialDate = firstDate;
    } else {
      pickInitialDate = state.endDate ?? initialDate;
      if (pickInitialDate.isAfter(lastDate)) pickInitialDate = lastDate;
      if (pickInitialDate.isBefore(firstDate)) pickInitialDate = firstDate;
    }

    final newDate = await showDatePicker(
      context: context,
      initialDate: pickInitialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (newDate != null) {
      setState(() {
        if (isStart) {
          state.startDate = newDate;
          _startDateController.text = _formatDate(newDate);

          if (state.endDate?.isBefore(newDate) == true) {
            state.endDate = null;
            _endDateController.clear();
          }
        } else {
          state.endDate = newDate;
          _endDateController.text = _formatDate(newDate);
        }
      });
    }
  }

  void onStopRemoved(TravelStop stop) async {
    final travelState = Provider.of<RegisterTravelProvider>(
      context,
      listen: false,
    );
    final markersState = Provider.of<MapMarkersProvider>(
      context,
      listen: false,
    );

    final as = AppLocalizations.of(context)!;

    final remove = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          /// TODO: intl
          title: Text('Remove Stop'),
          content: Text('Do you really want to remove this stop?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(as.no),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(as.yes),
            ),
          ],
        );
      },
    );

    if (remove != null && remove) {
      travelState.removeTravelStop(stop);
      markersState.removeMarker(stop);
    }

    // Navigator.of(context).pop();
  }

  void onImagePicked() async {
    final fileService = FileService();

    final file = await fileService.pickImage();

    final state = context.read<RegisterTravelProvider>();

    if (file == null || state.travelPhotos.length >= 5) return;

    state.addTravelPhoto(file);
  }

  void onImageRemoved(File image) async {
    final state = context.read<RegisterTravelProvider>();
    state.removeTravelPhoto(image);
  }

  Future<void> onTravelRegistered() async {
    final as = AppLocalizations.of(context)!;

    final state = context.read<RegisterTravelProvider>();

    await showLoadingDialog(
      context: context,
      function: () async {
        await state.registerTravel(_travelTitleController.text);
      },
    );

    await context.read<TravelListProvider>().update();

    if (state.hasError) {
      await showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
            title: as.warning,
            isError: true,

            /// TODO: intl
            content: Text('An error occurred while registering the travel'),
          );
        },
      );

      return;
    }

    await showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          title: as.travel_registered_successfully,
          content: SizedBox.shrink(),
        );
      },
    );

    setState(() {
      _travelTitleController.clear();
      _startDateController.clear();
      _endDateController.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    final state = context.read<RegisterTravelProvider>();
    _startDateController.text = _formatDate(state.startDate);
    _endDateController.text = _formatDate(state.endDate);
  }

  @override
  void dispose() {
    _participantNameController.dispose();
    _participantAgeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;

    final baseColor = Theme.of(
      context,
    ).elevatedButtonTheme.style!.backgroundColor!.resolve({})!;

    return FabPage(
      title: as.title_register_travel,
      body: Column(
        spacing: 8,
        children: [
          /// Travel info card
          ///
          /// contains: travel title, transport type and dates
          Card(
            borderOnForeground: true,
            child: Padding(
              padding: const EdgeInsets.all(cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    as.travel_details,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const Padding(padding: EdgeInsets.all(26)),
                  Text(
                    as.travel_title_label,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Padding(padding: EdgeInsets.all(2)),
                  Form(
                    key: _travelTitleFormKey,

                    /// Travel title field
                    child: TextFormField(
                      textCapitalization: TextCapitalization.words,
                      onTapOutside: (_) => FocusScope.of(context).unfocus(),
                      controller: _travelTitleController,
                      decoration: InputDecoration(
                        hintText: as.enter_travel_title,
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(12)),
                  Text(
                    as.transport_type_label,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Padding(padding: EdgeInsets.all(2)),

                  /// Transport types dropdown button
                  DropdownButtonFormField<TransportType>(
                    borderRadius: BorderRadius.circular(12),
                    value: _selectedTransportType,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    isExpanded: true,
                    items: [
                      for (final entry in _transportTypesIcons.entries)
                        DropdownMenuItem<TransportType>(
                          value: entry.key,
                          child: Row(
                            children: [
                              Icon(entry.value),
                              const Padding(padding: EdgeInsets.all(6)),
                              Text(entry.key.getIntlTransportType(context)),
                            ],
                          ),
                        ),
                    ],

                    onChanged: (value) {
                      setState(() {
                        _selectedTransportType =
                            value ?? TransportType.values.first;
                      });
                    },
                  ),
                  const Padding(padding: EdgeInsets.all(12)),
                  Row(
                    children: [
                      Expanded(
                        /// Travel start date field
                        child: TextFormField(
                          onTapOutside: (_) => FocusScope.of(context).unfocus(),
                          controller: _startDateController,
                          decoration: InputDecoration(
                            labelText: as.start_date,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            suffixIcon: const Icon(Icons.calendar_today),
                          ),
                          readOnly: true,
                          onTap: () => _pickDate(isStart: true),
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(6)),
                      Expanded(
                        /// Travel end date field
                        child: TextFormField(
                          onTapOutside: (_) => FocusScope.of(context).unfocus(),
                          controller: _endDateController,
                          decoration: InputDecoration(
                            labelText: as.end_date,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            suffixIcon: const Icon(Icons.calendar_today),
                          ),
                          readOnly: true,
                          onTap: () => _pickDate(isStart: false),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          /// Participant info card
          ///
          /// contains: a button to add a participant and the list of
          /// participants
          Card(
            child: Padding(
              padding: const EdgeInsets.all(cardPadding),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Consumer<RegisterTravelProvider>(
                        builder: (_, state, __) {
                          return Text(
                            '${as.participants} (${state.participants.length})',
                            style: Theme.of(context).textTheme.displaySmall,
                          );
                        },
                      ),
                      const Padding(padding: EdgeInsets.all(12)),
                      Flexible(
                        /// Add participant button
                        child: ElevatedButton(
                          onPressed: () => _showParticipantModal(context),
                          child: Text(as.add),
                        ),
                      ),
                    ],
                  ),
                  Consumer<RegisterTravelProvider>(
                    builder: (_, state, __) {
                      /// Participants list
                      return ImplicitlyAnimatedList<Participant>(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        items: state.participants,
                        areItemsTheSame: (oldItem, newItem) {
                          return oldItem.hashCode == newItem.hashCode;
                        },
                        removeItemBuilder: (context, animation, participant) {
                          return SizeFadeTransition(
                            curve: Curves.easeInOut,
                            animation: animation,
                            child: ParticipantListItem(
                              participant: participant,
                            ),
                          );
                        },

                        itemBuilder: (context, animation, participant, i) {
                          return SizeFadeTransition(
                            animation: animation,
                            child: Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 16,
                              ),
                              child: ListTile(
                                onTap: () => _showParticipantModal(
                                  context,
                                  participant: participant,
                                ),
                                leading: FabCircleAvatar(
                                  backgroundImage: FileImage(
                                    participant.profilePicture,
                                  ),
                                ),
                                title: Text(participant.name),
                                trailing: IconButton(
                                  onPressed: () =>
                                      onParticipantRemovePress(participant),
                                  icon: const Icon(FontAwesomeIcons.remove),
                                ),
                                subtitle: Text(
                                  '${as.age}: ${participant.age.toString()}',
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          /// Route planning card
          ///
          /// contains some text and a button to go to the map page to add
          /// stops for the travel
          Card(
            child: Padding(
              padding: const EdgeInsets.all(cardPadding),
              child: Row(
                spacing: 12,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 12,
                      children: [
                        Text(
                          as.route_planning,
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        Text(as.route_planning_label),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Consumer<RegisterTravelProvider>(
                      builder: (_, state, __) {
                        return ElevatedButton(
                          onPressed: () {
                            if (state.startDate != null &&
                                state.endDate != null) {
                              context.push(Routes.travelMap);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                state.startDate != null && state.endDate != null
                                ? baseColor
                                : baseColor.withOpacity(0.3),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.location_on),
                              Text(as.open_map),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// Travel stops card
          ///
          /// contains info about all stops added to the travel
          Card(
            child: Padding(
              padding: const EdgeInsets.all(cardPadding),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        as.registered_stops,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      Consumer<RegisterTravelProvider>(
                        builder: (_, state, __) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text('${state.stops.length} ${as.stops}'),
                          );
                        },
                      ),
                    ],
                  ),
                  Consumer<RegisterTravelProvider>(
                    builder: (context, state, child) {
                      final stops = state.stops;
                      if (stops.isEmpty) {
                        return Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 42),
                              child: Icon(Icons.location_on, size: 42),
                            ),
                            const Padding(padding: EdgeInsets.all(12)),
                            Text(
                              as.no_stops_registered,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        );
                      } else {
                        return ListView.separated(
                          itemCount: stops.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          separatorBuilder: (context, index) {
                            return const Padding(padding: EdgeInsets.all(12));
                          },
                          itemBuilder: (context, index) {
                            final backgroundColor = Theme.of(context)
                                .elevatedButtonTheme
                                .style!
                                .backgroundColor!
                                .resolve({});

                            final stop = state.stops[index];
                            return ListTile(
                              shape: Theme.of(context).cardTheme.shape,
                              leading: Builder(
                                builder: (context) {
                                  if (index == 0) {
                                    /// First stop
                                    return CircleAvatar(
                                      backgroundColor: backgroundColor,
                                      child: const Center(
                                        child: Icon(
                                          FontAwesomeIcons.paperPlane,
                                        ),
                                      ),
                                    );
                                  } else if (index == stops.length - 1) {
                                    /// Last stop
                                    return CircleAvatar(
                                      backgroundColor: backgroundColor,
                                      child: const Center(
                                        child: Icon(FontAwesomeIcons.flag),
                                      ),
                                    );
                                  } else {
                                    /// Waypoint
                                    return CircleAvatar(
                                      backgroundColor: backgroundColor,
                                      child: const Center(
                                        child: Icon(Icons.location_on),
                                      ),
                                    );
                                  }
                                },
                              ),
                              title: Text(stop.place.city ?? ''),
                              subtitle: Text(
                                '${stop.place.city ?? ''}, ${stop.place.country ?? ''}',
                              ),
                              trailing: IconButton(
                                onPressed: () => onStopRemoved(stop),
                                icon: const Icon(FontAwesomeIcons.remove),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                  const Padding(padding: EdgeInsets.all(8.0)),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: Text(
                        as.use_the_map_add_waypoints,
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// Travel photos card
          ///
          /// contains all photos added to the travel and a button to add photos
          Card(
            child: Padding(
              padding: const EdgeInsets.all(cardPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 12,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        as.travel_photos,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.all(16)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 48),
                      decoration: BoxDecoration(
                        border: BoxBorder.all(
                          color: Theme.of(context).iconTheme.color!,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Consumer<RegisterTravelProvider>(
                        builder: (_, state, __) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 6,
                            children: [
                              const Icon(Icons.camera_alt, size: 42),
                              Text(
                                as.add_travel_photos,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                as.tap_select_photos,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                '${state.travelPhotos.length} ${as.photos_selected}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const Padding(padding: EdgeInsets.all(2)),
                              UnconstrainedBox(
                                child: ElevatedButton(
                                  onPressed: onImagePicked,
                                  child: Row(
                                    children: [
                                      const Icon(Icons.file_upload_outlined),
                                      Text(as.choose_photos),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),

                  Consumer<RegisterTravelProvider>(
                    builder: (_, state, __) {
                      return GridView.builder(
                        shrinkWrap: true,
                        itemCount: state.travelPhotos.length,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 1,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                        itemBuilder: (context, index) {
                          final image = state.travelPhotos[index];
                          return Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadiusGeometry.circular(12),
                                child: InstaImageViewer(
                                  child: Image.file(image, fit: BoxFit.cover),
                                ),
                              ),
                              Positioned(
                                left: 4,
                                top: 4,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    onPressed: () => onImageRemoved(image),
                                    icon: const Icon(FontAwesomeIcons.remove),
                                    constraints: const BoxConstraints(),
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),

                  Center(
                    child: Text(
                      as.add_photos_label,
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(cardPadding),
            child: Consumer<RegisterTravelProvider>(
              builder: (_, state, __) {
                final isTravelValid = state.isTravelValid;
                final baseColor = Theme.of(
                  context,
                ).elevatedButtonTheme.style!.backgroundColor!.resolve({})!;

                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isTravelValid
                          ? baseColor
                          : baseColor.withOpacity(0.3),
                    ),
                    onPressed: () async {
                      if (!state.isTravelValid) {
                        return;
                      }
                      await onTravelRegistered();
                    },
                    child: Text(as.title_register_travel),
                  ),
                );
              },
            ),
          ),
          const Padding(padding: EdgeInsets.all(12)),
        ],
      ),
    );
  }
}

Future<void> _showParticipantModal(
  BuildContext context, {
  Participant? participant,
}) async {
  final state = context.read<RegisterTravelProvider>();

  final result = await showModalBottomSheet<Participant?>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return _ParticipantModal(participant: participant);
    },
  );

  if (result != null) {
    if (participant == null) {
      debugPrint('add participant');
      state.addParticipant(result);
    } else {
      debugPrint('update participant');
      state.updateParticipant(participant, result);
    }
  }
}

class _ParticipantModal extends StatefulWidget {
  const _ParticipantModal({this.participant});

  final Participant? participant;

  @override
  State<_ParticipantModal> createState() => _ParticipantModalState();
}

class _ParticipantModalState extends State<_ParticipantModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  File? _profilePicture;

  @override
  void initState() {
    super.initState();

    if (widget.participant case Participant(
      name: final name,
      age: final age,
      profilePicture: final profilePicture,
    )) {
      _nameController.text = name;
      _ageController.text = age.toString();
      _profilePicture = profilePicture;
    }
  }

  Future<void> _pickImage() async {
    setState(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        _profilePicture = await FileService().pickImage();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;
    final validations = FormValidations(as);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                top: -64,
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).canvasColor,
                    BlendMode.srcOut,
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: MediaQuery.sizeOf(context).width / 2 - 66,
                        child: Container(
                          width: 132,
                          height: 132,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(cardPadding),
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    top: 72,
                    bottom: MediaQuery.viewInsetsOf(context).bottom,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// Participant text form fields
                      Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          children: [
                            TextFormField(
                              textCapitalization: TextCapitalization.words,
                              validator: validations.participantNameValidator,
                              onTapOutside: (_) =>
                                  FocusScope.of(context).unfocus(),
                              controller: _nameController,
                              decoration: InputDecoration(
                                hintText: as.name,
                                prefixIcon: const Icon(Icons.person),
                              ),
                            ),
                            const Padding(padding: EdgeInsets.all(16)),
                            TextFormField(
                              validator: validations.participantAgeValidator,
                              onTapOutside: (_) =>
                                  FocusScope.of(context).unfocus(),
                              controller: _ageController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: as.age,
                                prefixIcon: const Icon(Icons.calendar_today),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Padding(padding: EdgeInsets.all(16)),

                      /// Cancel / Register buttons
                      Consumer<RegisterTravelProvider>(
                        builder: (_, state, __) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /// Cancel button
                              TextButton(
                                onPressed: () => context.pop(),
                                child: Text(as.cancel),
                              ),

                              Builder(
                                builder: (context) {
                                  debugPrint('${widget.participant == null}');

                                  /// Register participant
                                  if (widget.participant == null) {
                                    return ElevatedButton(
                                      onPressed: () async {
                                        if (!_formKey.currentState!
                                            .validate()) {
                                          await showDialog(
                                            context: context,
                                            builder: (context) {
                                              return CustomDialog(
                                                title: as.warning,
                                                content: Text(
                                                  as.err_invalid_participant_data,
                                                ),
                                                isError: true,
                                              );
                                            },
                                          );

                                          return;
                                        }

                                        final participant = Participant(
                                          name: _nameController.text,
                                          age: int.parse(_ageController.text),
                                          profilePicture:
                                              _profilePicture ??
                                              await FileService()
                                                  .getDefaultProfilePictureFile(),
                                        );

                                        await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return CustomDialog(
                                              title: as.add_participant,
                                              content: Text(
                                                as.participant_added,
                                              ),
                                            );
                                          },
                                        );

                                        Navigator.of(context).pop(participant);
                                      },
                                      child: Text(as.add),
                                    );
                                  }

                                  /// Update participant
                                  return ElevatedButton(
                                    onPressed: () async {
                                      if (!_formKey.currentState!.validate()) {
                                        await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return CustomDialog(
                                              title: as.update_participant,
                                              content: Text(
                                                as.err_invalid_participant_data,
                                              ),
                                              isError: true,
                                            );
                                          },
                                        );

                                        return;
                                      }

                                      final participant = Participant(
                                        name: _nameController.text,
                                        age: int.parse(_ageController.text),
                                        profilePicture:
                                            _profilePicture ??
                                            await FileService()
                                                .getDefaultProfilePictureFile(),
                                      );

                                      await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return CustomDialog(
                                            title: as.update_participant,
                                            content: Text(
                                              as.participant_updated,
                                            ),
                                          );
                                        },
                                      );

                                      Navigator.of(context).pop(participant);
                                    },
                                    child: Text(as.update_participant),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.all(16)),
            ],
          ),
        ),
        Positioned(
          top: -64,
          left: MediaQuery.sizeOf(context).width / 2 - 64,
          child: Stack(
            children: [
              SizedBox(
                width: 128,
                height: 128,
                child: Consumer<RegisterTravelProvider>(
                  builder: (_, travelState, __) {
                    return FabCircleAvatar(
                      child: _profilePicture != null
                          ? InstaImageViewer(
                              child: Image.file(_profilePicture!),
                            )
                          : InstaImageViewer(
                              child: Image.asset(
                                'assets/images/default_profile_picture.png',
                              ),
                            ),
                    );
                  },
                ),
              ),

              Positioned(
                bottom: 0,
                right: 2,
                child: Consumer<RegisterTravelProvider>(
                  builder: (_, travelState, __) {
                    return InkWell(
                      onTap: () async {
                        await _pickImage();
                      },
                      radius: 20,
                      child: CircleAvatar(
                        radius: 20,
                        child: const Center(child: Icon(Icons.edit, size: 32)),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ParticipantListItem extends StatelessWidget {
  const ParticipantListItem({super.key, required this.participant});

  final Participant participant;

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 16),
      child: ListTile(
        title: Text(participant.name),
        subtitle: Text('${as.age}: ${participant.age}'),
      ),
    );
  }
}
