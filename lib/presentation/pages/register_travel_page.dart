import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/extensions/date_extensions.dart';
import '../../core/extensions/string_extensions.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/travel_stop.dart';
import '../../l10n/app_localizations.dart';
import '../../services/locale_service.dart';
import '../extensions/enums_extensions.dart';
import '../providers/register_travel_provider.dart';
import '../providers/travel_list_provider.dart';
import '../widgets/custom_dialog.dart';
import 'fab_page.dart';
import 'map.dart';

/// This is a page for registering a travel
class RegisterTravelPage extends StatelessWidget {
  /// Constant constructor
  const RegisterTravelPage({super.key});

  /// The route of the page
  static const String routeName = '/registerTravel';

  void _showCustomDialog(BuildContext context) async {
    final travelState = Provider.of<RegisterTravelProvider>(
      context,
      listen: false,
    );

    unawaited(
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          final as = AppLocalizations.of(context)!;
          final Widget icon;
          Widget content;

          if (travelState.isLoading) {
            content = const SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(),
            );
          }

          /// Determine which icon and text to show
          if (travelState.hasError) {
            content = Text(
              travelState.error ?? as.unknown_error,
              textAlign: TextAlign.center,
            );
            icon = const Icon(Icons.error, color: Colors.red);
          } else {
            content = Text(
              as.travel_registered_successfully,
              textAlign: TextAlign.center,
            );
            icon = const Icon(Icons.check_circle, color: Colors.green);
          }

          return AlertDialog(
            icon: icon,
            alignment: Alignment.center,
            content: content,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final travelState = Provider.of<RegisterTravelProvider>(context);

    return FabPage(
      title: AppLocalizations.of(context)!.title_register_travel,

      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Travel title text field
              const _TravelTitleTextField(),
              const Padding(padding: EdgeInsets.all(16)),

              /// Transport types dropdown button
              const _TransportTypesDropdownButton(),
              const Padding(padding: EdgeInsets.all(16)),

              /// Text buttons to choose the Travel Start and End dates
              const _DateTextButtons(),
              const Padding(padding: EdgeInsets.all(16)),

              /// List all participants and add new participants
              const _ParticipantsWidget(),
              const Padding(padding: EdgeInsets.all(16)),

              const _TravelMapWidget(),
              const Padding(padding: EdgeInsets.all(16)),

              if (travelState.isTravelValid)
                SizedBox(
                  height: 64,
                  width: double.infinity,
                  child: const _RegisterTravelButton(),
                ),
            ],
          ),
        ),
      ),

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            tooltip: 'Register travel',
            child: const Icon(Icons.app_registration),
            onPressed: () async {
              final registerTravelState = Provider.of<RegisterTravelProvider>(
                context,
                listen: false,
              );

              _showCustomDialog(context);
              await registerTravelState.registerTravel();
              await context.read<TravelListProvider>().update();

              await Future.delayed(const Duration(seconds: 2));

              Navigator.pop(context);
            },
          ),

          const Padding(padding: EdgeInsets.all(16)),

          FloatingActionButton(
            tooltip: 'List travels',
            child: const Icon(Icons.get_app),
            onPressed: () async {
              final registerTravelState = Provider.of<RegisterTravelProvider>(
                context,
                listen: false,
              );

              await registerTravelState.select();
            },
          ),

          FloatingActionButton(
            tooltip: 'List Stops',
            child: const Icon(Icons.stop),
            onPressed: () async {
              final registerTravelState = Provider.of<RegisterTravelProvider>(
                context,
                listen: false,
              );

              debugPrint(registerTravelState.stops.toString());
            },
          ),
        ],
      ),
    );
  }
}

class _TravelTitleTextField extends StatelessWidget {
  const _TravelTitleTextField();

