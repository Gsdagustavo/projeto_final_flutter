import 'participant.dart';

class Review {
  final int? reviewId;
  final String description;
  final Participant author;
  final DateTime reviewDate;
  final int travelId;
  final int stars;

  const Review({
    this.reviewId,
    required this.description,
    required this.author,
    required this.reviewDate,
    required this.travelId,
    required this.stars,
  });

  Review copyWith({
    int? reviewId,
    String? description,
    Participant? author,
    DateTime? reviewDate,
    int? travelId,
    int? stars,
  }) {
    return Review(
      reviewId: reviewId ?? this.reviewId,
      description: description ?? this.description,
      author: author ?? this.author,
      reviewDate: reviewDate ?? this.reviewDate,
      travelId: travelId ?? this.travelId,
      stars: stars ?? this.stars,
    );
  }

  @override
  String toString() {
    return 'Review{reviewId: $reviewId, description: $description, author: $author, reviewDate: $reviewDate, travelId: $travelId, stars: $stars}';
  }
}
