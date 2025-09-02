import '../../domain/entities/review.dart';
import '../../domain/entities/travel.dart';
import 'review_repository.dart';

abstract class ReviewUseCases {
  Future<void> addReview({required Review review});

  Future<void> addReviews({required List<Review> reviews});

  Future<List<Review>> getReviews();

  Future<List<Review>> getReviewsByTravel(Travel travel);
  Future<List<Review>> getReviewsByStopId(String stopId);
}

class ReviewUseCasesImpl implements ReviewUseCases {
  final ReviewRepository _reviewRepository;

  ReviewUseCasesImpl(this._reviewRepository);

  @override
  Future<void> addReviews({required List<Review> reviews}) async {
    await _reviewRepository.addReviews(reviews: reviews);
  }

  @override
  Future<void> addReview({required Review review}) async {
    await _reviewRepository.addReview(review: review);
  }

  @override
  Future<List<Review>> getReviews() async {
    return await _reviewRepository.getReviews();
  }

  @override
  Future<List<Review>> getReviewsByTravel(Travel travel) async {
    return await _reviewRepository.getReviewsByTravel(travel);
  }

  @override
  Future<List<Review>> getReviewsByStopId(String stopId) async {
    return await _reviewRepository.getReviewsByStopId(stopId);
  }
}
