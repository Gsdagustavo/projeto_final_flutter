import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

import '../../data/local/database/database.dart';
import '../../data/local/database/tables/experiences_table.dart';
import '../../data/local/database/tables/participants_table.dart';
import '../../data/local/database/tables/photos_table.dart';
import '../../data/local/database/tables/places_table.dart';
import '../../data/local/database/tables/reviews_table.dart';
import '../../data/local/database/tables/travel_stop_experiences_table.dart';
import '../../data/local/database/tables/travel_stop_table.dart';
import '../../data/local/database/tables/travel_table.dart';
import '../../data/local/database/tables/travel_travel_status_table.dart';
import '../../data/models/participant_model.dart';
import '../../data/models/place_model.dart';
import '../../data/models/travel_model.dart';
import '../../data/models/travel_stop_model.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/travel.dart';

/// This interface defines all necessary methods to register a [Travel]
/// and get all [Travels]
abstract class TravelRepository {
  /// Register a new travel
  ///
  /// [travel]: The travel which will be registered
  Future<void> registerTravel({required Travel travel});

  Future<void> deleteTravel(Travel travel);

  /// Returns a [List] of [Travel] containing all registered travels
  Future<List<Travel>> getAllTravels();

  Future<void> startTravel(Travel travel);

  Future<void> finishTravel(Travel travel);

  Future<void> updateTravelTitle(Travel travel);
}

/// Concrete implementation of [TravelRepository], using local SQLite database
///
/// This class realizes all necessary implementations to register a [Travel]
/// and get all [Travels], consulting the [TravelTable], [TravelStopTable],
/// [TravelStopExperiencesTable] and [ParticipantsTable] tables
class TravelRepositoryImpl implements TravelRepository {
  late final Future<Database> _db = DBConnection().getDatabase();

  @override
  Future<void> registerTravel({required Travel travel}) async {
    final db = await _db;

    final travelModel = TravelModel(
      travelTitle: travel.travelTitle,
      startDate: travel.startDate,
      endDate: travel.endDate,
      transportType: travel.transportType,
      participants: travel.participants
          .map(ParticipantModel.fromEntity)
          .toList(),
      stops: travel.stops.map(TravelStopModel.fromEntity).toList(),
      photos: travel.photos,
    );

    await db.transaction((txn) async {
      final travelId = travelModel.id;

      await txn.insert(TravelTable.tableName, travelModel.toMap());

      final stops = travelModel.stops;

      /// Stops related inserts
      ///
      /// Inserts values into [TravelStopTable], [TravelStopExperiencesTable],
      /// [PlacesTable] and[AddressesTable]
      for (final stop in stops) {
        await _insertStop(txn, stop, travelId);
      }

      /// Insert participants into [ParticipantsTable]
      for (final participant in travelModel.participants) {
        final participantData = await participant.toMap();
        participantData.addAll({ParticipantsTable.travelId: travelId});
        await txn.insert(ParticipantsTable.tableName, participantData);
      }

      /// Insert into [Photos] table
      if (travelModel.photos.isNotEmpty) {
        for (final photoData in travelModel.photos) {
          final photoMap = {
            PhotosTable.photo: photoData?.readAsBytesSync(),
            PhotosTable.travelId: travelId,
          };

          await txn.insert(PhotosTable.tableName, photoMap);
        }
      }

      /// Insert into [TravelTravelStatus] table
      await txn.insert(TravelTravelStatusTable.tableName, {
        TravelTravelStatusTable.travelStatusIndex: travel.status.index,
        TravelTravelStatusTable.travelId: travel.id,
      });
    });
  }

