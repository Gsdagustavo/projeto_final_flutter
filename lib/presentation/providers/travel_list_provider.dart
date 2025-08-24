import 'package:flutter/cupertino.dart';

import '../../domain/entities/travel.dart';
import '../../modules/travel/travel_use_cases.dart';
import '../pages/util/mock_travel_data.dart';

class TravelListProvider with ChangeNotifier {
  final List<Travel> _travels = mockTravels;

  bool _isLoading = false;

  final TravelUseCasesImpl _travelUseCases;

  TravelListProvider(this._travelUseCases) {
    // update();
  }

  Future<void> finishTravel(Travel travel) async {
    _isLoading = true;
    notifyListeners();

    await _travelUseCases.finishTravel(travel);
    // await update();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> update() async {
    _travels.clear();
    _travels.addAll(await _travelUseCases.getAllTravels());
    notifyListeners();
  }

  List<Travel> get travels => _travels;

  bool get isLoading => _isLoading;
}
