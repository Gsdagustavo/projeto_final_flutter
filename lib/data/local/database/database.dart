import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../domain/entities/enums.dart';
import 'tables/experiences_table.dart';
import 'tables/participants_table.dart';
import 'tables/photos_table.dart';
import 'tables/places_table.dart';
import 'tables/reviews_table.dart';
import 'tables/transport_types_table.dart';
import 'tables/travel_status_table.dart';
import 'tables/travel_stop_experiences_table.dart';
import 'tables/travel_stop_table.dart';
import 'tables/travel_table.dart';
import 'tables/travel_travel_status_table.dart';

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
    debugPrint('Database onCreate method called');

    await db.execute(TransportTypesTable.createTable);
    await db.execute(ExperiencesTable.createTable);
    await db.execute(TravelStatusTable.createTable);
    await _insertDefaultValuesIntoTables(db);

    await db.execute(TravelTable.createTable);
    await db.execute(TravelTravelStatusTable.createTable);
    await db.execute(PhotosTable.createTable);
    await db.execute(PlacesTable.createTable);
    await db.execute(TravelStopTable.createTable);
    await db.execute(TravelStopExperiencesTable.createTable);
    await db.execute(ParticipantsTable.createTable);
    await db.execute(ReviewsTable.createTable);

    debugPrint('Database onCreate method finished');
  }

  /// Insert default enums ([TransportType] and [Experience]) values
  /// into [TransportTypesTable] and [ExperiencesTable]
  Future<void> _insertDefaultValuesIntoTables(Database db) async {
    debugPrint('_insertDefaultValuesIntoTables method called');

    /// Insert values into transport types table
    TransportType.values.map(
      (t) async => await db.insert(TransportTypesTable.tableName, {
        TransportTypesTable.tableName: t.index,
      }),
    );

    /// Insert values into experiences table
    Experience.values.map(
      (e) async => await db.insert(ExperiencesTable.tableName, {
        ExperiencesTable.experienceIndex: e.index,
      }),
    );

    /// Insert values into travel status table
    TravelStatus.values.map(
      (s) async => await db.insert(TravelStatusTable.tableName, {
        TravelStatusTable.travelStatusIndex: s.index,
      }),
    );

    debugPrint('_insertDefaultValuesIntoTables method finished');
  }

  /// Cleans the database
  Future<void> clearDatabase(Database db) async {
    debugPrint('Clear database method called');

    final tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND "
      "name NOT LIKE 'sqlite_%';",
    );

    for (var table in tables) {
      final tableName = table['name'] as String;
      await db.execute('DROP TABLE IF EXISTS $tableName');
    }

    debugPrint('Database cleansed');
  }

  Future<void> printAllTables(Database db) async {
    final tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%';",
    );

    for (var table in tables) {
      final tableName = table['name'] as String;

      final rows = await db.rawQuery('SELECT * FROM $tableName');

      print('--- Table: $tableName ---');
      debugPrint('Rows: ${rows.length}');
      for (var row in rows) {
        print(row);
      }
    }
  }
}
