import 'experiences_table.dart';
import 'travel_stop_table.dart';

/// SQLite table schema and constants for the `travelStopExperiences` table.
///
/// This class defines the column names and the SQL statement to create
/// the table. It represents the many-to-many relationship between travel stops
/// and experiences.
abstract final class TravelStopExperiencesTable {
  /// Name of the travelStopExperiences table in the database.
  static const String tableName = 'travelStopExperiences';

  /// Column name for the Travel Stop ID (foreign key).
  ///
  /// References [TravelStopTable.travelStopId]
  static const String travelStopId = TravelStopTable.travelStopId;

  /// Column name for the Experience Index (foreign key).
  ///
  /// References [ExperiencesTable.experienceIndex]
  static const String experienceIndex = ExperiencesTable.experienceIndex;

  /// SQL command to create the travelStopExperiences table.
  static const String createTable =
  '''
      CREATE TABLE $tableName (
        $travelStopId TEXT NOT NULL,
        $experienceIndex INTEGER NOT NULL,
        
        FOREIGN KEY ($travelStopId) REFERENCES ${TravelStopTable.tableName} (${TravelStopTable.travelStopId}),
        FOREIGN KEY ($experienceIndex) REFERENCES ${ExperiencesTable.tableName} (${ExperiencesTable.experienceIndex}),
        PRIMARY KEY ($travelStopId, $experienceIndex)
      );
      ''';
}
