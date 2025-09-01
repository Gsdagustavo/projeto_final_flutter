import 'package:uuid/uuid.dart';

import 'participant.dart';

class Review {
  final String id;
  final String description;
  final Participant author;
  final DateTime reviewDate;
  final String travelStopId;
  final int stars;

  Review({
    String? id,
    required this.description,
    required this.author,
    required this.reviewDate,
    required this.travelStopId,
    required this.stars,
  }) : id = id ?? Uuid().v4();

  Review copyWith({
    String? description,
    Participant? author,
    DateTime? reviewDate,
    String? travelStopId,
    int? stars,
  }) {
    return Review(
      description: description ?? this.description,
      author: author ?? this.author,
      reviewDate: reviewDate ?? this.reviewDate,
      travelStopId: travelStopId ?? this.travelStopId,
      stars: stars ?? this.stars,
    );
  }


}
