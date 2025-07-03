import 'package:projeto_final_flutter/database/tables/participants_table.dart';
import 'package:projeto_final_flutter/database/tables/travel_table.dart';

class TravelParticipantsTable {
  static const String tableName = 'participantTravel';

  static const String participantId = 'participantId';
  static const String travelId = 'travelId';

  static const String createTable =
      """
      CREATE TABLE $tableName(
        $participantId INTEGER NOT NULL,
        $travelId INTEGER NOT NULL,
        
        FOREIGN KEY ($participantId) REFERENCES ${ParticipantsTable.tableName} ($participantId),
        FOREIGN KEY ($travelId) REFERENCES ${TravelTable.travelId} ($travelId)
      );
      """;
}
