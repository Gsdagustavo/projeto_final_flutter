abstract final class AddressesTable {
  static const String tableName = 'addresses';
  static const String addressId = 'addressId';
  static const String tourism = 'tourism';
  static const String houseNumber = 'houseNumber';
  static const String road = 'road';
  static const String city = 'city';
  static const String county = 'county';
  static const String state = 'state';
  static const String ISO3166 = 'ISO3166';
  static const String postcode = 'postcode';
  static const String country = 'country';
  static const String countryCode = 'countryCode';

  static const String createTable =
      '''
      CREATE TABLE $tableName(
        $addressId INTEGER NOT NULL PRIMARY KEY,
        $tourism TEXT NOT NULL,
        $houseNumber INTEGER,
        $road TEXT,
        $city TEXT NOT NULL,
        $county TEXT,
        $state TEXT NOT NULL,
        $ISO3166 TEXT,
        $postcode TEXT,
        $country TEXT NOT NULL,
        $countryCode TEXT NOT NULL
      )
      ''';
}
