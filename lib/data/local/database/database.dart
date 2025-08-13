import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../domain/entities/enums.dart';
import 'tables/experiences_table.dart';
import 'tables/participants_table.dart';
import 'tables/places_table.dart';
import 'tables/reviews_table.dart';
import 'tables/transport_types_table.dart';
import 'tables/travel_participants_table.dart';
import 'tables/travel_stop_experiences_table.dart';
import 'tables/travel_stop_table.dart';
import 'tables/travel_table.dart';

/// Contains util methods to manipulate the database
class DBConnection {
  /// The name of the database
  static const String _dbName = 'traveldb';

  /// The current version of the database
  static const int _dbVersion = 1;

  /// Returns an instance of a Database
  Future<Database> getDatabase({bool reset = false}) async {
    final dbPath = join(await getDatabasesPath(), _dbName);
    return openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: _onCreate,
      onOpen: (db) async {
        if (reset) {
          await clearDatabase(db);
          await _onCreate(db, _dbVersion);
        }
      },
    );
  }

  /// Defines what to do when the database is created
  Future<void> _onCreate(Database db, int? version) async {
    await db.execute(TransportTypesTable.createTable);
    await db.execute(ExperiencesTable.createTable);
    await _insertDefaultValuesIntoTables(db);

    await db.execute(PlacesTable.createTable);
    await db.execute(TravelTable.createTable);
    await db.execute(TravelParticipantsTable.createTable);
    await db.execute(TravelStopTable.createTable);
    await db.execute(TravelStopExperiencesTable.createTable);
    await db.execute(ParticipantsTable.createTable);
    await db.execute(ReviewsTable.createTable);
  }

  /// Insert default enums ([TransportType] and [Experience]) values
  /// into [TransportTypesTable] and [ExperiencesTable]
  Future<void> _insertDefaultValuesIntoTables(Database db) async {
    /// Insert values into transport types table
    TransportType.values.map(
      (e) async => await db.insert(TransportTypesTable.tableName, {
        TransportTypesTable.tableName: e.index,
      }),
    );

    /// Insert values into experiences table
    Experience.values.map(
      (e) async => await db.insert(ExperiencesTable.tableName, {
        ExperiencesTable.experience: e.name,
      }),
    );
  }

  /// Cleans the database
  /// (WARNING: This was made to be used in debug mode only. DO NOT USE IN PRODUCTION)
  Future<void> clearDatabase(Database db) async {
    final tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%';",
    );

    for (var table in tables) {
      final tableName = table['name'] as String;
      await db.execute('DROP TABLE IF EXISTS $tableName');
    }
  }
}
