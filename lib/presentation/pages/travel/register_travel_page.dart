import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../core/extensions/date_extensions.dart';
import '../../../core/extensions/string_extensions.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/participant.dart';
import '../../../domain/entities/travel_stop.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/file_service.dart';
import '../../extensions/enums_extensions.dart';
import '../../providers/map_markers_provider.dart';
import '../../providers/register_travel_provider.dart';
import '../../providers/travel_list_provider.dart';
import '../../providers/user_preferences_provider.dart';
import '../../scripts/scripts.dart';
import '../../util/app_routes.dart';
import '../../widgets/custom_date_range_widget.dart';
import '../../widgets/custom_dialog.dart';
import '../../widgets/fab_list_item.dart';
import '../../widgets/fab_page.dart';
import '../util/form_validations.dart';

/// This is a page for registering a travel
class RegisterTravelPage extends StatelessWidget {
  /// Constant constructor
  const RegisterTravelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FabPage(
      title: AppLocalizations.of(context)!.title_register_travel,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: SingleChildScrollView(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Travel title text field
              _TravelTitleTextField(),
              const Padding(padding: EdgeInsets.all(16)),

              /// Transport types dropdown button
              _TransportTypesDropdownButton(),
              const Padding(padding: EdgeInsets.all(16)),

              /// Text buttons to choose the Travel Start and End dates
              _DateTextButtons(),

              /// List all participants and add new participants
              _ParticipantsWidget(),

              _TravelMapWidget(),
              const Padding(padding: EdgeInsets.all(16)),

              if (Provider.of<RegisterTravelProvider>(context).isTravelValid)
                SizedBox(
                  height: 64,
                  width: double.infinity,
                  child: const _RegisterTravelButton(),
                ),
            ],
          ),
        ),
      ),

      // floatingActionButton: Column(
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   crossAxisAlignment: CrossAxisAlignment.end,
      //   children: [
      //     FloatingActionButton(
      //       tooltip: 'List travels',
      //       child: const Icon(Icons.get_app),
      //       onPressed: () async {
      //         final registerTravelState = Provider.of<RegisterTravelProvider>(
      //           context,
      //           listen: false,
      //         );
      //
      //         await registerTravelState.select();
      //       },
      //     ),
      //
      //     FloatingActionButton(
      //       tooltip: 'List Stops',
      //       child: const Icon(Icons.stop),
      //       onPressed: () async {
      //         final registerTravelState = Provider.of<RegisterTravelProvider>(
      //           context,
      //           listen: false,
      //         );
      //
      //         debugPrint(registerTravelState.stops.toString());
      //       },
      //     ),
      //   ],
      // ),
    );
  }
}

class _TravelTitleTextField extends StatefulWidget {
  const _TravelTitleTextField();

  @override
  State<_TravelTitleTextField> createState() => _TravelTitleTextFieldState();
}

class _TravelTitleTextFieldState extends State<_TravelTitleTextField> {
  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;
    final validations = FormValidations(as);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          as.travel_title_label,
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const Padding(padding: EdgeInsets.all(12)),
        Consumer<RegisterTravelProvider>(
          builder: (_, travelState, __) {
            return Form(
              key: travelState.travelTitleFormKey,
              child: TextFormField(
                textCapitalization: TextCapitalization.words,
                validator: validations.travelTitleValidator,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: travelState.travelTitleController,
                onTapUpOutside: (_) => FocusScope.of(context).unfocus(),
                decoration: InputDecoration(label: Text(as.travel_title_label)),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _TransportTypesDropdownButton extends StatelessWidget {
  const _TransportTypesDropdownButton();

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          as.transport_type_label,
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const Padding(padding: EdgeInsets.all(12)),

        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: BoxBorder.all(
              color: Theme.of(
                context,
              ).inputDecorationTheme.enabledBorder!.borderSide.color,
              width: 0.5,
            ),
          ),

          child: Consumer<RegisterTravelProvider>(
            builder: (_, travelState, __) {
              return DropdownButton<TransportType>(
                value: travelState.transportType,
                icon: const Icon(Icons.arrow_downward),
                underline: Container(color: Colors.transparent),
                borderRadius: BorderRadius.circular(12),
                isExpanded: true,

                items: [
                  for (final item in TransportType.values)
                    DropdownMenuItem(
                      value: item,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          item
                              .getIntlTransportType(context)
                              .capitalizedAndSpaced,
                        ),
                      ),
                    ),
                ],

                onChanged: travelState.selectTransportType,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _DateTextButtons extends StatefulWidget {
  const _DateTextButtons();

  @override
  State<_DateTextButtons> createState() => _DateTextButtonsState();
}

class _DateTextButtonsState extends State<_DateTextButtons> {
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final travelState = Provider.of<RegisterTravelProvider>(
      context,
      listen: false,
    );

    final as = AppLocalizations.of(context)!;

    final locale = Provider.of<UserPreferencesProvider>(
      context,
      listen: false,
    ).languageCode;

    _startDateController.text =
        travelState.travelTimeRange?.start.getFormattedDate(locale) ?? '';
    _endDateController.text =
        travelState.travelTimeRange?.end.getFormattedDate(locale) ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              as.dates_label,
              style: Theme.of(context).textTheme.displayMedium,
            ),

            TextButton(
              onPressed: () async {
                final now = DateTime.now();

                final range = await showDateRangePicker(
                  context: context,
                  firstDate: now,
                  lastDate: now.add(Duration(days: 365)),
                );

                if (range != null) {
                  travelState.travelTimeRange = range;
                }
              },
              child: Text(as.select_dates_label),
            ),
          ],
        ),

        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: CustomDateRangeWidget(
              firstDateController: _startDateController,
              lastDateController: _endDateController,
              firstDateLabelText: as.start_date,
              lastDateLabelText: as.end_date,
            ),
          ),
        ),
      ],
    );
  }
}

