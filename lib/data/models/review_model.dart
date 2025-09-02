import 'dart:io';

import '../../domain/entities/review.dart';
import '../local/database/tables/reviews_table.dart';
import 'participant_model.dart';
import 'travel_stop_model.dart';

class ReviewModel {
  final String id;
  final String description;
  final ParticipantModel author;
  final DateTime reviewDate;
  final TravelStopModel travelStop;
  final int stars;
  final List<File> images;

  const ReviewModel({
    required this.id,
    required this.description,
    required this.author,
    required this.reviewDate,
    required this.travelStop,
    required this.stars,
    required this.images,
  });

  ReviewModel copyWith({
    String? reviewId,
    String? description,
    ParticipantModel? author,
    DateTime? reviewDate,
    TravelStopModel? travelStop,
    int? stars,
    List<File>? images,
  }) {
    return ReviewModel(
      id: reviewId ?? this.id,
      description: description ?? this.description,
      author: author ?? this.author,
      reviewDate: reviewDate ?? this.reviewDate,
      travelStop: travelStop ?? this.travelStop,
      stars: stars ?? this.stars,
      images: images ?? this.images,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      ReviewsTable.reviewId: id,
      ReviewsTable.description: description,
      ReviewsTable.reviewDate: reviewDate.millisecondsSinceEpoch,
      ReviewsTable.travelStopId: travelStop.id,
      ReviewsTable.stars: stars,
      ReviewsTable.participantId: author.id,
    };
  }

  factory ReviewModel.fromMap(
    Map<String, dynamic> map,
    ParticipantModel participant,
    TravelStopModel travelStop,
    List<File> images,
  ) {
    return ReviewModel(
      id: map[ReviewsTable.reviewId] as String,
      description: map[ReviewsTable.description] as String,
      author: participant,
      reviewDate: DateTime.fromMicrosecondsSinceEpoch(
        map[ReviewsTable.reviewDate] as int,
      ),
      travelStop: travelStop,
      stars: map[ReviewsTable.stars] as int,
      images: images,
    );
  }

  Review toEntity() {
    return Review(
      description: description,
      author: author.toEntity(),
      reviewDate: reviewDate,
      travelStop: travelStop.toEntity(),
      stars: stars,
      images: images,
    );
  }

  factory ReviewModel.fromEntity(Review review) {
    return ReviewModel(
      id: review.id,
      description: review.description,
      author: ParticipantModel.fromEntity(review.author),
      reviewDate: review.reviewDate,
      travelStop: TravelStopModel.fromEntity(review.travelStop),
      stars: review.stars,
      images: review.images,
    );
  }

  @override
  String toString() {
    return 'Review{reviewId: $id, description: $description, '
        'author: $author, reviewDate: $reviewDate, travelStop: $travelStop'
        ', stars: $stars}';
  }
}
