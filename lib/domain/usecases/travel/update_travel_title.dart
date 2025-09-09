import 'package:dartz/dartz.dart';

import '../../../core/exceptions/failure.dart';
import '../../entities/errors.dart';
import '../../entities/travel.dart';
import '../../repositories/travel/travel_repository.dart';

/// Use case for updating the title of a [Travel].
class UpdateTravelTitle {
  /// Repository to handle travel persistence.
  final TravelRepository _travelRepository;

  /// Creates an instance of [UpdateTravelTitle].
  UpdateTravelTitle(this._travelRepository);

  /// Updates the travel title after validating it.
  ///
  /// Throws an [Exception] if the title is invalid.
  Future<Either<Failure<TravelTitleError>, void>> call(
    Travel travel,
    String newTitle,
  ) async {
    if (!_validateTravelTitle(newTitle)) {
      return Left(Failure(TravelTitleError.invalidTravelTitle));
    }

    travel.travelTitle = newTitle;

    await _travelRepository.updateTravelTitle(travel, newTitle);
    return Right(null);
  }

  /// Validates the travel title.
  bool _validateTravelTitle(String title) {
    return title.trim().isNotEmpty;
  }
}
