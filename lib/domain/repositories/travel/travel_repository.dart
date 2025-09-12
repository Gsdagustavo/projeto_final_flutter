import 'dart:async';

import '../../../data/models/travel_model.dart';
import '../../entities/travel.dart';

/// Repository interface to manage [Travel] data in the application.
///
/// Defines methods to register, update, start, finish, delete, and search
/// travels.
abstract interface class TravelRepository {
  /// Registers a new travel in the repository.
  ///
  /// [travel]: The [Travel] object to be registered.
  Future<void> registerTravel({required Travel travel});

  /// Deletes a travel from the repository.
  ///
  /// [travel]: The [Travel] object to be deleted.
  Future<void> deleteTravel(Travel travel);

  /// Retrieves all travels stored in the repository.
  ///
  /// Returns a [List] of [Travel] objects.
  Future<List<Travel>> getAllTravels();

  /// Marks a travel as started.
  ///
  /// [travel]: The [Travel] object to be started.
  Future<void> startTravel(Travel travel);

  /// Marks a travel as finished.
  ///
  /// [travel]: The [Travel] object to be finished.
  Future<void> finishTravel(Travel travel);

  /// Updates the title of an existing travel.
  ///
  /// [travel]: The [Travel] object with the updated title.
  Future<void> updateTravelTitle(Travel travel, String newTitle);

  /// Searches for travels by their title.
  ///
  /// [title]: The title string to search for.
  /// Returns a [List] of [TravelModel] objects matching the title.
  Future<List<TravelModel>> findTravelsByTitle(String title);

  /// Searches for a travel by its ID
  ///
  /// [travelId]: The title string to search for.
  Future<Travel?> getTravelById({required String travelId});
}
