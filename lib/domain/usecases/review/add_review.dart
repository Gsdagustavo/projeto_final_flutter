import '../../entities/review.dart';
import '../../repositories/review/review_repository.dart';

class AddReview {
  final ReviewRepository _reviewRepository;

  AddReview(this._reviewRepository);

  Future<void> call({required Review review}) async {
    await _reviewRepository.addReview(review: review);
  }
}
