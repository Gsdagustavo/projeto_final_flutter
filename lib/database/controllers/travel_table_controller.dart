import '../../entities/travel.dart';
import '../database.dart';
import '../tables/participants_table.dart';
import '../tables/travel_experiences.dart';
import '../tables/travel_participants_table.dart';
import '../tables/travel_stop_experiences_table.dart';
import '../tables/travel_stop_table.dart';
import '../tables/travel_table.dart';
import '../util/experiences_util.dart';

/// Contains methods to manipulate the travel database
class TravelTableController {
  /// Returns
  Future<List<Map<String, dynamic>>> select() async {
    final db = await DBConnection().getDatabase();

    final res = await db.query(TravelTable.tableName);
    return res;
  }

  /// Inserts a [Travel] into the database
  Future<void> insert(Travel travel) async {
    final db = await DBConnection().getDatabase();

    await db.transaction((txn) async {
      /// insert data into Travel table
      final travelData = {
        TravelTable.travelTitle: travel.travelTitle,
        TravelTable.transportType: travel.transportType.name,
        TravelTable.startTime: travel.startTime.millisecondsSinceEpoch,
        TravelTable.endTime: travel.endTime.millisecondsSinceEpoch,
      };

      final travelId = await txn.insert(TravelTable.tableName, travelData);

      /// Insert travel experiences into travel experiences table
      for (final exp in travel.experiences) {
        final expId = await ExperiencesUtil().getIdByExperienceName(exp, txn);

        final travelExperiencesData = {
          TravelExperiencesTable.travelId: travelId,
          TravelExperiencesTable.experienceId: expId,
        };

        await txn.insert(
          TravelExperiencesTable.tableName,
          travelExperiencesData,
        );
      }

      /// Insert travel stops in travel stops table
      for (final stop in travel.stops) {
        final stopData = {
          TravelStopTable.travelId: travelId,
          TravelStopTable.arriveDate: stop.arriveDate.millisecondsSinceEpoch,
          TravelStopTable.leaveDate: stop.leaveDate.millisecondsSinceEpoch,
          TravelStopTable.latitude: stop.latitude,
          TravelStopTable.longitude: stop.longitude,
          TravelStopTable.cityName: stop.cityName,
          TravelStopTable.stayingTime: stop.stayingTime.inSeconds,
        };

        final stopId = await txn.insert(TravelStopTable.tableName, stopData);

        /// Insert experiences into travel stop experiences table
        for (final exp in stop.experiences) {
          final expId = await ExperiencesUtil().getIdByExperienceName(exp, txn);

          final stopExpData = {
            TravelStopExperiencesTable.experienceId: expId,
            TravelStopExperiencesTable.travelStopId: stopId,
          };

          await txn.insert(TravelStopExperiencesTable.tableName, stopExpData);
        }
      }

      /// Insert into Participants table
      for (final participant in travel.participants) {
        final participantData = {
          ParticipantsTable.name: participant.name,
          ParticipantsTable.age: participant.age,
          ParticipantsTable.profilePictureUrl: participant.profilePictureUrl,
        };

        final participantId = await txn.insert(
          ParticipantsTable.tableName,
          participantData,
        );

        final participantTravelData = {
          TravelParticipantsTable.participantId: participantId,
          TravelParticipantsTable.travelId: travelId,
        };

        await txn.insert(
          TravelParticipantsTable.tableName,
          participantTravelData,
        );
      }
    });
  }
}
