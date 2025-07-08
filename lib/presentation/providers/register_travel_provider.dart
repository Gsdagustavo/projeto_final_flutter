import 'package:flutter/material.dart';

import '../../entities/enums.dart';
import '../../entities/participant.dart';
import '../../entities/travel.dart';
import '../../entities/travel_stop.dart';
import '../../modules/travel/travel_usecases.dart';

class RegisterTravelProvider with ChangeNotifier {
  final TravelUseCasesImpl _travelUseCases;

  RegisterTravelProvider(this._travelUseCases);

  final _travelTitleController = TextEditingController();
  var _selectedTransportType = TransportType.values.first;

  final _participants = <Participant>[];

  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  final _nameController = TextEditingController();
  final _ageController = TextEditingController();

  Future<void> registerTravel() async {
    final travel = Travel(
      travelTitle: _travelTitleController.text,
      participants: participants,
      startDate: _selectedStartDate,
      endDate: _selectedEndDate,
      transportType: _selectedTransportType,
      stops: [
        TravelStop(
          cityName: 'Goiaba',
          latitude: 10,
          longitude: 10,
          arriveDate: DateTime.now(),
          leaveDate: DateTime.now().add(Duration(days: 1)),
          experiences: [Experience.visitHistoricalPlaces],
        ),
      ],
    );

    debugPrint('TRAVEL INSTANCE:\n${travel.toString()}');

    await _travelUseCases.registerTravel(travel);
    _resetForms();
  }

  void _resetForms() {
    _selectedTransportType = TransportType.values.first;

    _selectedStartDate = null;
    _selectedEndDate = null;

    _travelTitleController.clear();
    _nameController.clear();
    _ageController.clear();

    _participants.clear();

    notifyListeners();
  }

  Future<void> select() async {
    await _travelUseCases.getAllTravels();
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
      profilePicturePath: profilePictureUrl,
    );

    _nameController.clear();
    _ageController.clear();

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
