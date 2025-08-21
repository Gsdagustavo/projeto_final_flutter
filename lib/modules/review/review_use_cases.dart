import '../../domain/entities/review.dart';
import 'review_repository.dart';

abstract class ReviewUseCases {
  Future<void> addReview({required Review review});

  Future<void> addReviews({required List<Review> reviews});

  Future<List<Review>> getReviews();
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
}
