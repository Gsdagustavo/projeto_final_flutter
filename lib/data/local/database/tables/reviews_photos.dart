import 'reviews_table.dart';

/// SQLite table schema and constants for the `reviewsPhotos` table.
///
/// This class defines the column names and the SQL statement to create
/// the table. It represents the one-to-many relationship between reviews
/// and their associated photos.
abstract final class ReviewsPhotosTable {
  /// Name of the reviewsPhotos table in the database.
  static const String tableName = 'reviewsPhotos';

  /// Column name for the Photo ID.
  ///
  /// `INTEGER PRIMARY KEY AUTOINCREMENT`
  static const String photoId = 'photoId';

  /// Column name for the Photo data.
  ///
  /// `BLOB NOT NULL`
  static const String photo = 'photo';

  /// Column name for the Review ID (foreign key).
  ///
  /// References [ReviewsTable.reviewId]
  static const String reviewId = ReviewsTable.reviewId;

  /// SQL command to create the reviewsPhotos table.
  static const String createTable =
      '''
      CREATE TABLE $tableName (
        $photoId INTEGER PRIMARY KEY AUTOINCREMENT,
        $reviewId TEXT NOT NULL,
        $photo BLOB NOT NULL,
        
        FOREIGN KEY ($reviewId) REFERENCES ${ReviewsTable.tableName} (${ReviewsTable.reviewId})
      );
      ''';
}
