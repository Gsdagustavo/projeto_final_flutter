import '../../entities/review.dart';
import '../../repositories/review/review_repository.dart';

/// Use case for adding multiple [Review] objects at once.
class AddReviews {
  final ReviewRepository _reviewRepository;

  /// Creates an instance of [AddReviews] use case.
  ///
  /// [reviewRepository]: The repository that handles review persistence.
  AddReviews(this._reviewRepository);

  /// Adds multiple reviews using the repository.
  ///
  /// [reviews]: A list of [Review] objects to be added.
  /// Returns a [Future] that completes when the operation is done.
  Future<void> call({required List<Review> reviews}) async {
    await _reviewRepository.addReviews(reviews: reviews);
  }
}
