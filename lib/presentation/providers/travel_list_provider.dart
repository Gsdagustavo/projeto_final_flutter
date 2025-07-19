import 'package:flutter/cupertino.dart';

import '../../domain/entities/travel.dart';
import '../../modules/travel/travel_use_cases.dart';

class TravelListProvider with ChangeNotifier {
  final List<Travel> _travels = [];

  bool _isLoading = false;

  final TravelUseCasesImpl _travelUseCases;

  TravelListProvider(this._travelUseCases) {
    update();
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
}
