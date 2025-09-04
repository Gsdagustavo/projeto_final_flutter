import '../../../modules/review/review_repository.dart';
import '../../entities/review.dart';

class GetReviewsByStopId {
  final ReviewRepository _reviewRepository;

  GetReviewsByStopId(this._reviewRepository);

  Future<List<Review>> call(String stopId) async {
    return await _reviewRepository.getReviewsByStopId(stopId);
  }
}
