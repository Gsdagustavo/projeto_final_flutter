import '../../entities/review.dart';
import '../../repositories/review/review_repository.dart';

/// Use case for adding a single [Review].
class DeleteReview {
  /// Repository to perform review operations.
  final ReviewRepository _reviewRepository;

  /// Creates an instance of [DeleteReview] use case.
  ///
  /// [reviewRepository]: The repository that handles review persistence.
  DeleteReview(this._reviewRepository);

  /// Deletes review using the repository.
  ///
  /// [review]: The [Review] object to be deleted.
  /// Returns a [Future] that completes when the operation is done.
  Future<void> call({required Review review}) async {
    await _reviewRepository.deleteReview(review: review);
  }
}
