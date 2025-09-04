import '../../entities/review.dart';
import '../../repositories/review/review_repository.dart';

class AddReviews {
  final ReviewRepository _reviewRepository;

  AddReviews(this._reviewRepository);

  Future<void> call({required List<Review> reviews}) async {
    await _reviewRepository.addReviews(reviews: reviews);
  }
}
