import '../../../modules/review/review_repository.dart';
import '../../entities/review.dart';
import '../../entities/travel.dart';

class GetReviewsByTravel {
  final ReviewRepository _reviewRepository;

  GetReviewsByTravel(this._reviewRepository);

  Future<List<Review>> call(Travel travel) async {
    return await _reviewRepository.getReviewsByTravel(travel);
  }
}