class _ParticipantsWidget extends StatelessWidget {
  const _ParticipantsWidget();

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              as.participants,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            Expanded(
              child: TextButton(
                child: Text(
                  as.register_participant,
                  textAlign: TextAlign.center,
                ),
                onPressed: () async {
                  await _showParticipantModal(context);
                },
              ),
            ),
          ],
        ),

        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: _ListParticipants(),
          ),
        ),
      ],
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
      await state.addParticipant(result);
    } else {
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
          borderRadius: BorderRadius.only(
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
                          decoration: BoxDecoration(
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
                padding: const EdgeInsets.all(32.0),
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

                      /// 'Cancel' / 'Register' buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// 'Cancel' button
                          TextButton(
                            onPressed: () => context.pop(),
                            child: Text(as.cancel),
                          ),

                          Builder(
                            builder: (context) {
                              debugPrint('${widget.participant == null}');

                              /// Register participant
                              if (widget.participant == null) {
                                return Consumer<RegisterTravelProvider>(
                                  builder: (_, travelState, __) {
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
                                        }

                                        final participant = Participant(
                                          name: _nameController.text,
                                          age: int.parse(_ageController.text),
                                          profilePicture:
                                              _profilePicture ??
                                              await FileService()
                                                  .getDefaultProfilePictureFile(),
                                        );

                                        Navigator.of(context).pop(participant);
                                      },
                                      child: Text(as.register),
                                    );
                                  },
                                );
                              }

                              /// Update participant
                              return Consumer<RegisterTravelProvider>(
                                builder: (_, travelState, __) {
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
                                      }

                                      final participant = Participant(
                                        name: _nameController.text,
                                        age: int.parse(_ageController.text),
                                        profilePicture:
                                            _profilePicture ??
                                            await FileService()
                                                .getDefaultProfilePictureFile(),
                                      );

                                      Navigator.of(context).pop(participant);
                                    },
                                    child: Text(as.update_participant),
                                  );
                                },
                              );
                            },
                          ),
                        ],
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
                        child: Center(child: Icon(Icons.edit, size: 32)),
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

class _ListParticipants extends StatelessWidget {
  const _ListParticipants();

  void onParticipantRemoved(
    BuildContext context,
    Participant participant,
  ) async {
    final as = AppLocalizations.of(context)!;
    final travelState = Provider.of<RegisterTravelProvider>(
      context,
      listen: false,
    );

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(as.remove),
          content: Text(
            '${as.remove_participant_confirmation} '
            '${participant.name}?',
          ),

          icon: const Icon(Icons.warning, color: Colors.red),

          actions: [
            TextButton(
              child: Text(as.cancel),
              onPressed: () => context.pop(false),
            ),
            TextButton(
              child: Text(as.remove),
              onPressed: () => context.pop(true),
            ),
          ],
        );
      },
    );

    if (result != null && result == true) {
      travelState.removeParticipant(participant);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(as.participant_removed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final travelState = Provider.of<RegisterTravelProvider>(context);
    final as = AppLocalizations.of(context)!;

    if (travelState.numParticipants <= 0) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(as.no_participants_on_the_list),
      );
    }

    return ListView.separated(
      separatorBuilder: (context, index) {
        return Padding(padding: EdgeInsets.all(12));
      },
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: travelState.numParticipants,
      itemBuilder: (context, index) {
        final participant = travelState.participants[index];
        return _ParticipantListItem(
          participant: participant,
          onParticipantRemoved: () {
            onParticipantRemoved(context, participant);
          },
        );
      },
    );
  }
}

