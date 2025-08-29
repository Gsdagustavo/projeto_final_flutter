import 'travel_table.dart';

abstract final class PhotosTable {
  static const String tableName = 'photos';

  static const String photoId = 'photoId';
  static const String photo = 'photo';
  static const String travelId = 'travelId';

  static const String createTable =
      '''
      CREATE TABLE IF NOT EXISTS $tableName(
        $photoId INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        $photo BLOB NOT NULL,
        $travelId INT NOT NULL,
        
        FOREIGN KEY ($travelId) REFERENCES ${TravelTable.tableName}(${TravelTable.travelId})
      )
      ''';
}
