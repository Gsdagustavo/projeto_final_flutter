import 'package:flutter/cupertino.dart';

import '../../domain/entities/participant.dart';
import '../../domain/entities/travel.dart';
import 'travel_repository.dart';

abstract class TravelUseCases {
  Future<void> registerTravel(Travel travel);

  Future<List<Travel>> getAllTravels();
}

class TravelUseCasesImpl implements TravelUseCases {
  final TravelRepository travelRepository;

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

    /// No participants
    if (travel.participants.isEmpty) {
      throw TravelRegisterException(
        'Travel must contain at least 1 participant',
      );
    }

    /// A(some) participant(s) has invalid data
    if (!_validateParticipants(travel.participants)) {
      throw TravelRegisterException('Invalid participant data');
    }

    /// No stops
    if (travel.stops.isEmpty) {
      throw TravelRegisterException('Travel must contain at least 1 stop');
    }

    /// Register travel
    await travelRepository.registerTravel(travel: travel);
  }

  @override
  Future<List<Travel>> getAllTravels() async {
    return await travelRepository.getAllTravels();
  }

  bool _validateParticipants(List<Participant> participants) {
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
}

class TravelRegisterException implements Exception {
  final String message;

  TravelRegisterException(this.message);
}
