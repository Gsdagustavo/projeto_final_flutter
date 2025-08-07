abstract final class PlacesTable {
  static const String tableName = 'places';

  static const String placeId = 'placeId';
  static const String city = 'city';
  static const String state = 'state';
  static const String country = 'country';
  static const String countryCode = 'countryCode';
  static const String latitude = 'latitude';
  static const String longitude = 'longitude';

  static const String createTable =
      '''
      CREATE TABLE $tableName(
        $placeId INTEGER PRIMARY KEY AUTOINCREMENT, 
        $city TEXT,
        $state TEXT,
        $country TEXT,
        $countryCode TEXT,
        $latitude DECIMAL NOT NULL,
        $longitude DECIMAL NOT NULL
      )
      ''';
}
