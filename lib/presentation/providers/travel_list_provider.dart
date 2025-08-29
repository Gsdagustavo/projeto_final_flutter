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

  Future<void> finishTravel(Travel travel) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _travelUseCases.finishTravel(travel);
    } on Exception catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
    await update();

    _isLoading = false;
    errorMessage = null;
    notifyListeners();
  }

  Future<void> update() async {
    _isLoading = true;
    notifyListeners();

    _travels.clear();
    _travels.addAll(await _travelUseCases.getAllTravels());

    _isLoading = false;
    notifyListeners();
  }

  List<Travel> get travels => _travels;

  bool get isLoading => _isLoading;

  bool get hasError => errorMessage != null;
}