  @override
  Future<void> deleteTravel(Travel travel) async {
    final db = await _db;

    await db.transaction((txn) async {
      final travelModel = TravelModel.fromEntity(travel);

      /// Delete from [Travels] table
      await txn.delete(
        TravelTable.tableName,
        where: '${TravelTable.travelId} = ?',
        whereArgs: [travelModel.id],
      );

      /// Delete from [Participants] table
      await txn.delete(
        ParticipantsTable.tableName,
        where: '${ParticipantsTable.travelId} = ?',
        whereArgs: [travelModel.id],
      );

      /// Delete from [TravelStops] table
      await txn.delete(
        TravelStopTable.tableName,
        where: '${TravelStopTable.travelId} = ?',
        whereArgs: [travelModel.id],
      );

      /// Delete from [Reviews] table
      for (final stop in travelModel.stops) {
        if (stop.reviews != null && stop.reviews!.isNotEmpty) {
          await txn.delete(
            ReviewsTable.tableName,
            where: '${ReviewsTable.travelStopId} = ?',
            whereArgs: [stop.id],
          );
        }
      }

      /// Delete from [TravelStopExperiences] table
      await txn.delete(
        TravelStopExperiencesTable.tableName,
        where: '${TravelStopExperiencesTable.travelStopId} = ?',
        whereArgs: [travelModel.id],
      );

      /// Delete from [Photos] table
      await txn.delete(
        PhotosTable.tableName,
        where: '${PhotosTable.travelId} = ?',
        whereArgs: [travelModel.id],
      );

      /// Delete from [TravelTravelStatus] table
      await txn.delete(
        TravelTravelStatusTable.tableName,
        where: '${TravelTravelStatusTable.travelId} = ?',
        whereArgs: [travelModel.id],
      );
    });
  }

  @override
  Future<void> startTravel(Travel travel) async {
    final db = await _db;

    await db.transaction((txn) async {
      final travelModel = TravelModel.fromEntity(travel);

      await txn.update(
        TravelTable.tableName,
        travelModel.toMap(),
        where: '${TravelTable.travelId} = ?',
        whereArgs: [travelModel.id],
      );

      await txn.update(
        TravelTravelStatusTable.tableName,
        _toTravelTravelStatusMap(travelModel.id, travel.status.index),
        where: '${TravelTravelStatusTable.travelId} = ?',
        whereArgs: [travelModel.id],
      );
    });
  }

  @override
  Future<void> finishTravel(Travel travel) async {
    final db = await _db;

    await db.transaction((txn) async {
      final travelModel = TravelModel.fromEntity(travel);

      await txn.update(
        TravelTable.tableName,
        travelModel.toMap(),
        where: '${TravelTable.travelId} = ?',
        whereArgs: [travelModel.id],
      );

      await txn.update(
        TravelTravelStatusTable.tableName,
        _toTravelTravelStatusMap(travelModel.id, travel.status.index),
        where: '${TravelTravelStatusTable.travelId} = ?',
        whereArgs: [travelModel.id],
      );
    });
  }

  @override
  Future<void> updateTravelTitle(Travel travel) async {
    final db = await _db;

    await db.transaction((txn) async {
      final travelModel = TravelModel.fromEntity(travel);

      await txn.update(
        TravelTable.tableName,
        travelModel.toMap(),
        where: '${TravelTable.travelId} = ?',
        whereArgs: [travelModel.id],
      );
    });
  }

  Map<String, dynamic> _toTravelTravelStatusMap(
    String travelId,
    int statusIndex,
  ) {
    return {
      TravelTravelStatusTable.travelId: travelId,
      TravelTravelStatusTable.travelStatusIndex: statusIndex,
    };
  }

  Future<void> _insertStop(
    DatabaseExecutor txn,
    TravelStopModel stop,
    String travelId,
  ) async {
    final placeMap = stop.place.toMap();

    // debugPrint('Place map: $placeMap');

    /// Insert into [PlacesTable]
    await txn.insert(PlacesTable.tableName, placeMap);

    final stopMap = stop.toMap();

    // debugPrint('Stop map: $stopMap');

    stopMap[TravelStopTable.travelId] = travelId;
    stopMap[TravelStopTable.placeId] = stop.place.id;

    /// Insert stop into [TravelStopsTable]
    await txn.insert(TravelStopTable.tableName, stopMap);

    // debugPrint('Stop ID: $stopId');

    /// Insert experiences into [TravelStopExperiencesTable]
    if (stop.experiences != null && stop.experiences!.isNotEmpty) {
      for (final experience in stop.experiences!) {
        await txn.insert(TravelStopExperiencesTable.tableName, {
          TravelStopExperiencesTable.travelStopId: stop.id,
          TravelStopExperiencesTable.experienceIndex: experience.index,
        });
      }
    }

    // debugPrint('Travel stop $stop added to database');
  }

