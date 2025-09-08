import '../../entities/review.dart';
import '../../entities/travel.dart';

/// Repository interface to manage [Review] data in the application.
///
/// Defines methods to add, retrieve, and query reviews.
abstract class ReviewRepository {
  /// Adds a single review to the repository.
  ///
  /// [review]: The [Review] object to be added.
  Future<void> addReview({required Review review});

  /// Adds multiple reviews to the repository at once.
  ///
  /// [reviews]: A list of [Review] objects to be added.
  Future<void> addReviews({required List<Review> reviews});

  /// Deletes a review from the repository.
  ///
  /// [review]: The [Review] object to be deleted.
  Future<void> deleteReview({required Review review});

  /// Retrieves all reviews stored in the repository.
  ///
  /// Returns a [List] of [Review] objects.
  Future<List<Review>> getReviews();

  /// Retrieves all reviews associated with a specific travel.
  ///
  /// [travel]: The [Travel] object whose reviews will be fetched.
  /// Returns a [List] of [Review] objects.
  Future<List<Review>> getReviewsByTravel(Travel travel);

  /// Retrieves all reviews associated with a specific travel stop ID.
  ///
  /// [stopId]: The unique ID of the travel stop.
  /// Returns a [List] of [Review] objects.
  Future<List<Review>> getReviewsByStopId(String stopId);
}
