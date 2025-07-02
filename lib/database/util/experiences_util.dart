import 'package:sqflite/sqflite.dart';

import '../../entities/enums.dart';
import '../database.dart';
import '../tables/experiences_table.dart';

class ExperiencesUtil {
  static Future<int?> getIdByExperienceName(Experience exp, DatabaseExecutor executor) async {
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
