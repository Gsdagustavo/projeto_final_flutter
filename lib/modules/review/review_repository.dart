import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../../data/local/database/database.dart';
import '../../data/local/database/tables/participants_table.dart';
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

    for (final review in reviews) {
      await db.transaction((txn) async {
        final reviewData = ReviewModel.fromEntity(review).toMap();

        /// Insert into [ReviewsTable]
        await txn.insert(ReviewsTable.tableName, reviewData);
      });

      debugPrint('Review $review added to database');
    }
  }

  @override
  Future<void> addReview({required Review review}) async {
    final db = await _db;

    await db.transaction((txn) async {
      final reviewData = ReviewModel.fromEntity(review).toMap();

      /// Insert into [ReviewsTable]
      await txn.insert(ReviewsTable.tableName, reviewData);
    });

    debugPrint('Review $review added to database');
  }

  @override
  Future<List<Review>> getReviews() async {
    final db = await _db;

    final reviews = <Review>[];
    final reviewsData = await db.query(ReviewsTable.tableName);

    for (final reviewData in reviewsData) {
      final participantData = await db.query(
        ParticipantsTable.tableName,
        where: '${ParticipantsTable.participantId} = ?',
        whereArgs: [reviewData[ReviewsTable.participantId]],
      );

      final participant = ParticipantModel.fromMap(participantData.first);
      final review = ReviewModel.fromMap(reviewData, participant).toEntity();
      reviews.add(review);

      debugPrint('Review: $review');
    }

    return reviews;
  }
}
