import 'dart:io';

import 'package:flutter/material.dart';

import '../../domain/entities/enums.dart';
import '../../domain/entities/participant.dart';
import '../../domain/entities/travel.dart';
import '../../domain/entities/travel_stop.dart';
import '../../modules/travel/travel_use_cases.dart';

/// A [ChangeNotifier] responsible for managing and the app's Travel Register
/// system
///
/// It uses [TravelUseCasesImpl] for handling use cases related to registering a
/// travel
class RegisterTravelProvider with ChangeNotifier {
  /// Instance of [TravelUseCasesImpl]
  final TravelUseCasesImpl _travelUseCases;

  /// Default constructor
  RegisterTravelProvider(this._travelUseCases);

  /// A [TextEditingController] to be assigned to the travel title
  final _travelTitleController = TextEditingController();

  /// The selected travel [TransportType]
  var _transportType = TransportType.values.first;

  /// The list of [Participants] assigned to the travel
  final _participants = <Participant>[];

  var _stops = <TravelStop>[];

  /// The start date of the [Travel]
  DateTime? _startDate;

  /// The end date of the [Travel]
  DateTime? _endDate;

  /// The arrive date of the travel stop that will be registered
  DateTime? _arriveDate;

  /// The leave date of the travel stop that will be registered
  DateTime? _leaveDate;

  /// The selected experiences for the current travel stop
  Map<Experience, bool> _selectedExperiences = {
    for (var e in Experience.values) e: false,
  };

  /// If a [TravelStop] was given, populates [_selectedExperiences] with the
  /// [values] being whether or not the experience is in the [experiences] list
  ///
  /// Otherwise, set all [values] to [false] (no experience selected)
  void _resetExperiences([TravelStop? stop]) {
    debugPrint('Reset experiences called');
    var selectedExperiences = <Experience, bool>{};

    if (stop != null &&
        stop.experiences != null &&
        stop.experiences!.isNotEmpty) {
      for (final exp in Experience.values) {
        selectedExperiences[exp] = stop.experiences!.contains(exp);
      }
    } else {
      selectedExperiences = {for (final e in Experience.values) e: false};
    }

    _selectedExperiences = selectedExperiences;
    debugPrint('Selected experiences after reset: $_selectedExperiences');
    notifyListeners();
  }

  /// A [TextEditingController] to be assigned to a participant name
  final _participantNameController = TextEditingController();

  /// A [TextEditingController] to be assigned to a participant age
  final _participantAgeController = TextEditingController();

  /// The error message (obtained via exception.message on try-catch structures)
  String? _errorMsg;

  /// Whether there are any asynchronous methods being processed
  bool _isLoading = false;

  /// Tries to register a new [Travel] with the given inputs using
  /// [_travelUseCases]
  ///
  /// If any exception is caught during this process, the error message
  /// of the exception is assigned to [_errorMsg]
  ///
  /// Otherwise, [_errorMsg] is set to [Null]
  ///
  /// Currently, it is not working 100%, since there is no way of registering
  /// a travel stop, so it is generated automatically
  Future<void> registerTravel() async {
    _isLoading = true;
    notifyListeners();

    final lastStop = stops.last;
    _stops.last = lastStop.copyWith(type: TravelStopType.end);

    /// Instantiates a new travel with the given inputs
    final travel = Travel(
      travelTitle: _travelTitleController.text,
      participants: participants,
      startDate: _startDate,
      endDate: _endDate,
      transportType: _transportType,
      stops: _stops,
    );

    try {
      await _travelUseCases.registerTravel(travel);
    } on TravelRegisterException catch (e) {
      _errorMsg = e.message;
      _isLoading = false;
      notifyListeners();
      return;
    }

    _errorMsg = null;
    _isLoading = false;

    _resetForms();
  }

