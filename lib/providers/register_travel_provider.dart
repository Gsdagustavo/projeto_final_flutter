import 'package:flutter/material.dart';

import '../entities/enums.dart';

class RegisterTravelProvider with ChangeNotifier {
  final _travelTitleController = TextEditingController();
  var _selectedTransportType = TransportType.values.first;

  final selectedExperiences = <Experience>[];

  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  int _numParticipants = 1;

  void registerTravel() {
    final travelTitle = _travelTitleController.text;
    debugPrint('Travel title: $travelTitle');

    debugPrint('Selected experiences: $selectedExperiences');
    debugPrint('Selected transport type: $_selectedTransportType');

    debugPrint('Start date: $_selectedStartDate');
    debugPrint('End date: $_selectedEndDate');
  }

  void selectTransportType(TransportType? value) {
    if (_selectedTransportType == value) return;
    _selectedTransportType = value ?? TransportType.values.first;
    notifyListeners();
  }

  void toggleExperience(Experience? item) {
    if (item == null) return;

    if (selectedExperiences.contains(item)) {
      selectedExperiences.remove(item);
    } else {
      selectedExperiences.add(item);
    }

    notifyListeners();
  }

  bool checkIfExperienceIsSelected(Experience item) {
    final contains = selectedExperiences.contains(item);
    return contains;
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

  void changeNumParticipants(int newValue) {
    if (_numParticipants == newValue) return;

    _numParticipants = newValue;
    notifyListeners();
  }

  get travelTitleController => _travelTitleController;

  bool get isStartDateSelected => _selectedStartDate != null;

  get selectedTransportType => _selectedTransportType;

  DateTime? get selectedStartDate => _selectedStartDate;

  DateTime? get selectedEndDate => _selectedEndDate;

  int get numParticipants => _numParticipants;
}
