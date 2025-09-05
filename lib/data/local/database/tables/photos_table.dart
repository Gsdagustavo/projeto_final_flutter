import 'travel_table.dart';

/// SQLite table schema and constants for the `photos` table.
///
/// This class defines the column names and the SQL statement to create
/// the table. Each photo is associated with a travel.
abstract final class PhotosTable {
  /// Name of the photos table in the database.
  static const String tableName = 'photos';

  /// Column name for the Photo ID.
  ///
  /// `INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT`
  static const String photoId = 'photoId';

  /// Column name for the photo data.
  ///
  /// `BLOB NOT NULL`
  static const String photo = 'photo';

  /// Column name for the Travel ID (foreign key).
  ///
  /// References [TravelTable.travelId]
  static const String travelId = TravelTable.travelId;

  /// SQL command to create the photos table.
  static const String createTable =
  '''
      CREATE TABLE IF NOT EXISTS $tableName (
        $photoId INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        $photo BLOB NOT NULL,
        $travelId INTEGER NOT NULL,
        
        FOREIGN KEY ($travelId) REFERENCES ${TravelTable.tableName} (${TravelTable.travelId})
      );
      ''';
}
