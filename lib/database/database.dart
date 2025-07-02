import 'package:path/path.dart';
import 'package:projeto_final_flutter/database/tables/experiences_table.dart';
import 'package:projeto_final_flutter/database/tables/participant_travel_table.dart';
import 'package:projeto_final_flutter/database/tables/participants_table.dart';
import 'package:projeto_final_flutter/database/tables/transport_types_table.dart';
import 'package:projeto_final_flutter/database/tables/travel_experiences.dart';
import 'package:projeto_final_flutter/database/tables/travel_stop_table.dart';
import 'package:projeto_final_flutter/database/tables/travel_stop_table_experiences.dart';
import 'package:projeto_final_flutter/database/tables/travel_table.dart';
import 'package:projeto_final_flutter/entities/enums.dart';
import 'package:sqflite/sqflite.dart';

class DBConnection {
  static const String dbName = 'traveldb';
  static const int dbVersion = 2;

  Future<Database> getDatabase() async {
    final dbPath = join(await getDatabasesPath(), dbName);
    return openDatabase(dbPath, version: dbVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  Future<void> _onCreate(Database db, int? version) async {
    await db.execute(TransportTypesTable.createTable);
    await db.execute(ExperiencesTable.createTable);
    await _insertDefaultValuesIntoTables(db);

    await db.execute(ParticipantsTable.createTable);
    await db.execute(ParticipantsTravelTable.createTable);
    await db.execute(TravelTable.createTable);
    await db.execute(TravelExperiencesTable.createTable);
    await db.execute(TravelStopTable.createTable);
    await db.execute(TravelStopExperiencesTable.createTable);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute('DROP TABLE IF EXISTS ${TravelStopExperiencesTable.tableName}');
    await db.execute('DROP TABLE IF EXISTS ${TravelStopTable.tableName}');
    await db.execute('DROP TABLE IF EXISTS ${TravelExperiencesTable.tableName}');
    await db.execute('DROP TABLE IF EXISTS ${TravelTable.tableName}');
    await db.execute('DROP TABLE IF EXISTS ${ExperiencesTable.tableName}');
    await db.execute('DROP TABLE IF EXISTS ${TransportTypesTable.tableName}');

    await _onCreate(db, newVersion);
  }


  /// Faz os inserts nas tabelas Experiences e TransportTypes com os valores dos enums
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
