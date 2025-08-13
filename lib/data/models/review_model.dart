import '../../domain/entities/participant.dart';
import '../../domain/entities/review.dart';
import '../local/database/tables/reviews_table.dart';

class ReviewModel {
  final int? reviewId;
  final String description;
  final Participant author;
  final DateTime reviewDate;
  final int travelStopId;
  final int stars;

  const ReviewModel({
    this.reviewId,
    required this.description,
    required this.author,
    required this.reviewDate,
    required this.travelStopId,
    required this.stars,
  });

  Review copyWith({
    int? reviewId,
    String? description,
    Participant? author,
    DateTime? reviewDate,
    int? travelStopId,
    int? stars,
  }) {
    return Review(
      reviewId: reviewId ?? this.reviewId,
      description: description ?? this.description,
      author: author ?? this.author,
      reviewDate: reviewDate ?? this.reviewDate,
      travelStopId: travelStopId ?? this.travelStopId,
      stars: stars ?? this.stars,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      ReviewsTable.reviewId: reviewId,
      ReviewsTable.description: description,
      ReviewsTable.author: author,
      ReviewsTable.reviewDate: reviewDate,
      ReviewsTable.travelStopId: travelStopId,
      ReviewsTable.stars: stars,
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      reviewId: map[ReviewsTable.reviewId] as int,
      description: map[ReviewsTable.description] as String,
      author: map[ReviewsTable.author] as Participant,
      reviewDate: map[ReviewsTable.reviewDate] as DateTime,
      travelStopId: map[ReviewsTable.travelStopId] as int,
      stars: map[ReviewsTable.stars] as int,
    );
  }

  Review toEntity() {
    return Review(
      description: description,
      author: author,
      reviewDate: reviewDate,
      travelStopId: travelStopId,
      stars: stars,
    );
  }

  factory ReviewModel.fromEntity(Review review) {
    return ReviewModel(
      description: review.description,
      author: review.author,
      reviewDate: review.reviewDate,
      travelStopId: review.travelStopId,
      stars: review.stars,
    );
  }

  @override
  String toString() {
    return 'Review{reviewId: $reviewId, description: $description, author: $author, reviewDate: $reviewDate, travelStopId: $travelStopId, stars: $stars}';
  }
}
