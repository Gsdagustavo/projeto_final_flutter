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
  final _travelTitleController = TextEditingController(text: 'Test Name');

  /// The selected travel [TransportType]
  var _selectedTransportType = TransportType.values.first;

  /// The list of [Participants] assigned to the travel
  ///
  final _participants = <Participant>[Participant(name: 'Test', age: 1)];

  /// The start date of the [Travel]
  DateTime? _selectedStartDate = DateTime.now();

  /// The end date of the [Travel]
  DateTime? _selectedEndDate = DateTime.now();

  /// A [TextEditingController] to be assigned to a participant name
  final _participantNameController = TextEditingController(text: 'Test Name');

  /// A [TextEditingController] to be assigned to a participant age
  final _participantAgeController = TextEditingController(text: '15');

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

    /// Instantiates a new travel with the given inputs
    final travel = Travel(
      travelTitle: _travelTitleController.text,
      participants: participants,
      startDate: _selectedStartDate,
      endDate: _selectedEndDate,
      transportType: _selectedTransportType,
      stops: [
        TravelStop(
          cityName: 'Goiaba',
          type: TravelStopType.start,
          latitude: 10,
          longitude: 10,
          arriveDate: DateTime.now(),
          leaveDate: DateTime.now().add(Duration(days: 1)),
          experiences: [Experience.visitHistoricalPlaces],
        ),

        TravelStop(
          cityName: 'Aracaju',
          type: TravelStopType.stop,
          latitude: 15,
          longitude: 15,
          arriveDate: DateTime.now().add(Duration(days: 1)),
          leaveDate: DateTime.now().add(Duration(days: 2)),
          experiences: [
            Experience.visitHistoricalPlaces,
            Experience.visitLocalEstablishments,
          ],
        ),

        TravelStop(
          cityName: 'Sapucaiba',
          type: TravelStopType.end,
          latitude: 20,
          longitude: 20,

          /// same as the first lol
          experiences: [],
        ),
      ],
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

  /// Sets all input fields to their default values and cleanses all lists
  void _resetForms() {
    _selectedTransportType = TransportType.values.first;

    _selectedStartDate = null;
    _selectedEndDate = null;

    _travelTitleController.clear();
    _participantNameController.clear();
    _participantAgeController.clear();

    _participants.clear();

    _errorMsg = null;
    _isLoading = false;

    notifyListeners();
  }

  /// This is a debug method used to get all travels registered in the database
  ///
  /// This is intended to be removed in the future
  Future<void> select() async {
    await _travelUseCases.getAllTravels();
  }

  /// Sets the given [value] to [selectedTransportType]
  void selectTransportType(TransportType? value) {
    if (_selectedTransportType == value) return;
    _selectedTransportType = value ?? TransportType.values.first;
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

    _selectedStartDate = date;

    if (_selectedStartDate != null && _selectedEndDate != null) {
      if (_selectedStartDate!.isAfter(_selectedEndDate!)) {
        _selectedEndDate = null;
      }
    }

    notifyListeners();
  }

  /// Tries to set the [selectedEndDate] to the given [Date]
  void selectEndDate(DateTime? date) {
    if (date == null) return;

    _selectedEndDate = date;
    notifyListeners();
  }

  /// Adds a participant to the [participants] list with the given inputs
  ///
  /// [profilePictureUrl]: An optional argument that represents the path of the
  /// profile picture of the participant
  void addParticipant([String? profilePictureUrl]) {
    var intAge = int.tryParse(_participantAgeController.text);
    if (intAge == null) return;

    var participant = Participant(
      name: _participantNameController.text,
      age: intAge,
      profilePicturePath: profilePictureUrl,
    );

    _participantNameController.clear();
    _participantAgeController.clear();

    _participants.add(participant);
    notifyListeners();
  }

  void removeParticipant(int index) {
    _participants.removeAt(index);
    notifyListeners();
  }

  /// Returns the [TextEditingController] for the travel title
  TextEditingController get travelTitleController => _travelTitleController;

  /// Returns the number of registered participants
  int get numParticipants => _participants.length;

  /// Returns the [selectedTransportType]
  TransportType get selectedTransportType => _selectedTransportType;

  /// Returns the list of [Participants]
  List<Participant> get participants => _participants;

  /// Returns the [selectedStartDate]
  DateTime? get selectedStartDate => _selectedStartDate;

  /// Returns the [selectedEndDate]
  DateTime? get selectedEndDate => _selectedEndDate;

  /// Returns the [TextEditingController] for the participant's name
  TextEditingController get participantNameController =>
      _participantNameController;

  /// Returns the [TextEditingController] for the participant's age
  TextEditingController get participantAgeController =>
      _participantAgeController;

  /// Returns whether the start date is selected or not
  bool get isStartDateSelected => selectedStartDate != null;

  /// Returns the error message stored in the provider
  String? get error => _errorMsg;

  /// Returns whether there is an [error message] or not
  bool get hasError => _errorMsg != null;

  /// Returns whether there is any asynchronous process running or not
  bool get isLoading => _isLoading;
}