  String? validator(String? input) {
    if (input == null || input.isEmpty || input.length < 3)
      return 'Invalid Travel Title';

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final travelState = Provider.of<RegisterTravelProvider>(context);
    final as = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          as.travel_title_label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const Padding(padding: EdgeInsets.all(12)),
        Form(
          key: travelState.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: TextFormField(
            validator: validator,
            controller: travelState.travelTitleController,
            onTapUpOutside: (_) => FocusScope.of(context).unfocus(),
            decoration: InputDecoration(
              label: Text(as.travel_title_label),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TransportTypesDropdownButton extends StatelessWidget {
  const _TransportTypesDropdownButton();

  @override
  Widget build(BuildContext context) {
    final travelState = Provider.of<RegisterTravelProvider>(context);
    final as = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          as.transport_type_label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const Padding(padding: EdgeInsets.all(12)),

        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: BoxBorder.all(color: Theme.of(context).hintColor, width: 1),
          ),

          child: DropdownButton<TransportType>(
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
                      item.getIntlTransportType(context).capitalizedAndSpaced,
                    ),
                  ),
                ),
            ],

            onChanged: travelState.selectTransportType,
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
  late Future<String> _localeFuture;

  @override
  void initState() {
    super.initState();
    _localeFuture = LocaleService().loadLanguageCode();
  }

  @override
  Widget build(BuildContext context) {
    final travelState = Provider.of<RegisterTravelProvider>(context);
    final as = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          as.select_dates_label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const Padding(padding: EdgeInsets.all(10)),

        FutureBuilder(
          future: _localeFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              showDialog(
                context: context,
                builder: (context) {
                  return CustomDialog(
                    title: as.unknown_error,
                    content: Text(snapshot.error!.toString()),
                    isError: true,
                  );
                },
              );
            }

            final locale = snapshot.data!;

            if (locale.isEmpty) {
              showDialog(
                context: context,
                builder: (context) {
                  return CustomDialog(
                    title: as.warning,
                    content: Text(as.unknown_error),
                    isError: true,
                  );
                },
              );
            }

            return Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                          style: ButtonStyle(
                            padding: WidgetStateProperty.all(EdgeInsets.zero),
                          ),

                          onPressed: () async {
                            final now = DateTime.now();
                            var date = await showDatePicker(
                              context: context,
                              initialDate: travelState.startDate ?? now,
                              firstDate: now,
                              lastDate: now.add(const Duration(days: 365)),
                            );
                            travelState.selectStartDate(date);
                          },
                          child: Text(as.travel_start_date_label),
                        ),

                        if (travelState.startDate != null)
                          Text(travelState.startDate!.getFormattedDate(locale)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () async {
                            if (!travelState.isStartDateSelected) {
                              final message = as.err_invalid_date_snackbar;

                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(SnackBar(content: Text(message)));

                              return;
                            }

                            var date = await showDatePicker(
                              context: context,
                              initialDate:
                                  travelState.endDate ?? travelState.startDate,
                              firstDate: travelState.startDate!,
                              lastDate: travelState.startDate!.add(
                                const Duration(days: 365),
                              ),
                            );
                            travelState.selectEndDate(date);
                          },
                          child: Text(as.travel_end_date_label),
                        ),

                        if (travelState.endDate != null)
                          Text(travelState.endDate!.getFormattedDate(locale)),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ParticipantsWidget extends StatelessWidget {
  const _ParticipantsWidget();

  @override
  Widget build(BuildContext context) {
    final travelState = Provider.of<RegisterTravelProvider>(context);

    final as = AppLocalizations.of(context)!;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              as.participants,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            TextButton(
              child: Text(
                as.register_participant,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              onPressed: () async {
                await _showParticipantRegisterModal(context, travelState);
              },
            ),
          ],
        ),

        const Padding(padding: EdgeInsets.all(12)),

        _ListParticipants(),
      ],
    );
  }

  Future<void> _showParticipantRegisterModal(
    BuildContext context,
    RegisterTravelProvider travelState,
  ) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _Modal(travelState);
      },
    );
  }
}

