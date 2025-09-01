import 'dart:core';

import 'package:flutter/cupertino.dart';

import '../../core/extensions/string_extensions.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/participant.dart';
import '../../domain/entities/travel.dart';
import 'travel_repository.dart';

/// Ine that defines all use cases related to the travels
abstract class TravelUseCases {
  /// Register a new travel
  ///
  /// [travel]: The travel which will be registered
  ///
  /// Throws a [TravelRegisterException] if any travel data is invalid
  Future<void> registerTravel(Travel travel);

  Future<void> deleteTravel(Travel travel);

  /// Returns a [List] of [Travel] containing all registered travels
  Future<List<Travel>> getAllTravels();

  Future<void> startTravel(Travel travel);

  Future<void> finishTravel(Travel travel);

  Future<void> updateTravelTitle(Travel travel);

  Future<List<Travel>> findTravelsByTitle(String title);
}

/// Concrete implementation of [TravelUseCases]
///
/// Contains a [TravelRepository] instance, which will be used to realize
/// queries with the database
class TravelUseCasesImpl implements TravelUseCases {
  /// Instance of [TravelRepository]
  ///
  /// Used to interact with the database
  final TravelRepository travelRepository;

  /// Default constructor
  TravelUseCasesImpl(this.travelRepository);

  @override
  Future<void> registerTravel(Travel travel) async {
    /// No title
    if (travel.travelTitle.trim().isEmpty) {
      throw TravelRegisterException('Invalid travel name');
    }

    /// No stops
    if (travel.stops.isEmpty || travel.stops.length < 2) {
      throw TravelRegisterException('Travel must contain at least 2 stops');
    }

    /// No participants
    if (travel.participants.isEmpty) {
      throw TravelRegisterException(
        'Travel must contain at least 1 participant',
      );
    }

    /// A(some) participant(s) has invalid data
    if (!isParticipantInfoValid(travel.participants)) {
      throw TravelRegisterException('Invalid participant data');
    }

    travel.stops.first.type = TravelStopType.start;
    travel.stops.last.type = TravelStopType.end;
    travel.stops.map((e) => e.type = TravelStopType.stop);

    final finalTravel = travel.copyWith(
      participants: _validateParticipants(travel.participants),
    );

    debugPrint('Travel that is going to be registered: $finalTravel');

    /// Register travel
    await travelRepository.registerTravel(travel: finalTravel);
  }

  @override
  Future<void> deleteTravel(Travel travel) async {
    await travelRepository.deleteTravel(travel);
  }

  @override
  Future<List<Travel>> getAllTravels() async {
    return await travelRepository.getAllTravels();
  }

  bool isParticipantInfoValid(List<Participant> participants) {
    return participants.every((p) {
      /// Invalid name
      if (p.name.isEmpty) {
        debugPrint('${p.name} is an invalid name');
        return false;
      }

      /// Short name
      if (p.name.length < 3) {
        debugPrint('${p.name} is an invalid name');
        return false;
      }

      /// Invalid age
      if (p.age < 0 || p.age >= 120) {
        debugPrint('${p.age} is an invalid age');
        return false;
      }

      return true;
    });
  }

  List<Participant> _validateParticipants(List<Participant> participants) {
    return participants.map((p) {
      return p.copyWith(name: p.name.capitalizedAndSpaced);
    }).toList();
  }

  @override
  Future<void> startTravel(Travel travel) async {
    print('Travel that is going to be started: ${travel.status}');

    final now = DateTime.now();

    if (travel.status == TravelStatus.ongoing) {
      throw Exception('Travel has already started');
    }

    if (travel.status == TravelStatus.finished) {
      throw Exception('Travel has already been finished');
    }

    travel.startDate = now;
    travel.status = TravelStatus.ongoing;

    await travelRepository.startTravel(travel);
  }

  @override
  Future<void> finishTravel(Travel travel) async {
    debugPrint('Travel that is going to be finished: $travel');

    final now = DateTime.now();

    if (travel.status == TravelStatus.upcoming) {
      /// TODO: intl
      throw Exception('Cannot finish a travel that has not started yet');
    }

    if (travel.status == TravelStatus.finished) {
      /// TODO: intl
      throw Exception('Travel has already finished');
    }

    travel.endDate = now;
    travel.status = TravelStatus.finished;

    await travelRepository.finishTravel(travel);
  }

  @override
  Future<void> updateTravelTitle(Travel travel) async {
    if (!_validateTravelTitle(travel.travelTitle)) {
      throw Exception('Invalid travel name');
    }

    await travelRepository.updateTravelTitle(travel);
  }

  @override
  Future<List<Travel>> findTravelsByTitle(String title) async {
    if (title.trim().isEmpty) {
      return [];
    }

    final travels = await travelRepository.findTravelsByTitle(title);
    return travels.map((e) => e.toEntity()).toList();
  }

  bool _validateTravelTitle(String title) {
    if (title.trim().isEmpty) {
      // throw TravelRegisterException('Invalid travel name');
      return false;
    }

    /// TODO: add more validations

    return true;
  }
}

/// A custom exception that will be thrown if any travel data is invalid
class TravelRegisterException implements Exception {
  /// The error message
  final String message;

  /// Default constructor
  TravelRegisterException(this.message);
}
