import 'addresses_table.dart';

abstract final class PlacesTable {
  static const String tableName = 'places';

  static const String placeId = 'placeId';
  static const String osmType = 'osmType';
  static const String lat = 'lat';
  static const String lon = 'lon';
  static const String category = 'category';
  static const String type = 'type';
  static const String placeRank = 'placeRank';
  static const String addresstype = 'addresstype';
  static const String name = 'name';
  static const String displayName = 'displayName';
  static const String addressId = 'addressId';

  static const String createTable =
      '''
      CREATE TABLE $tableName(
        $placeId INTEGER NOT NULL,
        $osmType TEXT NOT NULL,
        $lat DECIMAL NOT NULL,
        $lon DECIMAL NOT NULL,
        $category TEXT NOT NULL,
        $type TEXT NOT NULL,
        $placeRank TEXT NOT NULL,
        $addresstype TEXT NOT NULL,
        $name TEXT NOT NULL,
        $displayName TEXT NOT NULL,
        $addressId INTEGER NOT NULL,
        
        FOREIGN KEY ($addressId) REFERENCES ${AddressesTable.tableName}(${AddressesTable.addressId})
      )
      ''';
}
