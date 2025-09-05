import '../../repositories/review/review_repository.dart';
import 'add_review.dart';
import 'add_reviews.dart';
import 'get_reviews.dart';
import 'get_reviews_by_stop_id.dart';
import 'get_reviews_by_travel.dart';

/// Aggregates all [Review] related use cases for easy access.
class ReviewUseCases {
  /// Use case to add multiple reviews at once
  final AddReviews addReviews;

  /// Use case to add a single review
  final AddReview addReview;

  /// Use case to fetch all reviews
  final GetReviews getReviews;

  /// Use case to fetch reviews by [Travel]
  final GetReviewsByTravel getReviewsByTravel;

  /// Use case to fetch reviews by travel stop ID
  final GetReviewsByStopId getReviewsByStopId;

  /// Creates an instance of [ReviewUseCases].
  const ReviewUseCases({
    required this.addReviews,
    required this.addReview,
    required this.getReviews,
    required this.getReviewsByTravel,
    required this.getReviewsByStopId,
  });

  /// Factory constructor to create [ReviewUseCases] with a single repository.
  ///
  /// [repository]: The [ReviewRepository] instance used by all use cases.
  factory ReviewUseCases.create(ReviewRepository repository) {
    return ReviewUseCases(
      addReviews: AddReviews(repository),
      addReview: AddReview(repository),
      getReviews: GetReviews(repository),
      getReviewsByTravel: GetReviewsByTravel(repository),
      getReviewsByStopId: GetReviewsByStopId(repository),
    );
  }
}