  void addTravelStop(TravelStop stop) {
    final lastArriveDate = lastPossibleArriveDate;
    final lastLeaveDate = lastPossibleLeaveDate;

    debugPrint('Arrive date: $_arriveDate');
    debugPrint('Leave date: $_leaveDate');

    if (_arriveDate == null || _leaveDate == null) {
      _errorMsg = 'Você precisa selecionar as datas de chegada e saída';
      notifyListeners();
      return;
    }

    if (_arriveDate!.isBefore(lastArriveDate!)) {
      _errorMsg =
          'A data de chegada não pode ser anterior à saída da última parada';
      notifyListeners();
      return;
    }

    if (_leaveDate!.isBefore(_arriveDate!)) {
      _errorMsg = 'A data de saída não pode ser anterior à data de chegada';
      notifyListeners();
      return;
    }

    if (_arriveDate!.isBefore(_startDate!) || _leaveDate!.isAfter(_endDate!)) {
      _errorMsg =
          'As datas da parada devem estar dentro do intervalo da viagem principal';
      notifyListeners();
      return;
    }

    if (_stops.isEmpty) {
      stop.type = TravelStopType.start;
    } else {
      stop.type = TravelStopType.stop;
    }

    stop.arriveDate = _arriveDate;
    stop.leaveDate = _leaveDate;

    _stops.add(stop);

    // Reset input fields
    _arriveDate = null;
    _leaveDate = null;
    _errorMsg = null;

    _resetExperiences();
    debugPrint('Travel stop ${stop.toString()} added');
    notifyListeners();
  }

  void removeTravelStop(TravelStop stop) {
    _stops.remove(stop);
    _resetExperiences();
    debugPrint('Stop $stop removed from travel stops list');
  }

  TravelStop updateTravelStop({
    required TravelStop stop,
    required List<Experience> experiences,
  }) {
    final newStop = stop.copyWith(
      experiences: experiences,
      arriveDate: _arriveDate,
      leaveDate: _leaveDate,
    );

    final idx = _stops.indexOf(stop);

    if (stop != _stops.last) {
      _stops = _stops.map((s) {
        debugPrint('Stop: $s, idx: ${_stops.indexOf(s)}');

        if (_stops.indexOf(s) > idx) {
          return s.copyWith(arriveDate: null, leaveDate: null);
        }

        return s;
      }).toList();
    }

    _stops.removeAt(idx);
    _stops.insert(idx, newStop);

    notifyListeners();
    return newStop;
  }

  /// Sets all input fields to their default values and cleanses all lists
  void _resetForms() {
    _transportType = TransportType.values.first;

    _startDate = null;
    _endDate = null;

    _travelTitleController.clear();
    _participantNameController.clear();
    _participantAgeController.clear();

    _participants.clear();

    _errorMsg = null;
    _isLoading = false;

    _resetExperiences();

    notifyListeners();
  }

  /// Sets the given [value] to [selectedTransportType]
  void selectTransportType(TransportType? value) {
    if (_transportType == value) return;
    _transportType = value ?? TransportType.values.first;
    notifyListeners();
  }

  void selectArriveDate(DateTime? arriveDate) {
    if (arriveDate == null) return;

    /// Arrive date is before travel start date
    if (arriveDate.isBefore(_startDate!)) {
      debugPrint('Arrive date cannot be before travel start date');
      return;
    }

    /// Arrive date is after travel end date
    if (arriveDate.isAfter(_endDate!)) {
      debugPrint('Arrive date cannot be after travel end date');
      return;
    }

    _arriveDate = arriveDate;
    notifyListeners();
  }

  /// Tries to set the [selectedEndDate] to the given [Date]
  void selectLeaveDate(DateTime? date) {
    if (date == null) return;
    _leaveDate = date;
    notifyListeners();
  }