class _Modal extends StatefulWidget {
  const _Modal(this.travelState);

  final RegisterTravelProvider travelState;

  @override
  State<_Modal> createState() => _ModalState();
}

class _ModalState extends State<_Modal> {
  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;

    return StatefulBuilder(
      builder: (context, setModalState) {
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
                          TextField(
                            onTapOutside: (_) =>
                                FocusScope.of(context).unfocus(),
                            controller:
                                widget.travelState.participantNameController,
                            decoration: InputDecoration(
                              hintText: as.name,
                              prefixIcon: const Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.all(16)),

                          TextField(
                            onTapOutside: (_) =>
                                FocusScope.of(context).unfocus(),
                            controller:
                                widget.travelState.participantAgeController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: as.age,
                              prefixIcon: const Icon(Icons.timer),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.all(16)),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(as.cancel),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  await widget.travelState.addParticipant();
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(as.participant_registered),
                                    ),
                                  );
                                },

                                child: Text(as.register),
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
                    child: CircleAvatar(
                      backgroundImage:
                          widget.travelState.profilePictureFile != null
                          ? FileImage(widget.travelState.profilePictureFile!)
                          : const AssetImage(
                                  'assets/images/default_profile_picture.png',
                                )
                                as ImageProvider,
                      backgroundColor: Colors.transparent,
                    ),
                  ),

                  Positioned(
                    bottom: 0,
                    right: 2,
                    child: InkWell(
                      onTap: () async {
                        /// TODO: show a modal to choose where the image is going to be picked from (camera, gallery, etc.)
                        await widget.travelState.pickImage();

                        setModalState(() {});
                      },
                      radius: 20,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: Center(
                          child: Icon(
                            Icons.edit,
                            size: 32,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ListParticipants extends StatelessWidget {
  const _ListParticipants();

  @override
  Widget build(BuildContext context) {
    final travelState = Provider.of<RegisterTravelProvider>(context);
    final as = AppLocalizations.of(context)!;

    if (travelState.numParticipants <= 0) {
      return Text(as.no_participants_on_the_list);
    }

    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: travelState.numParticipants,
      itemBuilder: (context, index) {
        final participant = travelState.participants[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              _ParticipantProfilePicture(image: participant.profilePicture),
              const Padding(padding: EdgeInsets.all(8)),

              Text(
                '${as.name}: ${participant.name}\n'
                '${as.age}: ${participant.age}',
              ),

              const Spacer(),

              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
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
                            onPressed: () => Navigator.pop(context, false),
                          ),
                          TextButton(
                            child: Text(as.remove),
                            onPressed: () => Navigator.pop(context, true),
                          ),
                        ],
                      );
                    },
                  );

                  if (result != null && result == true) {
                    travelState.removeParticipant(index);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(as.participant_removed)),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TravelMapWidget extends StatelessWidget {
  const _TravelMapWidget();

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          as.travel_map,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const Padding(padding: EdgeInsets.all(10)),

        Text(as.add_stops_for_your_travel),

        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, TravelMap.routeName);
          },
          icon: const Icon(Icons.map),
        ),
      ],
    );
  }
}

class _RegisterTravelButton extends StatelessWidget {
  const _RegisterTravelButton({super.key});

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

            if (!travelState.isTravelValid) {
              await showDialog(
                context: context,
                builder: (context) {
                  return CustomDialog(
                    title: as.warning,
                    content: Text(as.invalid_travel_data),
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
          },
          child: Text(as.title_register_travel),
        );
      },
    );
  }
}

class _TravelStopWidget extends StatelessWidget {
  const _TravelStopWidget({super.key, required this.travelStop});

  final TravelStop travelStop;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.pin_drop, color: Colors.red),
            Container(height: 50, child: Text(travelStop.place.display)),
          ],
        ),
      ],
    );
  }
}

class _ParticipantProfilePicture extends StatelessWidget {
  const _ParticipantProfilePicture({
    super.key,
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
