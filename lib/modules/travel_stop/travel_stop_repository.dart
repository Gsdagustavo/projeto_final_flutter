import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

import '../../data/local/database/database.dart';
import '../../data/local/database/tables/addresses_table.dart';
import '../../data/local/database/tables/experiences_table.dart';
import '../../data/local/database/tables/places_table.dart';
import '../../data/local/database/tables/travel_stop_experiences_table.dart';
import '../../data/local/database/tables/travel_stop_table.dart';
import '../../data/models/address_model.dart';
import '../../data/models/place_model.dart';
import '../../data/models/travel_stop_model.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/travel_stop.dart';

abstract interface class TravelStopRepository {
  Future<void> registerTravelStops({
    required Iterable<TravelStop> stops,
    required int travelId,
  });

  Future<List<TravelStopModel>?> getTravelStops();
}

final class TravelStopRepositoryImpl implements TravelStopRepository {
  late final Future<Database> _db = DBConnection().getDatabase();

  @override
  Future<void> registerTravelStops({
    required Iterable<TravelStop> stops,
    required int travelId,
  }) async {
    final db = await _db;


  }

  @override
  Future<List<TravelStopModel>?> getTravelStops() async {
    final db = await _db;

    final stopsList = <TravelStopModel>[];

    await db.transaction((txn) async {
      final stopsMap = await txn.query(TravelStopTable.tableName);

      for (final stopMap in stopsMap) {
        final stopId = stopMap[TravelStopTable.travelStopId];
        final placeId = stopMap[TravelStopTable.placeId];

        if (stopId == null || placeId == null) return;

        final experiences = <Experience>[];
        final experiencesMap = await txn.query(
          TravelStopExperiencesTable.tableName,
          where: '${TravelStopExperiencesTable.travelStopId} = ?',
          whereArgs: [stopId],
        );

        for (final experienceMap in experiencesMap) {
          final name = experienceMap[ExperiencesTable.experience] as String;
          experiences.add(Experience.values.byName(name));
        }

        final placeMap = await txn.query(
          PlacesTable.tableName,
          where: '${PlacesTable.placeId} = ?',
          whereArgs: [placeId],
        );

        if (placeMap.isEmpty) continue;

        final placeData = placeMap.first;
        final addressId = placeData[PlacesTable.addressId];

        final addressMap = await txn.query(
          AddressesTable.tableName,
          where: '${AddressesTable.addressId} = ?',
          whereArgs: [addressId],
        );

        if (addressMap.isEmpty) continue;

        final addressModel = AddressModel.fromMap(addressMap.first);
        final placeModel = PlaceModel.toMap(placeData, addressModel);

        final travelStopModel = TravelStopModel.fromMap(
          stopMap,
          experiences,
          placeModel,
        );

        stopsList.add(travelStopModel);
      }
    });

    return stopsList;
  }
}
