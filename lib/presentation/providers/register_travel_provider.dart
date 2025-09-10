import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../core/exceptions/failure.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/participant.dart';
import '../../domain/entities/travel.dart';
import '../../domain/entities/travel_stop.dart';
import '../../domain/usecases/travel/register_travel.dart';
import '../../domain/usecases/travel/travel_usecases.dart';
import '../../services/file_service.dart';

/// A [ChangeNotifier] that manages travel registration, participants, stops,
/// photos, and validation logic for creating new [Travel] instances.
class RegisterTravelProvider with ChangeNotifier {
  /// Instance of [TravelUseCases] for executing travel-related use cases.
  final TravelUseCases _travelUseCases;

  /// Handles file operations, such as saving travel photos.
  final fileService = FileService();

  /// Default constructor
  RegisterTravelProvider(this._travelUseCases);

  bool _areStopsValid = false;

  DateTime? _startDate;
  DateTime? _endDate;

  final _travelPhotos = <File>[];

  /// The selected transport type for the travel.
  var _transportType = TransportType.values.first;

  /// The participants assigned to this travel.
  final _participants = <Participant>[];

  /// The stops of the travel.
  final _stops = <TravelStop>[];

  Failure? _failure;

  /// Indicates whether any async operation is running.
  bool _isLoading = false;

  /// Attempts to register a new [Travel] with the given [travelTitle].
  ///
  /// The travel includes participants, stops, dates, transport type, and photos
  /// Handles success and failure using [handleTravelRegisterFailure].
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

    handleTravelRegisterFailure(res, onSuccess: resetForms);

    _isLoading = false;
    _notify();
  }

  /// Handles the result of a travel registration operation.
  ///
  /// Calls [onSuccess] if the operation was successful, [onFailure] otherwise.
  void handleTravelRegisterFailure(
    Either<Failure, void> res, {
    VoidCallback? onSuccess,
    VoidCallback? onFailure,
  }) {
    res.fold(
      (failure) {
        _failure = failure;
        if (onFailure != null) onFailure();
      },
      (r) {
        _failure = null;
        if (onSuccess != null) onSuccess();
      },
    );
  }

  /// Adds a new [TravelStop] to the travel.
  ///
  /// Automatically sets the type to `start` if it's the first stop, `stop`
  /// otherwise
  ///
  /// Returns `null` if the stop dates are invalid.
  TravelStop? addTravelStop(TravelStop stop) {
    if (_stops.isNotEmpty) {
      if ((stop.arriveDate!.isBefore(_stops.last.leaveDate!)) ||
          (stop.leaveDate!.isAfter(_endDate!))) {
        _failure = Failure(TravelRegisterError.invalidStopDates);
        _notify();
        return null;
      }
    }

    stop.type = _stops.isEmpty ? TravelStopType.start : TravelStopType.end;

    _stops.add(stop);
    _updateStopsTypes();
    debugPrint('Travel stop ${stop.toString()} added');
    _areStopsValid = _stops.length >= 2;
    _notify();
    return stop;
  }

  /// Removes the given [stop] from the travel.
  void removeTravelStop(TravelStop stop) {
    if (!_stops.contains(stop)) return;

    _stops.remove(stop);
    _updateStopsTypes();
    debugPrint('Stop $stop removed from travel stops list');
    _areStopsValid = _stops.length >= 2;
    _notify();
  }

  void _updateStopsTypes() {
    for (final (i, s) in _stops.indexed) {
      if (i == 0) {
        s.type = TravelStopType.start;
      } else if (i == _stops.length - 1) {
        s.type = TravelStopType.end;
      } else {
        s.type = TravelStopType.stop;
      }
    }
  }

  /// Updates an existing travel stop.
  ///
  /// Replaces [oldStop] with [newStop] in the list of stops.
  void updateTravelStop({
    required TravelStop oldStop,
    required TravelStop newStop,
  }) {
    final idx = _stops.indexOf(oldStop);
    if (idx == -1) return;

    _stops[idx] = newStop;
    _areStopsValid = _stops.length >= 2;
    _notify();
  }

  /// Resets all forms and clears participants, stops, photos, and other fields.
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

  /// Sets the selected transport type.
  void selectTransportType(TransportType? value) {
    if (_transportType == value) return;
    _transportType = value ?? TransportType.values.first;
    _notify();
  }

  /// Adds a [Participant] to the travel.
  void addParticipant(Participant participant) {
    _failure = Failure(TravelRegisterError.invalidStopDates);
    _participants.add(participant);
    debugPrint('Participant $participant added');
    _notify();
  }

  /// Removes a [Participant] from the travel.
  void removeParticipant(Participant participant) {
    _participants.remove(participant);
    _notify();
  }

  /// Updates an existing participant.
  void updateParticipant(
    Participant oldParticipant,
    Participant newParticipant,
  ) {
    final idx = _participants.indexOf(oldParticipant);
    if (idx == -1) return;

    _participants[idx] = newParticipant;
    _notify();
  }

  /// Adds a photo file to the travel.
  void addTravelPhoto(File file) {
    _travelPhotos.add(file);
    _notify();
  }

  /// Removes a photo file from the travel.
  void removeTravelPhoto(File file) {
    _travelPhotos.remove(file);
    _notify();
  }

  /// Returns the number of participants.
  int get numParticipants => _participants.length;

  /// Returns the selected transport type.
  TransportType get transportType => _transportType;

  /// Returns the list of participants.
  List<Participant> get participants => _participants;

  /// Returns the list of travel stops.
  List<TravelStop> get stops => _stops;

  /// Returns the list of travel photos.
  List<File> get travelPhotos => _travelPhotos;

  /// Returns whether the travel form is valid.
  bool get isTravelValid {
    return _areStopsValid &&
        _travelUseCases.registerTravel.isParticipantInfoValid(participants) &&
        _startDate != null &&
        _endDate != null;
  }

  /// Returns whether there are at least 2 valid stops.
  bool get areStopsValid => _areStopsValid;

  /// The start date of the travel.
  DateTime? get startDate => _startDate;

  set startDate(DateTime? value) {
    _startDate = value;
    _areStopsValid =
        _stops.length >= 2 && _startDate != null && _endDate != null;
    _notify();
  }

  /// The end date of the travel.
  DateTime? get endDate => _endDate;

  set endDate(DateTime? value) {
    _endDate = value;
    _areStopsValid =
        _stops.length >= 2 && _startDate != null && _endDate != null;
    _notify();
  }

  /// Returns the last possible arrive date for adding a new stop.
  DateTime? get lastPossibleArriveDate =>
      _stops.isEmpty ? _startDate : _stops.last.leaveDate;

  /// Returns the last possible leave date for adding a new stop.
  DateTime? get lastPossibleLeaveDate => _endDate;

  /// Returns whether any async process is currently running.
  bool get isLoading => _isLoading;

  /// Returns whether there is any failure.
  bool get hasFailure => _failure != null;

  /// Returns the current failure, if any.
  Failure? get failure => _failure;

  void _notify() => notifyListeners();
}
