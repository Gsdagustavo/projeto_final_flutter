import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/extensions/experience_map_extension.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/participant.dart';
import '../../domain/entities/place.dart';
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

  /// Form key for validation
  final formKey = GlobalKey<FormState>();

  /// Default constructor
  RegisterTravelProvider(this._travelUseCases) {
    _init();
  }

  _init() async {
    _isLoading = true;
    notifyListeners();

    _profilePictureFile = await fileService.getDefaultProfilePictureFile();

    _isLoading = false;
    notifyListeners();
  }

  /// A [TextEditingController] to be assigned to the travel title
  final _travelTitleController = TextEditingController();

  /// The selected travel [TransportType]
  var _transportType = TransportType.values.first;

  /// The list of [Participants] assigned to the travel
  final _participants = <Participant>[];

  /// The stops of the travel
  final _stops = <TravelStop>[];

  /// The time range of the travel
  DateTimeRange? _travelTimeRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now().add(Duration(days: 30)),
  );

  /// The time range of the current travel stop
  DateTimeRange? _stopTimeRange;

  /// The selected experiences for the current travel stop
  Map<Experience, bool> _selectedExperiences = {
    for (var e in Experience.values) e: false,
  };

  /// A [TextEditingController] to be assigned to a participant name
  final _participantNameController = TextEditingController();

  /// A [TextEditingController] to be assigned to a participant age
  final _participantAgeController = TextEditingController();

  File? _profilePictureFile;

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

    if (!isTravelValid) {
      _errorMsg = 'Invalid Travel Info. Verify the data and try again';
      notifyListeners();
      return;
    }

    if (_stops.length < 2) {
      _errorMsg = 'At least 2 stops must be registered';
      _isLoading = false;
      notifyListeners();
      return;
    }

    final lastStop = stops.last;
    _stops[stops.length - 1] = lastStop.copyWith(type: TravelStopType.end);

    /// Instantiates a new travel with the given inputs
    final travel = Travel(
      travelTitle: _travelTitleController.text,
      participants: participants,
      startDate: _travelTimeRange?.start,
      endDate: _travelTimeRange?.end,
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

    resetForms();
  }

  Future<void> finishTravel(Travel travel) async {
    await _travelUseCases.finishTravel(travel);
  }

  TravelStop addTravelStop(Place place) {
    final type = _stops.isEmpty ? TravelStopType.start : TravelStopType.stop;
    final arriveDate = _stopTimeRange!.start;
    final leaveDate = _stopTimeRange!.end;

    final stop = TravelStop(
      place: place,
      experiences: _selectedExperiences.toExperiencesList(),
      arriveDate: arriveDate,
      leaveDate: leaveDate,
      type: type,
    );

    _stops.add(stop);

    _errorMsg = null;
    _stopTimeRange = null;

    debugPrint('Travel stop ${stop.toString()} added');
    notifyListeners();

    print('STOP TIME RANGE AFTER ADDING: $_stopTimeRange');

    return stop;
  }

  void removeTravelStop(TravelStop stop) {
    _stops.remove(stop);
    resetExperiences();
    debugPrint('Stop $stop removed from travel stops list');
    notifyListeners();
  }

  TravelStop updateTravelStop({required TravelStop stop}) {
    final newStop = stop.copyWith(
      experiences: _selectedExperiences.toExperiencesList(),
      arriveDate: _stopTimeRange!.start,
      leaveDate: _stopTimeRange!.end,
    );

    _stops[_stops.indexOf(stop)] = newStop;

    notifyListeners();
    return newStop;
  }

  /// Sets all input fields to their default values and cleanses all lists
  void resetForms() {
    _transportType = TransportType.values.first;

    _travelTimeRange = null;
    _stopTimeRange = null;

    _travelTitleController.clear();
    _participantNameController.clear();
    _participantAgeController.clear();

    _participants.clear();
    _profilePictureFile = null;

    _errorMsg = null;
    _isLoading = false;

    _stops.clear();

    resetExperiences();

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
  Future<void> addParticipant() async {
    final intAge = int.tryParse(_participantAgeController.text);
    if (intAge == null) return;

    _profilePictureFile ??= await fileService.getDefaultProfilePictureFile();

    final participant = Participant(
      name: _participantNameController.text,
      age: intAge,
      profilePicture: _profilePictureFile!,
    );

    _participantNameController.clear();
    _participantAgeController.clear();
    _profilePictureFile = null;

    _participants.add(participant);

    debugPrint('Participant $participant added');
    notifyListeners();
  }

  void removeParticipant(int index) {
    _participants.removeAt(index);
    notifyListeners();
  }

  Future<void> pickImage() async {
    _profilePictureFile = await fileService.pickImage();
    notifyListeners();
  }

  Future<void> select() async {
    final travels = await _travelUseCases.getAllTravels();
    debugPrint('Listing all travels:\n$travels');
  }

  /// If a [TravelStop] was given, populates [_selectedExperiences] with the
  /// [values] being whether or not the experience is in the [experiences] list
  ///
  /// Otherwise, set all [values] to [false] (no experience selected)
  void resetExperiences([TravelStop? stop]) {
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
  }

  /// Returns the [TextEditingController] for the travel title
  TextEditingController get travelTitleController => _travelTitleController;

  /// Returns the number of registered participants
  int get numParticipants => _participants.length;

  /// Returns the [selectedTransportType]
  TransportType get transportType => _transportType;

  /// Returns the list of [Participants]
  List<Participant> get participants => _participants;

  /// Returns the [TextEditingController] for the participant's name
  TextEditingController get participantNameController =>
      _participantNameController;

  /// Returns the [TextEditingController] for the participant's age
  TextEditingController get participantAgeController =>
      _participantAgeController;

  /// Returns the error message stored in the provider
  String? get error => _errorMsg;

  /// Returns whether there is an [error message] or not
  bool get hasError => _errorMsg != null;

  /// Returns whether there is any asynchronous process running or not
  bool get isLoading => _isLoading;

  List<TravelStop> get stops => _stops;

  Map<Experience, bool> get selectedExperiences => _selectedExperiences;

  set selectedExperiences(Map<Experience, bool> value) {
    _selectedExperiences = value;
  }

  bool get areStopsValid {
    return _stops.length >= 2;
  }

  File? get profilePictureFile => _profilePictureFile;

  bool get isTravelValid {
    final isValid =
        areStopsValid && _travelUseCases.isParticipantInfoValid(participants);

    // debugPrint('Is travel valid: $isValid');

    return isValid;
  }

  DateTime? get lastPossibleArriveDate {
    if (_travelTimeRange == null) {
      _errorMsg =
          'You must select the Travel start and end dates before adding stops';
      notifyListeners();
      return null;
    }

    if (_stops.isEmpty) return _travelTimeRange!.start;

    final latestStop = _stops.last;
    print('Latest stop: $latestStop');
    debugPrint('Latest possible Arrive Date: ${latestStop.leaveDate}');
    return latestStop.leaveDate!;
  }

  DateTime? get lastPossibleLeaveDate {
    if (_travelTimeRange == null) {
      _errorMsg =
          'You must select the Travel start and end dates before adding stops';
      notifyListeners();
      return null;
    }

    return _travelTimeRange!.end;
  }

  DateTimeRange? get travelTimeRange => _travelTimeRange;

  set travelTimeRange(DateTimeRange? range) {
    _travelTimeRange = range;

    if (_stops.isNotEmpty) {
      /// Stop dates are out of bounds
      _stops.removeWhere((stop) {
        return stop.arriveDate!.isBefore(range!.start) ||
            stop.arriveDate!.isAfter(range.end);
      });
    }

    notifyListeners();
  }

  DateTimeRange? get stopTimeRange => _stopTimeRange;

  set stopTimeRange(DateTimeRange? value) {
    print('Set stop time range called. New value: $value');
    _stopTimeRange = value;
    notifyListeners();
  }
}
