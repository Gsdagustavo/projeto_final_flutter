import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBConnection {
  static const String dbName = 'traveldb';
  static const int dbVersion = 1;

  Future<Database> getDatabase() async {
    final dbPath = join(await getDatabasesPath(), dbName);

    return openDatabase(dbPath, onCreate: (db, version) {});
  }
}
