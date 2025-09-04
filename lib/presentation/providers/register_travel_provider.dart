import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/exceptions/travel_register_exception.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/participant.dart';
import '../../domain/entities/travel.dart';
import '../../domain/entities/travel_stop.dart';
import '../../modules/travel/travel_use_cases.dart';
import '../../services/file_service.dart';

/// A [ChangeNotifier] responsible for managing and the app's Travel Register
/// system
///
/// It uses [TravelUseCasesImpl] for handling use cases related to registering a
/// travel
class RegisterTravelProvider with ChangeNotifier {
  /// Instance of [TravelUseCasesImpl]
  final TravelUseCasesImpl _travelUseCases;

  /// Instance of [FileService]
  final fileService = FileService();

  /// TODO: make form keys private and add getters to access them
  ///
  /// Default constructor
  RegisterTravelProvider(this._travelUseCases);

  bool _areStopsValid = false;

  DateTime? _startDate;
  DateTime? _endDate;

  final _travelPhotos = <File>[];

  /// The selected travel [TransportType]
  var _transportType = TransportType.values.first;

  /// The list of [Participants] assigned to the travel
  final _participants = <Participant>[];

  /// The stops of the travel
  final _stops = <TravelStop>[];

  /// The error message (obtained via exception.message on try-catch structures)
  String? _errorMsg;

  /// Whether there are any asynchronous methods being processed or not
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
  Future<void> registerTravel(String travelTitle) async {
    _isLoading = true;
    notifyListeners();

    debugPrint('Registering travel with title $travelTitle');

    if (!isTravelValid) {
      debugPrint('Travel is not valid');
      _errorMsg = 'Invalid Travel Info. Verify the data and try again';
      _isLoading = false;
      notifyListeners();
      return;
    }

    if (!_areStopsValid) {
      debugPrint('Stops are not valid');
      _errorMsg = 'At least 2 stops must be registered';
      _isLoading = false;
      notifyListeners();
      return;
    }

    final lastStop = stops.last;
    _stops[stops.length - 1] = lastStop.copyWith(type: TravelStopType.end);

    /// Instantiates a new travel with the given inputs
    final travel = Travel(
      travelTitle: travelTitle,
      participants: participants,
      startDate: _startDate!,
      endDate: _endDate!,
      transportType: _transportType,
      stops: _stops,
      photos: _travelPhotos,
    );

    debugPrint('Travel that will be inserted: $travel');

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
    _areStopsValid = false;

    resetForms();
  }

  TravelStop? addTravelStop(TravelStop stop) {
    debugPrint('dkapodwokad ${_stops.length}');

    if (_stops.isNotEmpty) {
      if ((stop.arriveDate!.isBefore(_stops.last.leaveDate!)) ||
          (stop.leaveDate!.isAfter(_endDate!))) {
        _errorMsg = 'Invalid travel stop dates';
        notifyListeners();
        return null;
      }
    }

    _stops.add(stop);

    _errorMsg = null;

    debugPrint('Travel stop ${stop.toString()} added');

    _areStopsValid = _stops.length >= 2;
    notifyListeners();
    return stop;
  }

  void removeTravelStop(TravelStop stop) {
    _stops.remove(stop);
    debugPrint('Stop $stop removed from travel stops list');
    _areStopsValid = _stops.length >= 2;
    notifyListeners();
  }

  void updateTravelStop({
    required TravelStop oldStop,
    required TravelStop newStop,
  }) {
    debugPrint('Old travel stop: $oldStop');
    debugPrint('New travel stop: $newStop');

    debugPrint('Travel stops len: ${_stops.length}');

    debugPrint('Old stops: $_stops');

    final idx = _stops.indexOf(oldStop);

    if (idx == -1) {
      debugPrint('Error: old stop not found in list');
      return;
    }

    _stops[idx] = newStop;

    debugPrint('New stops: $_stops');

    _areStopsValid = _stops.length >= 2;
    notifyListeners();
  }

  /// Sets all input fields to their default values and cleanses all lists
  void resetForms() {
    _transportType = TransportType.values.first;

    _startDate = null;
    _endDate = null;

    _participants.clear();

    _errorMsg = null;
    _isLoading = false;

    _stops.clear();

    _travelPhotos.clear();

    notifyListeners();
  }

  /// Sets the given [value] to [selectedTransportType]
  void selectTransportType(TransportType? value) {
    if (_transportType == value) return;
    _transportType = value ?? TransportType.values.first;
    notifyListeners();
  }

  /// Adds a participant to the [participants] list with the given inputs
  ///
  /// [profilePictureUrl]: An optional argument that represents the path of the
  /// profile picture of the participant
  void addParticipant(Participant participant) {
    _participants.add(participant);

    debugPrint('Participant $participant added');
    _errorMsg = null;
    notifyListeners();
  }

  void removeParticipant(Participant participant) {
    _participants.remove(participant);
    notifyListeners();
  }

  void updateParticipant(
    Participant oldParticipant,
    Participant newParticipant,
  ) {
    debugPrint('Participants len: ${_participants.length}');

    debugPrint('Old participants: $_participants');

    final idx = _participants.indexOf(oldParticipant);

    _participants.removeAt(idx);
    _participants.insert(idx, newParticipant);

    debugPrint('New participants: $_participants');

    notifyListeners();
  }

  void addTravelPhoto(File file) {
    _travelPhotos.add(file);
    notifyListeners();
  }

  void removeTravelPhoto(File file) {
    if (!_travelPhotos.contains(file)) return;
    _travelPhotos.removeWhere((element) => element == file);
    notifyListeners();
  }

  Future<void> select() async {
    final travels = await _travelUseCases.getAllTravels();
    debugPrint('Listing all travels:\n$travels');
  }

  /// Returns the number of registered participants
  int get numParticipants => _participants.length;

  /// Returns the [selectedTransportType]
  TransportType get transportType => _transportType;

  /// Returns the list of [Participants]
  List<Participant> get participants => _participants;

  /// Returns the error message stored in the provider
  String? get error => _errorMsg;

  /// Returns whether there is an [error message] or not
  bool get hasError => _errorMsg != null;

  /// Returns whether there is any asynchronous process running or not
  bool get isLoading => _isLoading;

  List<TravelStop> get stops => _stops;

  bool get isTravelValid {
    final isValid =
        _areStopsValid &&
        _travelUseCases.isParticipantInfoValid(participants) &&
        _startDate != null &&
        _endDate != null;

    return isValid;
  }

  DateTime? get lastPossibleArriveDate {
    if (_startDate == null || _endDate == null) {
      _errorMsg =
          'You must select the Travel start and end dates before adding stops';
      notifyListeners();
      return null;
    }

    if (_stops.isEmpty) return _startDate;

    final latestStop = _stops.last;
    print('Latest stop: $latestStop');
    debugPrint('Latest possible Arrive Date: ${latestStop.leaveDate}');
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

  bool get areStopsValid => _areStopsValid;

  DateTime? get endDate => _endDate;

  set endDate(DateTime? value) {
    _endDate = value;
  }

  DateTime? get startDate => _startDate;

  set startDate(DateTime? value) {
    _startDate = value;
  }

  List<File> get travelPhotos => _travelPhotos;
}
