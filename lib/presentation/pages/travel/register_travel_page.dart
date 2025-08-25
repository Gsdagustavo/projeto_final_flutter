import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/enums.dart';
import '../../../domain/entities/participant.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/file_service.dart';
import '../../extensions/enums_extensions.dart';
import '../../providers/register_travel_provider.dart';
import '../../widgets/theme_toggle_button.dart';
import '../util/form_validations.dart';

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

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: false,
              snap: false,
              expandedHeight: 120,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Text(
                as.title_register_travel,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              actions: const [ThemeToggleButton()],
            ),

            SliverToBoxAdapter(
              child: Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            /// TODO: intl
                            'Travel Details',
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          Padding(padding: EdgeInsets.all(26)),
                          Text(
                            as.travel_title_label,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Padding(padding: EdgeInsets.all(2)),
                          Form(
                            key: _travelTitleFormKey,
                            child: TextFormField(
                              onTapOutside: (_) =>
                                  FocusScope.of(context).unfocus(),
                              controller: _travelTitleController,
                              decoration: InputDecoration(
                                /// TODO: intl
                                hintText: 'Enter travel title...',
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(12)),
                          Text(
                            as.transport_type_label,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Padding(padding: EdgeInsets.all(2)),
                          DropdownButtonFormField<TransportType>(
                            borderRadius: BorderRadius.circular(12),
                            value: _selectedTransportType,
                            icon: Icon(Icons.keyboard_arrow_down),
                            isExpanded: true,
                            items: [
                              for (final entry in _transportTypesIcons.entries)
                                DropdownMenuItem<TransportType>(
                                  value: entry.key,
                                  child: Row(
                                    children: [
                                      Icon(entry.value),
                                      Padding(padding: EdgeInsets.all(6)),
                                      Text(
                                        entry.key.getIntlTransportType(context),
                                      ),
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
                          Padding(padding: EdgeInsets.all(12)),
                          DateRangePickerRow(),
                        ],
                      ),
                    ),
                  ),

                  AddParticipant(),
                ],
              ),
            ),
          ],
        ),
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
  DateTime? _startDate;
  DateTime? _endDate;

  final _startController = TextEditingController();
  final _endController = TextEditingController();

  static const int _maxYear = 2100;
  final DateFormat _dateFormat = DateFormat('MM/dd/yyyy');

  String _formatDate(DateTime date) {
    return _dateFormat.format(date);
  }

  Future<void> _pickDate({required bool isStart}) async {
    final initialDate = DateTime.now();
    var firstDate = DateTime.now();
    var lastDate = DateTime(_maxYear);

    if (isStart && _endDate != null) {
      lastDate = _endDate!;
    } else if (!isStart && _startDate != null) {
      firstDate = _startDate!;
    }

    DateTime pickInitialDate;
    if (isStart) {
      pickInitialDate = _startDate ?? initialDate;
      if (pickInitialDate.isAfter(lastDate)) pickInitialDate = lastDate;
      if (pickInitialDate.isBefore(firstDate)) pickInitialDate = firstDate;
    } else {
      pickInitialDate = _endDate ?? initialDate;
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
          _startDate = newDate;
          _startController.text = _formatDate(newDate);

          if (_endDate?.isBefore(newDate) == true) {
            _endDate = null;
            _endController.clear();
          }
        } else {
          _endDate = newDate;
          _endController.text = _formatDate(newDate);
        }
      });
    }
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
  late AnimationController _controller;
  late Animation<double> _animation;
  var isExpanded = false;

  final participantNameController = TextEditingController();
  final participantAgeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> onSubmit() async {
    if (!_formKey.currentState!.validate()) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Warning'),
            content: Text('Invalid participant data'),
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
            title: Text('Warning'),
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
          title: Text('Participant added!'),
          icon: Icon(Icons.check, color: Colors.green),
        );
      },
    );
  }

  void onCancel() {
    setState(() {
      participantNameController.clear();
      participantAgeController.clear();
      _formKey.currentState!.reset();
      isExpanded = false;

      _controller.reverse();
    });
  }

  void toggle() {
    setState(() {
      _formKey.currentState!.reset();
      isExpanded = !isExpanded;

      if (isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    participantNameController.dispose();
    participantAgeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;
    final validations = FormValidations(as);

    debugPrint('Is expanded: $isExpanded');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Consumer<RegisterTravelProvider>(
                  builder: (_, state, __) {
                    return Text(
                      'Participants (${state.participants.length})',
                      style: Theme.of(context).textTheme.displaySmall,
                    );
                  },
                ),
                InkWell(
                  onTap: toggle,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 24,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(
                        context,
                      ).listTileTheme.iconColor?.withValues(alpha: 0.1),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.add),
                        SizedBox(width: 6),
                        Text('Add'),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Padding(padding: EdgeInsets.all(16)),

            ClipRRect(
              child: SizeTransition(
                axisAlignment: 1,
                sizeFactor: _animation,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Builder(
                          builder: (context) {
                            return Column(
                              children: [
                                TextFormField(
                                  validator:
                                      validations.participantNameValidator,
                                  controller: participantNameController,
                                  decoration: InputDecoration(
                                    labelText: as.name,
                                  ),
                                ),
                                Padding(padding: EdgeInsets.all(12)),
                                TextFormField(
                                  validator:
                                      validations.participantAgeValidator,
                                  controller: participantAgeController,
                                  decoration: InputDecoration(
                                    labelText: as.age,
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(12)),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: onSubmit,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Theme.of(context)
                                      .listTileTheme
                                      .iconColor
                                      ?.withValues(alpha: 0.1),
                                ),
                                child: Center(child: Text('Add Participant')),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: onCancel,
                              child: Text(as.cancel),
                            ),
                          ),
                        ],
                      ),
                    ],
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
