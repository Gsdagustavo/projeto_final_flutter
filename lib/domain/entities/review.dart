import 'dart:io';

import 'package:uuid/uuid.dart';

import 'participant.dart';

class Review {
  final String id;
  final String description;
  final Participant author;
  final DateTime reviewDate;
  final String travelStopId;
  final int stars;
  final List<File> images;

  Review({
    String? id,
    required this.description,
    required this.author,
    required this.reviewDate,
    required this.travelStopId,
    required this.stars,
    required this.images,
  }) : id = id ?? Uuid().v4();

  Review copyWith({
    String? description,
    Participant? author,
    DateTime? reviewDate,
    String? travelStopId,
    int? stars,
    List<File>? images,
  }) {
    return Review(
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
    return 'Review{id: $id, description: $description, author: $author, reviewDate: $reviewDate, travelStopId: $travelStopId, stars: $stars, images: $images}';
  }
}
