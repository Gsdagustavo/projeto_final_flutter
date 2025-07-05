import 'package:flutter/material.dart';

import '../../entities/enums.dart';
import '../../entities/participant.dart';

class RegisterTravelProvider with ChangeNotifier {
  final _travelTitleController = TextEditingController();
  var _selectedTransportType = TransportType.values.first;

  final _participants = <Participant>[];

  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  final _nameController = TextEditingController();
  final _ageController = TextEditingController();

  void registerTravel() {
    final travelTitle = _travelTitleController.text;
    debugPrint('Travel title: $travelTitle');

    debugPrint('Selected transport type: $_selectedTransportType');

    debugPrint('Start date: $_selectedStartDate');
    debugPrint('End date: $_selectedEndDate');
  }

  void selectTransportType(TransportType? value) {
    if (_selectedTransportType == value) return;
    _selectedTransportType = value ?? TransportType.values.first;
    notifyListeners();
  }

  void selectStartDate(DateTime? date) {
    if (date == null) return;

    _selectedStartDate = date;

    if (_selectedStartDate != null && _selectedEndDate != null) {
      if (_selectedStartDate!.isAfter(_selectedEndDate!)) {
        _selectedEndDate = null;
      }
    }

    notifyListeners();
  }

  void selectEndDate(DateTime? date) {
    if (date == null) return;

    _selectedEndDate = date;
    notifyListeners();
  }

  void addParticipant([String? profilePictureUrl]) {
    var intAge = int.tryParse(_ageController.text);
    if (intAge == null) return;

    var participant = Participant(
      name: _nameController.text,
      age: intAge,
      profilePictureUrl: profilePictureUrl,
    );
    _participants.add(participant);
    notifyListeners();
  }

  get travelTitleController => _travelTitleController;

  int get numParticipants => _participants.length;

  get selectedTransportType => _selectedTransportType;

  get participants => _participants;

  DateTime? get selectedStartDate => _selectedStartDate;

  DateTime? get selectedEndDate => _selectedEndDate;

  get nameController => _nameController;

  get ageController => _ageController;

  bool get isStartDateSelected => selectedStartDate != null;
}
