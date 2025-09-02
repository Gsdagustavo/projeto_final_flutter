import 'package:flutter/cupertino.dart';

import '../../domain/entities/review.dart';
import '../../domain/entities/travel.dart';
import '../../modules/review/review_use_cases.dart';

class ReviewProvider with ChangeNotifier {
  final ReviewUseCases _reviewUseCases;

  ReviewProvider(this._reviewUseCases);

  final _reviews = <Review>[];
  String? _errorMessage;

  Future<void> addReview(Review review) async {
    debugPrint('add review provider');
    await _reviewUseCases.addReview(review: review);
    _reviews.add(review);
    notifyListeners();
  }

  Future<void> update() async {
    _reviews.clear();
    _reviews.addAll(await _reviewUseCases.getReviews());
    notifyListeners();

    debugPrint('Reviews: $_reviews');
  }

  Future<void> getReviewsByTravel(Travel travel) async {
    _reviews.clear();
    _reviews.addAll(await _reviewUseCases.getReviewsByTravel(travel));
    notifyListeners();
  }

  bool get hasError => _errorMessage != null;

  String? get errorMessage => _errorMessage!;

  List<Review> get reviews => _reviews;

  double get rate {
    return reviews.fold(0, (previousValue, element) {
          return element.stars + previousValue;
        }) /
        reviews.length;
  }
}
