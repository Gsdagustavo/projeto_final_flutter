import 'dart:io';

import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:animated_list_plus/transitions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
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
import '../../widgets/fab_page.dart';
import '../util/form_validations.dart';

const double cardPadding = 16;

class RegisterTravelPage extends StatefulWidget {
  const RegisterTravelPage({super.key});

  @override
  State<RegisterTravelPage> createState() => _RegisterTravelPageState();
}

class _RegisterTravelPageState extends State<RegisterTravelPage> {
  final _travelTitleController = TextEditingController();
  final _travelTitleFormKey = GlobalKey<FormState>();

  var _selectedTransportType = TransportType.values.first;

  static const _transportTypesIcons = {
    TransportType.bike: Icons.directions_bike,
    TransportType.car: Icons.directions_car,
    TransportType.bus: Icons.directions_bus,
    TransportType.plane: FontAwesomeIcons.plane,
    TransportType.cruise: FontAwesomeIcons.ship,
  };

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;

    return FabPage(
      title: as.title_register_travel,
      body: Column(
        spacing: 8,
        children: [
          Card(
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
                    child: TextFormField(
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
                  const DateRangePickerRow(),
                ],
              ),
            ),
          ),

          AddParticipant(),

          RoutePlanning(),

          RegisteredStops(),

          _TravelPhotos(),

          Padding(
            padding: const EdgeInsets.all(cardPadding),
            child: Consumer<RegisterTravelProvider>(
              builder: (_, state, __) {
                final isTravelValid = state.isTravelValid;
                debugPrint('Is travel valid: $isTravelValid');

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
                      if (isTravelValid) {
                        final state = context.read<RegisterTravelProvider>();

                        if (!_travelTitleFormKey.currentState!.validate()) {
                          await showDialog(
                            context: context,
                            builder: (context) {
                              return CustomDialog(
                                title: as.warning,

                                /// TODO: intl
                                content: Text('Invalid travel title'),
                                isError: true,
                              );
                            },
                          );

                          return;
                        }

                        await state.registerTravel(_travelTitleController.text);
                        await context.read<TravelListProvider>().update();

                        if (state.hasError) {
                          await showDialog(
                            context: context,
                            builder: (context) {
                              return CustomDialog(
                                title: as.warning,
                                content: Text(state.error!),
                                isError: true,
                              );
                            },
                          );

                          return;
                        }

                        await showDialog(
                          context: context,
                          builder: (context) {
                            return CustomDialog(
                              title: as.title_register_travel,
                              content: Text(as.travel_registered_successfully),
                            );
                          },
                        );
                      }
                    },
                    child: Text(as.title_register_travel),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DateRangePickerRow extends StatefulWidget {
  const DateRangePickerRow({super.key});

  @override
  State<DateRangePickerRow> createState() => _DateRangePickerRowState();
}

class _DateRangePickerRowState extends State<DateRangePickerRow> {
  final _startController = TextEditingController();
  final _endController = TextEditingController();

  static const int _maxYear = 2100;
  final DateFormat _dateFormat = DateFormat('MM/dd/yyyy');

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
          _startController.text = _formatDate(newDate);

          if (state.endDate?.isBefore(newDate) == true) {
            state.endDate = null;
            _endController.clear();
          }
        } else {
          state.endDate = newDate;
          _endController.text = _formatDate(newDate);
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    final state = context.read<RegisterTravelProvider>();
    _startController.text = _formatDate(state.startDate);
    _endController.text = _formatDate(state.endDate);
  }

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: TextFormField(
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            controller: _startController,
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
          child: TextFormField(
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            controller: _endController,
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
    );
  }
}

class AddParticipant extends StatefulWidget {
  const AddParticipant({super.key});

  @override
  State<AddParticipant> createState() => _AddParticipantState();
}

class _AddParticipantState extends State<AddParticipant>
    with SingleTickerProviderStateMixin {
  final participantNameController = TextEditingController();
  final participantAgeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> onSubmit() async {
    final as = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate()) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(as.warning),
            content: Text(as.err_invalid_participant_data),
          );
        },
      );

