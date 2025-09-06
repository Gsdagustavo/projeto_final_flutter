import 'package:flutter/cupertino.dart';

import '../../domain/entities/travel.dart';
import '../../domain/usecases/travel/travel_usecases.dart';

/// Provider responsible for managing the list of [Travel]s and exposing
/// travel-related actions such as start, finish, delete, update, and search.
///
/// Uses [ChangeNotifier] to notify listeners when the travel list or
/// loading/error states change.
class TravelListProvider with ChangeNotifier {
  /// Internal storage of the current list of travels.
  final _travels = <Travel>[];

  /// Whether a background operation is in progress.
  bool _isLoading = false;

  /// Stores an error message if an operation fails.
  String? errorMessage;

  /// Collection of travel-related use cases.
  final TravelUseCases travelUseCases;

  /// Creates a [TravelListProvider] with the provided [travelUseCases].
  ///
  /// Automatically calls [update] to initialize the travel list.
  TravelListProvider(this.travelUseCases) {
    update();
  }

  /// Starts the given [travel].
  ///
  /// Sets [_isLoading] during the operation. On error, updates [errorMessage].
  Future<void> startTravel(Travel travel) async {
    _isLoading = true;
    notifyListeners();

    try {
      await travelUseCases.startTravel(travel);
    } on Exception catch (e) {
      errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return;
    }

    _isLoading = false;
    errorMessage = null;
    await update();
  }

  /// Marks the given [travel] as finished.
  ///
  /// Sets [_isLoading] during the operation. On error, updates [errorMessage].
  Future<void> finishTravel(Travel travel) async {
    _isLoading = true;
    notifyListeners();

    try {
      await travelUseCases.finishTravel(travel);
    } on Exception catch (e) {
      errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return;
    }
    _isLoading = false;
    errorMessage = null;
    await update();
  }

  /// Deletes the given [travel].
  ///
  /// Sets [_isLoading] during the operation. On error, updates [errorMessage].
  Future<void> deleteTravel(Travel travel) async {
    _isLoading = true;
    notifyListeners();

    try {
      await travelUseCases.deleteTravel(travel);
    } on Exception catch (e) {
      errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return;
    }

    _isLoading = false;
    errorMessage = null;
    await update();
  }

  /// Updates the title of the given [travel].
  Future<void> updateTravelTitle(Travel travel) async {
    await travelUseCases.updateTravelTitle(travel);
    await update();
  }

  /// Refreshes the travel list by fetching all travels.
  ///
  /// Sets [_isLoading] during the operation.
  Future<void> update() async {
    _isLoading = true;
    notifyListeners();

    _travels.clear();
    _travels.addAll(await travelUseCases.getAllTravels());

    _isLoading = false;
    notifyListeners();
  }

  /// Searches for travels by [title] and updates the internal list.
  ///
  /// If [title] is empty, resets the list by calling [update].
  Future<void> searchTravel(String title) async {
    if (title.isEmpty) {
      await update();
      return;
    }

    debugPrint('Search travel called in provider');
    final searchResult = await travelUseCases.findTravelsByTitle(title);
    debugPrint('Search result: $searchResult');

    _travels
      ..clear()
      ..addAll(searchResult);
    notifyListeners();
    debugPrint('Travels: $_travels');
  }

  /// Clears the current search and refreshes the full list of travels.
  Future<void> clearSearch() async {
    await update();
  }

  /// Returns the current list of travels.
  List<Travel> get travels => _travels;

  /// Whether a background operation is currently running.
  bool get isLoading => _isLoading;

  /// Whether the provider is currently holding an error state.
  bool get hasError => errorMessage != null;
}
