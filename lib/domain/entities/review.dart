import 'dart:io';

import 'package:uuid/uuid.dart';

import 'participant.dart';
import 'travel_stop.dart';

/// Represents a [Review] written by a [Participant] for a [TravelStop].
///
/// This class stores information about the review content, rating (stars),
/// the author, the associated travel stop, the review date, and any attached
/// images.
///
/// It provides methods to create copies with updated fields and a string
/// representation.
class Review {
  /// Unique identifier for the review.
  ///
  /// Automatically generated using a UUID if not provided.
  final String id;

  /// Description or content of the review.
  final String description;

  /// Author of the review (a [Participant]).
  final Participant author;

  /// Date and time when the review was written.
  final DateTime reviewDate;

  /// The [TravelStop] this review is associated with.
  final String travelStopId;

  /// Rating for the travel stop, typically on a numerical scale (e.g., 1-5).
  final int stars;

  /// List of image files attached to the review.
  final List<File> images;

  /// Named constructor for [Review].
  ///
  /// Creates a new [Review] instance with required [description], [author],
  /// [reviewDate], [travelStopId], [stars], and [images].
  /// The [id] is optional; if not provided, a new UUID will be generated
  /// automatically.
  ///
  /// [id] – Unique identifier for the review (optional).
  /// [description] – Text content of the review (required).
  /// [author] – Participant who authored the review (required).
  /// [reviewDate] – Date of the review (required).
  /// [travelStopId] – The travel stop associated with the review (required).
  /// [stars] – Numerical rating (required).
  /// [images] – List of attached images (required).
  Review({
    String? id,
    required this.description,
    required this.author,
    required this.reviewDate,
    required this.travelStopId,
    required this.stars,
    required this.images,
  }) : id = id ?? Uuid().v4();

  /// Returns a copy of this [Review] with optional updated fields.
  ///
  /// [description] – New review text (optional).
  /// [author] – New author (optional).
  /// [reviewDate] – New review date (optional).
  /// [travelStopId] – New associated travel stop (optional).
  /// [stars] – New star rating (optional).
  /// [images] – New list of attached images (optional).
  Review copyWith({
    String? description,
    Participant? author,
    DateTime? reviewDate,
    String? travelStopId,
    int? stars,
    List<File>? images,
  }) {
    return Review(
      id: id,
      description: description ?? this.description,
      author: author ?? this.author,
      reviewDate: reviewDate ?? this.reviewDate,
      travelStopId: travelStopId ?? this.travelStopId,
      stars: stars ?? this.stars,
      images: images ?? this.images,
    );
  }

  @override
  String toString() {
    return 'Review{id: $id, description: $description, author: $author, '
        'reviewDate: $reviewDate, travelStopId: $travelStopId, stars: $stars, '
        'images: $images}';
  }
}