      return;
    }

    final state = context.read<RegisterTravelProvider>();

    final participant = Participant(
      name: participantNameController.text,
      age: int.parse(participantAgeController.text),
      profilePicture: await FileService().getDefaultProfilePictureFile(),
    );

    participantNameController.clear();
    participantAgeController.clear();

    await state.addParticipant(participant);

    if (state.hasError) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(as.warning),
            content: Text(state.error!),
          );
        },
      );

      return;
    }

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(as.participant_added),
          icon: const Icon(Icons.check, color: Colors.green),
        );
      },
    );
  }

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

  @override
  void dispose() {
    participantNameController.dispose();
    participantAgeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;

    return Card(
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
                  child: ElevatedButton(
                    onPressed: () => _showParticipantModal(context),
                    child: Text(as.add),
                  ),
                ),
              ],
            ),
            Consumer<RegisterTravelProvider>(
              builder: (_, state, __) {
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
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 16,
                        ),
                        child: ListTile(
                          title: Text(participant.name),
                          subtitle: Text('${as.age}: ${participant.age}'),
                        ),
                      ),
                    );
                  },

                  itemBuilder: (context, animation, participant, i) {
                    return SizeFadeTransition(
                      animation: animation,
                      child: Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 16,
                        ),
                        child: ListTile(
                          onTap: () => _showParticipantModal(
                            context,
                            participant: participant,
                          ),
                          leading: CircleAvatar(
                            backgroundImage: FileImage(
                              participant.profilePicture,
                            ),
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.transparent,
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
      await state.addParticipant(result);
    } else {
      debugPrint('update participant');
      await state.updateParticipant(participant, result);
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
    _profilePicture = await FileService().pickImage();
    setState(() {});
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
                    return CircleAvatar(
                      backgroundImage: _profilePicture != null
                          ? FileImage(_profilePicture!)
                          : const AssetImage(
                                  'assets/images/default_profile_picture.png',
                                )
                                as ImageProvider,
                      backgroundColor: Colors.transparent,
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
                        /// TODO: show a modal to choose where the image is going
                        /// to be picked from (camera, gallery, etc.)
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

class RoutePlanning extends StatelessWidget {
  const RoutePlanning({super.key});

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;

    final baseColor = Theme.of(
      context,
    ).elevatedButtonTheme.style!.backgroundColor!.resolve({})!;

    return Card(
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
                    /// TODO: go to map page
                    onPressed: () {
                      context.push(Routes.travelMap);
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
    );
  }
}

class RegisteredStops extends StatefulWidget {
  const RegisteredStops({super.key});

  @override
  State<RegisteredStops> createState() => _RegisteredStopsState();
}

class _RegisteredStopsState extends State<RegisteredStops> {
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

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;

    return Card(
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
            // Padding(padding: EdgeInsets.all(26)),
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
                      Text(as.no_stops_registered, textAlign: TextAlign.center),
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
                      final stop = state.stops[index];
                      return ListTile(
                        shape: Theme.of(context).cardTheme.shape,
                        leading: Builder(
                          builder: (context) {
                            if (index == 0) {
                              /// First stop
                              return CircleAvatar(
                                backgroundColor: Theme.of(context)
                                    .elevatedButtonTheme
                                    .style!
                                    .backgroundColor!
                                    .resolve({}),
                                child: const Center(
                                  child: Icon(FontAwesomeIcons.paperPlane),
                                ),
                              );
                            } else if (index == stops.length - 1) {
                              /// Last stop
                              return CircleAvatar(
                                backgroundColor: Theme.of(context)
                                    .elevatedButtonTheme
                                    .style!
                                    .backgroundColor!
                                    .resolve({}),
                                child: const Center(
                                  child: Icon(FontAwesomeIcons.flag),
                                ),
                              );
                            } else {
                              /// Waypoint
                              return CircleAvatar(
                                backgroundColor: Theme.of(context)
                                    .elevatedButtonTheme
                                    .style!
                                    .backgroundColor!
                                    .resolve({}),
                                child: const Center(
                                  child: Icon(Icons.location_on),
                                ),
                              );
                            }
                          },
                        ),
                        title: Text('${stop.place.city!}'),
                        subtitle: Text(
                          '${stop.place.city!}, ${stop.place.country!}',
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
                /// TODO: intl
                child: Text(
                  'Use the map to modify your route or to add more waypoints',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TravelPhotos extends StatelessWidget {
  const _TravelPhotos({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
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
                  'Travel Photos',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ],
            ),
            Padding(padding: EdgeInsets.all(16)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 48),
                decoration: BoxDecoration(
                  border: BoxBorder.all(
                    color: Theme.of(context).iconTheme.color!,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 6,
                  children: [
                    Icon(Icons.camera_alt, size: 42),
                    Text(
                      'Add Travel Photos',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      'Tap to select photos',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '0 of 5 photos added',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const Padding(padding: EdgeInsets.all(2)),
                    UnconstrainedBox(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Row(
                          children: [
                            const Icon(Icons.file_upload_outlined),
                            Text('Choose Photos'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Text(
                'Add photos to make your travel more memorable and visually appealing',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
