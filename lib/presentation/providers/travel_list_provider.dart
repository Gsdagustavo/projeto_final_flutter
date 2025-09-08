import 'package:flutter/cupertino.dart';

import '../../domain/entities/travel.dart';
import '../../domain/usecases/travel/travel_usecases.dart';

/// Provider responsible for managing a list of [Travel]s and exposing
/// travel-related actions such as start, finish, delete, update, and search.
///
/// Uses [ChangeNotifier] to notify listeners when the travel list or
/// loading/error states change.
class TravelListProvider with ChangeNotifier {
  /// Internal storage of the current list of travels.
  final _travels = <Travel>[];

  /// Whether a background operation is currently in progress.
  bool _isLoading = false;

  /// Stores an error message if any operation fails.
  String? errorMessage;

  /// Collection of travel-related use cases used to perform CRUD operations.
  final TravelUseCases travelUseCases;

  /// Creates a [TravelListProvider] with the provided [travelUseCases].
  ///
  /// Automatically calls [update] to initialize the travel list.
  TravelListProvider(this.travelUseCases) {
    update();
  }

  /// Starts the given [travel].
  ///
  /// Notifies listeners after updating. In case of an exception,
  /// sets [errorMessage].
  Future<void> startTravel(Travel travel) async {
    try {
      await travelUseCases.startTravel(travel);
    } on Exception catch (e) {
      errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return;
    }
    errorMessage = null;
    notifyListeners();
  }

  /// Marks the given [travel] as finished.
  ///
  /// Notifies listeners after updating. In case of an exception, sets
  /// [errorMessage].
  Future<void> finishTravel(Travel travel) async {
    try {
      await travelUseCases.finishTravel(travel);
    } on Exception catch (e) {
      errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return;
    }
    errorMessage = null;
    notifyListeners();
  }

  /// Deletes the given [travel] from the list.
  ///
  /// Notifies listeners after updating. In case of an exception,
  /// sets [errorMessage].
  Future<void> deleteTravel(Travel travel) async {
    try {
      await travelUseCases.deleteTravel(travel);
    } on Exception catch (e) {
      errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return;
    }

    _travels.remove(travel);
    errorMessage = null;
    notifyListeners();
  }

  /// Updates the title of the given [travel].
  ///
  /// Refreshes the full travel list after the update.
  Future<void> updateTravelTitle(Travel travel, String newTitle) async {
    await travelUseCases.updateTravelTitle(travel, newTitle);
    notifyListeners();
  }

  /// Refreshes the travel list by fetching all travels from the use case.
  ///
  /// Sets [_isLoading] during the operation and notifies listeners before
  /// and after the update.
  Future<void> update() async {
    _isLoading = true;
    notifyListeners();

    await _refreshTravels();

    _isLoading = false;
    notifyListeners();
  }

  /// Searches for travels by [title] and updates the internal list.
  ///
  /// If [title] is empty, resets the list by fetching all travels.
  /// Notifies listeners after updating.
  Future<void> searchTravel(String title) async {
    if (title.isEmpty) {
      await _refreshTravels();
      notifyListeners();
      return;
    }

    final searchResult = await travelUseCases.findTravelsByTitle(title);

    _travels
      ..clear()
      ..addAll(searchResult);
    notifyListeners();
    debugPrint('Travels: $_travels');
  }

  /// Clears the current search and refreshes the full list of travels.
  ///
  /// Notifies listeners after updating.
  Future<void> clearSearch() async {
    await _refreshTravels();
    notifyListeners();
  }

  /// Internal helper to refresh [_travels] from the use case.
  ///
  /// Does not notify listeners; used by other methods that handle notifications
  Future<void> _refreshTravels() async {
    _travels.clear();
    _travels.addAll(await travelUseCases.getAllTravels());
  }

  /// Returns the current list of travels.
  List<Travel> get travels => _travels;

  /// Whether a background operation is currently running.
  bool get isLoading => _isLoading;

  /// Whether the provider is currently holding an error state.
  bool get hasError => errorMessage != null;
}
