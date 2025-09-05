import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/enums.dart';
import '../../domain/entities/participant.dart';
import '../../domain/entities/travel.dart';
import '../../domain/entities/travel_stop.dart';
import '../../domain/usecases/travel/register_travel.dart';
import '../../domain/usecases/travel/travel_usecases.dart';
import '../../services/file_service.dart';

/// A [ChangeNotifier] responsible for managing and the app's Travel Register
/// system
///
/// It uses [TravelUseCases] for handling use cases related to registering a
/// travel
class RegisterTravelProvider with ChangeNotifier {
  /// Instance of [TravelUseCases]
  final TravelUseCases _travelUseCases;

  /// Instance of [FileService]
  final fileService = FileService();

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

  Failure<TravelRegisterError>? _failure;

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

    final res = await _travelUseCases.registerTravel(travel);

    handleFailure(res, onSuccess: resetForms);

    _isLoading = false;
    _notify();
  }

  void handleFailure(
    Either<Failure<TravelRegisterError>, void> res, {
    VoidCallback? onSuccess,
    VoidCallback? onFailure,
  }) {
    res.fold(
      (failure) {
        _failure = failure;
        if (onFailure != null) {
          onFailure.call();
        }
      },
      (r) {
        _failure = null;
        if (onSuccess != null) {
          onSuccess.call();
        }
      },
    );
  }

  TravelStop? addTravelStop(TravelStop stop) {
    if (_stops.isNotEmpty) {
      if ((stop.arriveDate!.isBefore(_stops.last.leaveDate!)) ||
          (stop.leaveDate!.isAfter(_endDate!))) {
        _failure = Failure(TravelRegisterError.invalidStopDates);
        _notify();
        return null;
      }
    }

    if (_stops.isEmpty) {
      stop.type = TravelStopType.start;
    } else {
      stop.type = TravelStopType.stop;
    }

    _stops.add(stop);

    debugPrint('Travel stop ${stop.toString()} added');

    _areStopsValid = _stops.length >= 2;
    _notify();
    return stop;
  }

  void removeTravelStop(TravelStop stop) {
    if (!_stops.contains(stop)) return;

    _stops.remove(stop);
    debugPrint('Stop $stop removed from travel stops list');
    _areStopsValid = _stops.length >= 2;
    _notify();
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
    _notify();
  }

  /// Sets all input fields to their default values and cleanses all lists
  void resetForms() {
    _transportType = TransportType.values.first;

    _startDate = null;
    _endDate = null;

    _participants.clear();

    _isLoading = false;
    _areStopsValid = false;

    _stops.clear();

    _travelPhotos.clear();

    _notify();
  }

  /// Sets the given [value] to [selectedTransportType]
  void selectTransportType(TransportType? value) {
    if (_transportType == value) return;
    _transportType = value ?? TransportType.values.first;
    _notify();
  }

  /// Adds a participant to the [participants] list with the given inputs
  ///
  /// [profilePictureUrl]: An optional argument that represents the path of the
  /// profile picture of the participant
  void addParticipant(Participant participant) {
    _participants.add(participant);

    debugPrint('Participant $participant added');
    _notify();
  }

  void removeParticipant(Participant participant) {
    _participants.remove(participant);
    _notify();
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

    _notify();
  }

  void addTravelPhoto(File file) {
    _travelPhotos.add(file);
    _notify();
  }

  void removeTravelPhoto(File file) {
    if (!_travelPhotos.contains(file)) return;
    _travelPhotos.removeWhere((element) => element == file);
    _notify();
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

  /// Returns whether there is any asynchronous process running or not
  bool get isLoading => _isLoading;

  List<TravelStop> get stops => _stops;

  bool get isTravelValid {
    return _areStopsValid &&
        _travelUseCases.registerTravel.isParticipantInfoValid(participants) &&
        _startDate != null &&
        _endDate != null;
  }

  DateTime? get lastPossibleArriveDate {
    if (_stops.isEmpty) return _startDate;

    final latestStop = _stops.last;
    return latestStop.leaveDate!;
  }

  DateTime? get lastPossibleLeaveDate {
    return _endDate;
  }

  bool get areStopsValid => _areStopsValid;

  DateTime? get endDate => _endDate;

  set endDate(DateTime? value) {
    _endDate = value;
    _areStopsValid =
        _stops.length >= 2 && _startDate != null && _endDate != null;
    _notify();
  }

  DateTime? get startDate => _startDate;

  set startDate(DateTime? value) {
    _startDate = value;
    _areStopsValid =
        _stops.length >= 2 && _startDate != null && _endDate != null;
    _notify();
  }

  List<File> get travelPhotos => _travelPhotos;

  bool get hasFailure => _failure != null;

  Failure<TravelRegisterError>? get failure => _failure;

  void _notify() => notifyListeners();
}
