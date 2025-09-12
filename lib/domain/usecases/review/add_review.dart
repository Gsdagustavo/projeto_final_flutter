import 'package:dartz/dartz.dart';

import '../../../core/exceptions/failure.dart';
import '../../entities/review.dart';
import '../../repositories/review/review_repository.dart';

/// Use case for adding a single [Review].
class AddReview {
  /// Repository to perform review operations.
  final ReviewRepository _reviewRepository;

  /// Creates an instance of [AddReview] use case.
  ///
  /// [reviewRepository]: The repository that handles review persistence.
  AddReview(this._reviewRepository);

  /// Adds a single review using the repository.
  ///
  /// [review]: The [Review] object to be added.
  /// Returns a [Future] that completes when the operation is done.
  Future<Either<Failure, void>> call({required Review review}) async {
    if (review.description.trim().isEmpty && review.images.isEmpty) {
      return Left(
        Failure('Review needs to have at least a description or an image'),
      );
    }

    await _reviewRepository.addReview(review: review);

    return Right(null);
  }
}
