import 'package:flutter/material.dart';

import '../entities/enums.dart';

class RegisterTravelProvider with ChangeNotifier {
  final _travelTitleController = TextEditingController();
  var _selectedTransportType = TransportType.values.first;

  final Map<Experience, bool> _selectedExperiences = {
    for (final e in Experience.values) e: false,
  };



  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  void registerTravel() {
    final travelTitle = _travelTitleController.text;
    debugPrint('Travel title: $travelTitle');

    debugPrint('Selected experiences: $_selectedExperiences');

    debugPrint('Start date: $_selectedStartDate');
    debugPrint('End date: $_selectedEndDate');
  }

  void selectTransportType(TransportType? value) {
    if (_selectedTransportType == value) return;
    _selectedTransportType = value ?? TransportType.values.first;
    notifyListeners();
  }

  void checkExperience(Experience item, bool? value) {
    _selectedExperiences[item] = value ?? false;
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

  get travelTitleController => _travelTitleController;

  bool get isStartDateSelected => _selectedStartDate != null;

  get selectedTransportType => _selectedTransportType;

  Map<Experience, bool> get selectedExperiences => _selectedExperiences;

  DateTime? get selectedStartDate => _selectedStartDate;

  DateTime? get selectedEndDate => _selectedEndDate;
}
