import 'reviews_table.dart';

abstract final class ReviewsPhotosTable {
  static const String tableName = 'reviewsPhotosTable';

  static const String reviewId = 'reviewId';
  static const String photo = 'photo';

  static const String createTable =
      '''
     CREATE TABLE $tableName(
      $reviewId TEXT NOT NULL,
      $photo BLOB,
      
      FOREIGN KEY ($reviewId) REFERENCES ${ReviewsTable.tableName} (${ReviewsTable.reviewId})
     )
      ''';
}
