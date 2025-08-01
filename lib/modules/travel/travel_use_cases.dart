import 'dart:core';

import 'package:flutter/cupertino.dart';

import '../../core/extensions/string_extensions.dart';
import '../../domain/entities/participant.dart';
import '../../domain/entities/travel.dart';
import 'travel_repository.dart';

/// Interface that defines all use cases related to the travels
abstract class TravelUseCases {
  /// Register a new travel
  ///
  /// [travel]: The travel which will be registered
  ///
  /// Throws a [TravelRegisterException] if any travel data is invalid
  Future<void> registerTravel(Travel travel);

  /// Returns a [List] of [Travel] containing all registered travels
  Future<List<Travel>> getAllTravels();
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

    /// Invalid start date
    if (travel.startDate == null) {
      throw TravelRegisterException('Invalid travel start date');
    }

    /// Invalid end date
    if (travel.endDate == null) {
      throw TravelRegisterException('Invalid travel end date');
    }

    /// No stops
    if (travel.stops.isEmpty) {
      throw TravelRegisterException('Travel must contain at least 2 stops');
    }

    /// No participants
    if (travel.participants.isEmpty) {
      throw TravelRegisterException(
        'Travel must contain at least 1 participant',
      );
    }

    /// A(some) participant(s) has invalid data
    if (!_isParticipantInfoValid(travel.participants)) {
      throw TravelRegisterException('Invalid participant data');
    }

    final finalTravel = travel.copyWith(
      participants: _validateParticipants(travel.participants),
    );

    /// Register travel
    await travelRepository.registerTravel(travel: finalTravel);
  }

  @override
  Future<List<Travel>> getAllTravels() async {
    return await travelRepository.getAllTravels();
  }

  bool _isParticipantInfoValid(List<Participant> participants) {
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
}

/// A custom exception that will be thrown if any travel data is invalid
class TravelRegisterException implements Exception {
  /// The error message
  final String message;

  /// Default constructor
  TravelRegisterException(this.message);
}
