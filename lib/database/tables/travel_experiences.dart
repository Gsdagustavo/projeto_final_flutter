import 'package:projeto_final_flutter/database/tables/travel_table.dart';

import 'experiences_table.dart';

/// This is a model class to be used when manipulating the TravelExperiences
/// Table in the database
class TravelExperiencesTable {
  /// The name of the table
  static const String tableName = 'travelExperiences';

  static const String travelId = 'travelId';
  static const String experienceId = 'experienceId';

  /// SQLite command for creating the table
  static const String createTable =
      '''
      CREATE TABLE $tableName(
       $travelId INTEGER NOT NULL,
       $experienceId INTEGER NOT NULL,
       
       FOREIGN KEY ($travelId) REFERENCES ${TravelTable.tableName} (${TravelTable.travelId}),
       FOREIGN KEY ($experienceId) REFERENCES ${ExperiencesTable.tableName} (${ExperiencesTable.experienceId}),
       
       PRIMARY KEY ($travelId, $experienceId)
      );
      ''';
}
