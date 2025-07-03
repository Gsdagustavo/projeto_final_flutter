import 'package:projeto_final_flutter/database/tables/travel_stop_table.dart';

import 'experiences_table.dart';

class TravelStopExperiencesTable {
  static const String tableName = 'travelStopExperiences';

  static const String travelStopId = 'travelStopId';
  static const String experienceId = 'experienceId';

  static const String createTable =
      """
      CREATE TABLE $tableName(
       $travelStopId INTEGER NOT NULL,
       $experienceId INTEGER NOT NULL,
       
       FOREIGN KEY ($travelStopId) REFERENCES ${TravelStopTable.tableName} (${TravelStopTable.id}),
       FOREIGN KEY ($experienceId) REFERENCES ${ExperiencesTable.tableName} (${ExperiencesTable.experienceId}),
       
       PRIMARY KEY ($travelStopId, $experienceId)
      );
      """;
}
