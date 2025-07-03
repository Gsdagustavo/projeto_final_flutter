import 'participants_table.dart';
import 'travel_table.dart';

/// This is a model class to be used when manipulating the TravelParticipants
/// Table in the database
class TravelParticipantsTable {

  /// The name of the table
  static const String tableName = 'participantTravel';

  static const String participantId = 'participantId';
  static const String travelId = 'travelId';

  /// SQLite command for creating the table
  static const String createTable =
      '''
      CREATE TABLE $tableName(
        $participantId INTEGER NOT NULL,
        $travelId INTEGER NOT NULL,
        
        FOREIGN KEY ($participantId) REFERENCES ${ParticipantsTable.tableName} ($participantId),
        FOREIGN KEY ($travelId) REFERENCES ${TravelTable.travelId} ($travelId)
      );
      ''';
}
