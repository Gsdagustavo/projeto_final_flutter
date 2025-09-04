import '../../entities/review.dart';
import '../../repositories/review/review_repository.dart';

class GetReviewsByStopId {
  final ReviewRepository _reviewRepository;

  GetReviewsByStopId(this._reviewRepository);

  Future<List<Review>> call(String stopId) async {
    return await _reviewRepository.getReviewsByStopId(stopId);
  }
}
