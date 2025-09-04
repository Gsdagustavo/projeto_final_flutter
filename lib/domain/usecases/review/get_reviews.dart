import '../../../modules/review/review_repository.dart';
import '../../entities/review.dart';

class GetReviews {
  final ReviewRepository _reviewRepository;

  GetReviews(this._reviewRepository);

  Future<List<Review>> call() async {
    return await _reviewRepository.getReviews();
  }
}
