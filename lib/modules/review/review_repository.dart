import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../../data/local/database/database.dart';
import '../../data/local/database/tables/participants_table.dart';
import '../../data/local/database/tables/reviews_photos.dart';
import '../../data/local/database/tables/reviews_table.dart';
import '../../data/models/participant_model.dart';
import '../../data/models/review_model.dart';
import '../../domain/entities/review.dart';

abstract class ReviewRepository {
  Future<void> addReview({required Review review});

  Future<void> addReviews({required List<Review> reviews});

  Future<List<Review>> getReviews();
}

class ReviewRepositoryImpl implements ReviewRepository {
  late final Future<Database> _db = DBConnection().getDatabase();

  @override
  Future<void> addReviews({required List<Review> reviews}) async {
    final db = await _db;

    await db.transaction((txn) async {
      for (final review in reviews) {
        final reviewData = ReviewModel.fromEntity(review).toMap();

        /// Insert into [ReviewsTable]
        await txn.insert(ReviewsTable.tableName, reviewData);

        /// Insert into [ReviewsPhotosTable]
        for (final image in review.images) {
          final data = {
            ReviewsPhotosTable.reviewId: review.id,
            ReviewsPhotosTable.photo: image.readAsBytesSync(),
          };

          await txn.insert(ReviewsPhotosTable.tableName, data);
        }

        debugPrint('Review $review added to database');
      }
    });
  }

  @override
  Future<void> addReview({required Review review}) async {
    final db = await _db;

    await db.transaction((txn) async {
      final reviewData = ReviewModel.fromEntity(review).toMap();

      /// Insert into [ReviewsTable]
      await txn.insert(ReviewsTable.tableName, reviewData);

      /// Insert into [ReviewsPhotosTable]
      for (final image in review.images) {
        final data = {
          ReviewsPhotosTable.reviewId: review.id,
          ReviewsPhotosTable.photo: image.readAsBytesSync(),
        };

        await txn.insert(ReviewsPhotosTable.tableName, data);
      }
    });

    debugPrint('Review ${review.toString()} added to database');
  }

  @override
  Future<List<Review>> getReviews() async {
    final db = await _db;

    final reviews = <Review>[];

    await db.transaction((txn) async {
      final reviewsData = await txn.query(ReviewsTable.tableName);

      for (final reviewData in reviewsData) {
        debugPrint('Review data: $reviewData');

        final reviewId = reviewData[ReviewsTable.reviewId];

        /// Get participant
        final participantData = await txn.query(
          ParticipantsTable.tableName,
          where: '${ParticipantsTable.participantId} = ?',
          whereArgs: [reviewData[ReviewsTable.participantId]],
        );

        final participant = ParticipantModel.fromMap(participantData.first);

        /// Get photos
        final photos = <File>[];

        final reviewPhotosData = await txn.query(
          ReviewsPhotosTable.tableName,
          where: '${ReviewsPhotosTable.reviewId} = ?',
          whereArgs: [reviewId],
        );

        for (final photoData in reviewPhotosData) {
          final bytes = photoData[ReviewsPhotosTable.photo] as Uint8List;

          debugPrint(bytes.toString());

          final filename = '${photoData[ReviewsPhotosTable.reviewId]}.png';
          final file = File('${Directory.systemTemp.path}/$filename');
          file.writeAsBytesSync(bytes);
          photos.add(file);
          await file.delete();
        }

        final review = ReviewModel.fromMap(
          reviewData,
          participant,
          photos,
        ).toEntity();

        reviews.add(review);

        debugPrint('Review: $review');
      }
    });

    return reviews;
  }
}
