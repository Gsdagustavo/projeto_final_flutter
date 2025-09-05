import '../../entities/review.dart';
import '../../repositories/review/review_repository.dart';

/// Use case for fetching all [Review] objects from the repository.
class GetReviews {
  final ReviewRepository _reviewRepository;

  /// Creates an instance of [GetReviews] use case.
  ///
  /// [reviewRepository]: The repository that handles review persistence.
  GetReviews(this._reviewRepository);

  /// Retrieves all reviews from the repository.
  ///
  /// Returns a [Future] containing a [List] of [Review] objects.
  Future<List<Review>> call() async {
    return await _reviewRepository.getReviews();
  }
}
