import 'dart:io';

import '../../domain/entities/review.dart';
import '../local/database/tables/reviews_table.dart';
import 'participant_model.dart';
import 'travel_stop_model.dart';

/// Model class to represent a [Review].
///
/// This model class contains methods to manipulate review data, such as
/// fromMap, toMap, fromEntity, toEntity, and other serialization/deserialization
/// operations. It stores information about the review description,
/// rating (stars), associated participant, travel stop, and optional images.
class ReviewModel {
  /// Unique identifier of the review.
  final String id;

  /// Text description of the review.
  final String description;

  /// Author of the review (participant).
  final ParticipantModel author;

  /// Date of the review.
  final DateTime reviewDate;

  /// Travel stop to which the review is related.
  final String travelStopId;

  /// Number of stars given in the review.
  final int stars;

  /// Images attached to the review.
  final List<File> images;

  /// Named constructor for [ReviewModel].
  ///
  /// [id] is the unique review identifier.
  /// [description] is the review content.
  /// [author] is the participant who wrote the review.
  /// [reviewDate] is the date of the review.
  /// [travelStopId] is the related travel stop.
  /// [stars] is the rating.
  /// [images] is the list of images attached.
  const ReviewModel({
    required this.id,
    required this.description,
    required this.author,
    required this.reviewDate,
    required this.travelStopId,
    required this.stars,
    required this.images,
  });

  /// Returns a copy of this [ReviewModel] with optional updated fields.
  ReviewModel copyWith({
    String? reviewId,
    String? description,
    ParticipantModel? author,
    DateTime? reviewDate,
    String? travelStopId,
    int? stars,
    List<File>? images,
  }) {
    return ReviewModel(
      id: reviewId ?? id,
      description: description ?? this.description,
      author: author ?? this.author,
      reviewDate: reviewDate ?? this.reviewDate,
      travelStopId: travelStopId ?? this.travelStopId,
      stars: stars ?? this.stars,
      images: images ?? this.images,
    );
  }

  /// Converts this [ReviewModel] into a [Map] for database storage.
  Map<String, dynamic> toMap() {
    return {
      ReviewsTable.reviewId: id,
      ReviewsTable.description: description,
      ReviewsTable.reviewDate: reviewDate.millisecondsSinceEpoch,
      ReviewsTable.travelStopId: travelStopId,
      ReviewsTable.stars: stars,
      ReviewsTable.participantId: author.id,
    };
  }

  /// Creates a [ReviewModel] from a [Map] (e.g., from database row).
  ///
  /// [map] contains the database row data.
  /// [participant] is the author of the review.
  /// [travelStop] is the travel stop related to the review.
  /// [images] is the list of images attached to the review.
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
      reviewDate: DateTime.fromMillisecondsSinceEpoch(
        map[ReviewsTable.reviewDate] as int,
      ),
      travelStopId: map[ReviewsTable.travelStopId] as String,
      stars: map[ReviewsTable.stars] as int,
      images: images,
    );
  }

  /// Converts this [ReviewModel] to a domain [Review] entity.
  Review toEntity() {
    return Review(
      id: id,
      description: description,
      author: author.toEntity(),
      reviewDate: reviewDate,
      travelStopId: travelStopId,
      stars: stars,
      images: images,
    );
  }

  /// Creates a [ReviewModel] from a domain [Review] entity.
  factory ReviewModel.fromEntity(Review review) {
    return ReviewModel(
      id: review.id,
      description: review.description,
      author: ParticipantModel.fromEntity(review.author),
      reviewDate: review.reviewDate,
      travelStopId: review.travelStopId,
      stars: review.stars,
      images: review.images,
    );
  }

  @override
  String toString() {
    return 'ReviewModel{id: $id, description: $description, '
        'author: $author, reviewDate: $reviewDate, travelStop: $travelStopId, '
        'stars: $stars, images: $images}';
  }
}
