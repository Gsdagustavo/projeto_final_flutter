import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../entities/enums.dart';
import 'tables/experiences_table.dart';
import 'tables/participants_table.dart';
import 'tables/transport_types_table.dart';
import 'tables/travel_experiences.dart';
import 'tables/travel_participants_table.dart';
import 'tables/travel_stop_experiences_table.dart';
import 'tables/travel_stop_table.dart';
import 'tables/travel_table.dart';

/// Contains util methods to manipulate the database
class DBConnection {
  /// The name of the database
  static const String _dbName = 'traveldb';

  /// The current version of the database
  static const int _dbVersion = 2;

  /// Returns an instance of a Database
  Future<Database> getDatabase() async {
    final dbPath = join(await getDatabasesPath(), _dbName);
    return openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Defines what to do when the database is created
  Future<void> _onCreate(Database db, int? version) async {
    await db.execute(TransportTypesTable.createTable);
    await db.execute(ExperiencesTable.createTable);
    await _insertDefaultValuesIntoTables(db);

    await db.execute(TravelTable.createTable);
    await db.execute(TravelParticipantsTable.createTable);
    await db.execute(TravelExperiencesTable.createTable);
    await db.execute(TravelStopTable.createTable);
    await db.execute(TravelStopExperiencesTable.createTable);
    await db.execute(ParticipantsTable.createTable);
  }

  /// Defines what to do when the database is upgraded
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute('DROP TABLE IF EXISTS ${ExperiencesTable.tableName}');
    await db.execute('DROP TABLE IF EXISTS ${TransportTypesTable.tableName}');
    await db.execute('DROP TABLE IF EXISTS ${TravelTable.tableName}');
    await db.execute(
      'DROP TABLE IF EXISTS ${TravelParticipantsTable.tableName}',
    );
    await db.execute(
      'DROP TABLE IF EXISTS ${TravelExperiencesTable.tableName}',
    );
    await db.execute('DROP TABLE IF EXISTS ${TravelStopTable.tableName}');
    await db.execute(
      'DROP TABLE IF EXISTS ${TravelStopExperiencesTable.tableName}',
    );
    await db.execute('DROP TABLE IF EXISTS ${ParticipantsTable.tableName}');

    await _onCreate(db, newVersion);
  }

  /// Insert default enums ([TransportType] and [Experience]) values
  /// into [TransportTypesTable] and [ExperiencesTable]
  Future<void> _insertDefaultValuesIntoTables(Database db) async {
    final transportTypes = TransportType.values;
    final experiences = Experience.values;

    /// Insert values into transport types table
    for (final value in transportTypes) {
      await db.insert(TransportTypesTable.tableName, {
        TransportTypesTable.name: value.name,
      });
    }

    /// Insert values into experiences table
    for (final value in experiences) {
      await db.insert(ExperiencesTable.tableName, {
        ExperiencesTable.name: value.name,
      });
    }
  }
}
