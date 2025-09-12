/// SQLite table schema and constants for the `places` table.
///
/// This class defines the column names and the SQL statement
/// to create the table.
abstract final class PlacesTable {
  /// Name of the places table in the database
  static const String tableName = 'places';

  /// Column name for the Place ID
  ///
  /// `TEXT PRIMARY KEY`
  static const String placeId = 'placeId';

  /// Column name for the city
  ///
  /// `TEXT`
  static const String city = 'city';

  /// Column name for the state
  ///
  /// `TEXT`
  static const String state = 'state';

  /// Column name for the country
  ///
  /// `TEXT`
  static const String country = 'country';

  /// Column name for the country code
  ///
  /// `TEXT`
  static const String countryCode = 'countryCode';

  /// Column name for the latitude
  ///
  /// `DECIMAL NOT NULL`
  static const String latitude = 'latitude';

  /// Column name for the longitude
  ///
  /// `DECIMAL NOT NULL`
  static const String longitude = 'longitude';

  /// SQL command to create the places table
  static const String createTable =
      '''
      CREATE TABLE $tableName(
        $placeId TEXT PRIMARY KEY, 
        $city TEXT,
        $state TEXT,
        $country TEXT,
        $countryCode TEXT,
        $latitude DECIMAL NOT NULL,
        $longitude DECIMAL NOT NULL
      )
      ''';
}
