import '../../entities/review.dart';
import '../../repositories/review/review_repository.dart';

/// Use case for fetching [Review] objects by a travel stop ID.
class GetReviewsByStopId {
  final ReviewRepository _reviewRepository;

  /// Creates an instance of [GetReviewsByStopId] use case.
  ///
  /// [reviewRepository]: The repository that handles review persistence.
  GetReviewsByStopId(this._reviewRepository);

  /// Retrieves all reviews associated with a specific travel stop.
  ///
  /// [stopId]: The unique ID of the travel stop.
  /// Returns a [Future] containing a [List] of [Review] objects.
  Future<List<Review>> call(String stopId) async {
    return await _reviewRepository.getReviewsByStopId(stopId);
  }
}