  @override
  Future<List<Travel>> getAllTravels() async {
    // debugPrint('GET ALL TRAVELS METHOD REPOSITORY CALLED');
    final db = await _db;

    final travels = <TravelModel>[];

    // final res = await db.rawQuery(
    //   'SELECT T.${TravelTable.travelId} FROM ${TravelTable.tableName} as T '
    //   'JOIN ${TravelParticipantsTable.tableName}
    //   on ${TravelTable.travelId} = ${TravelParticipantsTable.travelId} '
    //   'GROUP BY ${TravelTable.travelId}',
    // );
    //
    // debugPrint('RAW QUERY: $res');

    await db.transaction((txn) async {
      final travelsResult = await txn.query(TravelTable.tableName);

      for (final travelResult in travelsResult) {
        final travelId = travelResult[TravelTable.travelId];

        /// Participants
        final participants = <ParticipantModel>[];

        final participantsData = await txn.query(
          ParticipantsTable.tableName,
          where: '${ParticipantsTable.travelId} = ?',
          whereArgs: [travelId],
        );

        for (final participantData in participantsData) {
          final participant = ParticipantModel.fromMap(participantData);
          participants.add(participant);
        }

        /// Stops
        final stops = <TravelStopModel>[];

        final stopData = await txn.query(
          TravelStopTable.tableName,
          where: '${TravelStopTable.travelId} = ?',
          whereArgs: [travelId],
        );

        for (final stop in stopData) {
          final stopId = stop[TravelStopTable.travelStopId];
          final placeId = stop[TravelStopTable.placeId];

          if (stopId == null || placeId == null) return;

          final experiences = <Experience>[];
          final experiencesMap = await txn.query(
            TravelStopExperiencesTable.tableName,
            where: '${TravelStopExperiencesTable.travelStopId} = ?',
            whereArgs: [stopId],
          );

          for (final experienceMap in experiencesMap) {
            debugPrint(experienceMap.toString());

            final experience = Experience
                .values[experienceMap[ExperiencesTable.experienceIndex] as int];
            experiences.add(experience);
          }

          final placeMap = await txn.query(
            PlacesTable.tableName,
            where: '${PlacesTable.placeId} = ?',
            whereArgs: [placeId],
          );

          if (placeMap.isEmpty) continue;

          final placeModel = PlaceModel.fromMap(placeMap.first);

          final travelStopModel = TravelStopModel.fromMap(
            stop,
            experiences,
            [],
            placeModel,
          );

          stops.add(travelStopModel);
        }

        /// Photos
        final photos = <File>[];

        final travelPhotosData = await txn.query(
          PhotosTable.tableName,
          where: '${PhotosTable.travelId} = ?',
          whereArgs: [travelId],
        );

        for (final photoData in travelPhotosData) {
          final bytes = photoData[PhotosTable.photo] as Uint8List;

          // debugPrint(bytes.toString());

          final filename = '${photoData[PhotosTable.photoId]}.png';
          final file = File('${Directory.systemTemp.path}/$filename');
          file.writeAsBytesSync(bytes);
          photos.add(file);
        }

        travels.add(
          TravelModel.fromMap(
            travelResult,
            participants: participants,
            stops: stops,
            photos: photos,
          ),
        );
      }
    });

    // for (final travel in travels) {
    //   debugPrint('Travel: $travel');
    //
    //   for (final travelStop in travel.stops) {
    //     debugPrint('Stop: ${travelStop.toString()}');
    //   }
    // }
    return travels.map((e) => e.toEntity()).toList();
  }
}
