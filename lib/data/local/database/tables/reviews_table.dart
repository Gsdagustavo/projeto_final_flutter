abstract final class ReviewsTable {
  static const String tableName = 'reviewTable';

  static const String reviewId = 'reviewId';
  static const String description = 'description';
  static const String author = 'author';
  static const String reviewDate = 'reviewDate';
  static const String travelId = 'travelId';
  static const String stars = 'stars';

  static const String createTable =
      '''
       CREATE TABLE $tableName(
        $reviewId INTEGER PRIMARY KEY AUTOINCREMENT,
        $description TEXT NOT NULL,
        $author TEXT NOT NULL,
        $reviewDate TEXT NOT NULL,
        $travelId TEXT NOT NULL,
        $stars TEXT NOT NULL
       )
      ''';
}
