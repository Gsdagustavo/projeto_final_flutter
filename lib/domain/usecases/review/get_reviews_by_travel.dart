import '../../entities/review.dart';
import '../../entities/travel.dart';
import '../../repositories/review/review_repository.dart';

/// Use case for fetching [Review] objects by [Travel].
class GetReviewsByTravel {
  final ReviewRepository _reviewRepository;

  /// Creates an instance of [GetReviewsByTravel] use case.
  ///
  /// [reviewRepository]: The repository that handles review persistence.
  GetReviewsByTravel(this._reviewRepository);

  /// Retrieves all reviews associated with a specific travel.
  ///
  /// [travel]: The [Travel] object to fetch reviews for.
  /// Returns a [Future] containing a [List] of [Review] objects.
  Future<List<Review>> call(Travel travel) async {
    return await _reviewRepository.getReviewsByTravel(travel);
  }
}
