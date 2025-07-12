import 'package:sqflite/sqflite.dart';

import '../../../../domain/entities/enums.dart';
import '../tables/experiences_table.dart';
import '../tables/transport_types_table.dart';

/// Contains an util method to manipulate the experiences table in the database
class DatabaseEnumUtils {
  /// Queries the database and returns the [experience id] of the given [Experience]
  Future<int?> getIdByExperience(
    Experience exp,
    DatabaseExecutor executor,
  ) async {
    final res = await executor.query(
      ExperiencesTable.tableName,
      where: '${ExperiencesTable.name} = ?',
      whereArgs: [exp.name],
      columns: [ExperiencesTable.experienceId],
    );

    if (res.isEmpty) return null;
    return res.first[ExperiencesTable.experienceId] as int;
  }

  /// Queries the database and returns the [experience id] of the given [Experience]
  Future<int?> getIdByTransportType(
    TransportType tt,
    DatabaseExecutor executor,
  ) async {
    final res = await executor.query(
      TransportTypesTable.tableName,
      where: '${TransportTypesTable.name} = ?',
      whereArgs: [tt.name],
      columns: [TransportTypesTable.id],
    );

    if (res.isEmpty) return null;
    return res.first[TransportTypesTable.id] as int;
  }
}
