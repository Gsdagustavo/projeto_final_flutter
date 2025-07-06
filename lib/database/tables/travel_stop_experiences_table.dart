import 'experiences_table.dart';
import 'travel_stop_table.dart';

/// This is a model class to be used when manipulating the TravelStopExperiences
/// Table in the database
class TravelStopExperiencesTable {
  /// The name of the table
  static const String tableName = 'travelStopExperiences';

  static const String travelStopId = 'travelStopId';
  static const String experienceId = 'experienceId';

  /// SQLite command for creating the table
  static const String createTable =
      '''
      CREATE TABLE $tableName(
        $travelStopId INTEGER NOT NULL,
        $experienceId INTEGER NOT NULL,
        
        FOREIGN KEY ($travelStopId) REFERENCES ${TravelStopTable.tableName} (${TravelStopTable.travelStopId}),
        FOREIGN KEY ($experienceId) REFERENCES ${ExperiencesTable.tableName} (${ExperiencesTable.experienceId}),
        
        PRIMARY KEY ($travelStopId, $experienceId)
      );
      ''';
}
