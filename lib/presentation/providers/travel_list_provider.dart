import 'package:flutter/cupertino.dart';

import '../../domain/entities/travel.dart';
import '../../modules/travel/travel_use_cases.dart';

class TravelListProvider with ChangeNotifier {
  final _travels = <Travel>[];

  bool _isLoading = false;

  String? errorMessage;

  final TravelUseCasesImpl _travelUseCases;

  TravelListProvider(this._travelUseCases) {
    update();
  }

  Future<void> startTravel(Travel travel) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _travelUseCases.startTravel(travel);
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

  Future<void> finishTravel(Travel travel) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _travelUseCases.finishTravel(travel);
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

  Future<void> deleteTravel(Travel travel) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _travelUseCases.deleteTravel(travel);
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

  Future<void> updateTravelTitle(Travel travel) async {
    await _travelUseCases.updateTravelTitle(travel);
    await update();
  }

  Future<void> update() async {
    // _isLoading = true;
    // notifyListeners();

    _travels.clear();
    _travels.addAll(await _travelUseCases.getAllTravels());

    // _isLoading = false;
    notifyListeners();
  }

  Future<void> searchTravel(String title) async {
    if (title.isEmpty) {
      await update();
      return;
    }

    debugPrint('Search travel called in provider');
    final searchResult = await _travelUseCases.findTravelsByTitle(title);
    debugPrint('Search result: $searchResult');

    _travels
      ..clear()
      ..addAll(searchResult);
    notifyListeners();
    debugPrint('Travels: $_travels');
  }

  Future<void> clearSearch() async {
    await update();
  }

  List<Travel> get travels => _travels;

  bool get isLoading => _isLoading;

  bool get hasError => errorMessage != null;
}
