import 'photos_table.dart';
import 'travel_table.dart';

abstract class TravelPhotosTable {
  static const String tableName = 'travelPhotos';

  static const String travelId = 'travelId';
  static const String photoId = 'photoId';

  static const String createTable =
      '''
      CREATE TABLE IF NOT EXISTS $tableName(
        $travelId INTEGER NOT NULL,
        $photoId INTEGER NOT NULL,
        FOREIGN KEY ($travelId) REFERENCES ${TravelTable.tableName} (${TravelTable.travelId}),
        FOREIGN KEY ($photoId) REFERENCES ${PhotosTable.tableName} (${PhotosTable.photoId}),
        PRIMARY KEY ($travelId, $photoId)
      )
      ''';
}