  /// Tries to set the [selectedStartDate] to the given [Date]
  ///
  /// There is a validation to check if the [selectedEndDate] is already
  /// assigned, and if so, it checks if the given [Date] is after the
  /// [selectedEndDate]
  ///
  /// If the [Date] is after the [selectedEndDate], the [selectedStartDate] is
  /// set to null
  void selectStartDate(DateTime? date) {
    if (date == null) return;

    _startDate = date;

    if (_startDate != null && _endDate != null) {
      if (_startDate!.isAfter(_endDate!)) {
        _endDate = null;
      }
    }

    notifyListeners();
  }

  /// Tries to set the [selectedEndDate] to the given [Date]
  void selectEndDate(DateTime? date) {
    if (date == null) return;
    _endDate = date;
    notifyListeners();
  }

  /// Adds a participant to the [participants] list with the given inputs
  ///
  /// [profilePictureUrl]: An optional argument that represents the path of the
  /// profile picture of the participant
  void addParticipant([File? profilePicture]) {
    var intAge = int.tryParse(_participantAgeController.text);
    if (intAge == null) return;

    if (profilePicture == null) {
      profilePicture = File.;
    }

    var participant = Participant(
      name: _participantNameController.text,
      age: intAge,
      profilePicture: profilePicture,
    );

    _participantNameController.clear();
    _participantAgeController.clear();

    _participants.add(participant);
    notifyListeners();
  }

  Future<File> getDefaultProfilePictureFile() async {

  }

  void removeParticipant(int index) {
    _participants.removeAt(index);
    notifyListeners();
  }

  Future<void> select() async {
    final travels = await _travelUseCases.getAllTravels();
    debugPrint('Listing all travels:\n$travels');
  }

  /// Returns the [TextEditingController] for the travel title
  TextEditingController get travelTitleController => _travelTitleController;

  /// Returns the number of registered participants
  int get numParticipants => _participants.length;

  /// Returns the [selectedTransportType]
  TransportType get transportType => _transportType;

  /// Returns the list of [Participants]
  List<Participant> get participants => _participants;

  /// Returns the [selectedStartDate]
  DateTime? get startDate => _startDate;

  /// Returns the [selectedEndDate]
  DateTime? get endDate => _endDate;

  /// Returns the [TextEditingController] for the participant's name
  TextEditingController get participantNameController =>
      _participantNameController;

  /// Returns the [TextEditingController] for the participant's age
  TextEditingController get participantAgeController =>
      _participantAgeController;

  /// Returns whether the start date is selected or not
  bool get isStartDateSelected => startDate != null;

  /// Returns the error message stored in the provider
  String? get error => _errorMsg;

  /// Returns whether there is an [error message] or not
  bool get hasError => _errorMsg != null;

  /// Returns whether there is any asynchronous process running or not
  bool get isLoading => _isLoading;

  List<TravelStop> get stops => _stops;

  DateTime? get leaveDate => _leaveDate;

  DateTime? get arriveDate => _arriveDate;

  DateTime? get lastPossibleArriveDate {
    if (_startDate == null || _endDate == null) {
      _errorMsg =
          'You must select the Travel start and end dates before adding stops';
      notifyListeners();
      return null;
    }

    if (_stops.isEmpty) return _startDate;

    final latestStop = _stops.last;
    debugPrint('Latest stop: $latestStop');
    debugPrint('Last possible Arrive Date: ${latestStop.leaveDate}');
    return latestStop.leaveDate!;
  }

  DateTime? get lastPossibleLeaveDate {
    if (_startDate == null || _endDate == null) {
      _errorMsg =
          'You must select the Travel start and end dates before adding stops';
      notifyListeners();
      return null;
    }

    return _endDate;
  }

  Map<Experience, bool> get selectedExperiences => _selectedExperiences;

  set selectedExperiences(Map<Experience, bool> value) {
    _selectedExperiences = value;
  }

  bool get areStopsValid {
    // final hasStart = _stops.any((stop) => stop.type == TravelStopType.stop);
    // final hasEnd = _stops.any((stop) => stop.type == TravelStopType.end);

    return _stops.length >= 2;
  }
}