class _ParticipantListItem extends StatelessWidget {
  const _ParticipantListItem({
    super.key,
    required this.participant,
    required this.onParticipantRemoved,
  });

  final Participant participant;
  final VoidCallback onParticipantRemoved;

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;

    return FabListItem(
      onTap: () async {
        await _showParticipantModal(context, participant: participant);
      },

      child: Row(
        children: [
          _ParticipantProfilePicture(image: participant.profilePicture),
          const Padding(padding: EdgeInsets.all(8)),

          Text(
            '${as.name}: ${participant.name}\n'
            '${as.age}: ${participant.age}',
          ),

          const Spacer(),

          Consumer<RegisterTravelProvider>(
            builder: (_, travelState, __) {
              return IconButton(
                icon: const Icon(Icons.delete),
                onPressed: onParticipantRemoved,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ParticipantProfilePicture extends StatelessWidget {
  const _ParticipantProfilePicture({
    required this.image,
    this.width = 36,
    this.height = 36,
  });

  final File image;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
      ),
      child: Image.file(image, fit: BoxFit.cover),
    );
  }
}

class _TravelMapWidget extends StatelessWidget {
  const _TravelMapWidget();

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              as.travel_map,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const Padding(padding: EdgeInsets.all(10)),

            Expanded(
              child: Consumer<RegisterTravelProvider>(
                builder: (_, travelState, __) {
                  return TextButton(
                    onPressed: () async {
                      final as = AppLocalizations.of(context)!;

                      if (travelState.travelTimeRange == null) {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return CustomDialog(
                              title: as.warning,
                              content: Text(
                                /// TODO: intl
                                'You must select the Travel Date Range first!',
                              ),
                              isError: true,
                            );
                          },
                        );

                        return;
                      }

                      context.push(Routes.travelMap);
                    },
                    child: Text(
                      as.add_stops_for_your_travel,
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
          ],
        ),

        Padding(padding: EdgeInsets.all(16)),

        _TravelStopsWidget(),
      ],
    );
  }
}

class _TravelStopsWidget extends StatelessWidget {
  const _TravelStopsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterTravelProvider>(
      builder: (_, state, __) {
        final stops = state.stops;

        if (stops.isEmpty) {
          final as = AppLocalizations.of(context)!;
          return Center(child: Text(as.no_stops_registered));
        }

        return ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: stops.length,
          separatorBuilder: (context, index) {
            return Padding(padding: EdgeInsets.all(12));
          },
          itemBuilder: (context, index) {
            final stop = stops[index];
            return _TravelStopListItem(stop: stop, index: index);
          },
        );
      },
    );
  }
}

class _TravelStopListItem extends StatelessWidget {
  const _TravelStopListItem({
    super.key,
    required this.stop,
    required this.index,
  });

  final TravelStop stop;
  final int index;

  @override
  Widget build(BuildContext context) {
    return FabListItem(
      onTap: () async {
        await showTravelStopModal(
          context,
          LatLng(stop.place.latitude, stop.place.longitude),
          stop,
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${index + 1}.'),
          Padding(padding: EdgeInsets.all(12)),
          Expanded(
            child: Text(stop.place.toString(), style: TextStyle(fontSize: 16)),
          ),
          Consumer2<RegisterTravelProvider, MapMarkersProvider>(
            builder: (_, travelState, markerState, __) {
              return IconButton(
                onPressed: () {
                  travelState.removeTravelStop(stop);
                  markerState.removeMarker(stop);
                },
                icon: Icon(Icons.delete),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _RegisterTravelButton extends StatelessWidget {
  const _RegisterTravelButton();

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;

    return Consumer<RegisterTravelProvider>(
      builder: (_, travelState, __) {
        return ElevatedButton(
          onPressed: () async {
            await travelState.registerTravel();

            if (travelState.hasError) {
              await showDialog(
                context: context,
                builder: (context) {
                  return CustomDialog(
                    title: as.warning,
                    content: Text(travelState.error!),
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
                  title: '',
                  content: Text(as.travel_registered_successfully),
                );
              },
            );

            Provider.of<MapMarkersProvider>(
              context,
              listen: false,
            ).resetMarkers(context);

            await Provider.of<TravelListProvider>(
              context,
              listen: false,
            ).update();
          },
          child: Text(as.title_register_travel),
        );
      },
    );
  }
}
