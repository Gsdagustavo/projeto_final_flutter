import '../../entities/review.dart';
import '../../repositories/review/review_repository.dart';

class GetReviews {
  final ReviewRepository _reviewRepository;

  GetReviews(this._reviewRepository);

  Future<List<Review>> call() async {
    return await _reviewRepository.getReviews();
  }
}
