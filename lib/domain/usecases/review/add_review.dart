import '../../../modules/review/review_repository.dart';
import '../../entities/review.dart';

class AddReview {
  final ReviewRepository _reviewRepository;

  AddReview(this._reviewRepository);

  Future<void> call({required Review review}) async {
    await _reviewRepository.addReview(review: review);
  }
}
