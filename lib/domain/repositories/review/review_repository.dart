import '../../entities/review.dart';
import '../../entities/travel.dart';

abstract class ReviewRepository {
  Future<void> addReview({required Review review});

  Future<void> addReviews({required List<Review> reviews});

  Future<List<Review>> getReviews();

  Future<List<Review>> getReviewsByTravel(Travel travel);

  Future<List<Review>> getReviewsByStopId(String stopId);
}
