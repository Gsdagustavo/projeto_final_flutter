import 'package:flutter/cupertino.dart';

import '../../domain/entities/review.dart';
import '../../domain/entities/travel.dart';
import '../../domain/usecases/review/review_use_cases.dart';

/// A [ChangeNotifier] provider responsible for managing reviews, including
/// adding, updating, and retrieving reviews for travels.
class ReviewProvider with ChangeNotifier {
  final ReviewUseCases _reviewUseCases;

  /// Creates an instance of [ReviewProvider] with the given [ReviewUseCases].
  ReviewProvider(this._reviewUseCases);

  final _reviews = <Review>[];
  String? _errorMessage;

  /// Adds a [review] to the repository and updates the internal list of reviews
  ///
  /// Notifies listeners after the review is added.
  Future<void> addReview(Review review) async {
    debugPrint('add review provider');
    await _reviewUseCases.addReview(review: review);
    _reviews.add(review);
    notifyListeners();
  }

  /// Updates the internal list of reviews by fetching all reviews from
  /// the repository.
  ///
  /// Notifies listeners after updating.
  Future<void> update() async {
    _reviews.clear();
    _reviews.addAll(await _reviewUseCases.getReviews());
    notifyListeners();

    debugPrint('Reviews: $_reviews');
  }

  /// Retrieves reviews associated with a specific [travel] and updates
  /// the internal list.
  ///
  /// Notifies listeners after fetching.
  Future<void> getReviewsByTravel(Travel travel) async {
    _reviews.clear();
    _reviews.addAll(await _reviewUseCases.getReviewsByTravel(travel));
    notifyListeners();
  }

  /// Returns `true` if there was an error during any review operation.
  bool get hasError => _errorMessage != null;

  /// Returns the last error message encountered, if any.
  String? get errorMessage => _errorMessage;

  /// Returns the list of reviews currently stored in the provider.
  List<Review> get reviews => _reviews;

  /// Calculates and returns the average star rating of all reviews.
  ///
  /// Returns `0` if there are no reviews.
  double get rate {
    if (_reviews.isEmpty) return 0;

    return _reviews.fold(0, (previousValue, element) {
      return element.stars + previousValue;
    }) /
        _reviews.length;
  }
}
