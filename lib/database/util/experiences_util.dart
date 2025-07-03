import 'package:sqflite/sqflite.dart';

import '../../entities/enums.dart';
import '../tables/experiences_table.dart';

/// Contains an util method to manipulate the experiences table in the database
class ExperiencesUtil {
  /// Queries the database and returns the [experience id] of the given [Experience]
  Future<int?> getIdByExperienceName(
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
}
