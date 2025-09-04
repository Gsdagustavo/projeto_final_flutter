import '../../../modules/review/review_repository.dart';
import 'add_review.dart';
import 'add_reviews.dart';
import 'get_reviews.dart';
import 'get_reviews_by_stop_id.dart';
import 'get_reviews_by_travel.dart';

class ReviewUseCases {
  final AddReviews addReviews;
  final AddReview addReview;
  final GetReviews getReviews;
  final GetReviewsByTravel getReviewsByTravel;
  final GetReviewsByStopId getReviewsByStopId;

  const ReviewUseCases({
    required this.addReviews,
    required this.addReview,
    required this.getReviews,
    required this.getReviewsByTravel,
    required this.getReviewsByStopId,
  });

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
