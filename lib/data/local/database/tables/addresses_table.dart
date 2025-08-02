abstract final class AddressesTable {
  static const String tableName = 'addresses';
  static const String addressId = 'addressId';
  static const String tourism = 'tourism';
  static const String houseNumber = 'houseNumber';
  static const String road = 'road';
  static const String town = 'town';
  static const String state = 'state';
  static const String postcode = 'postcode';
  static const String country = 'country';
  static const String countryCode = 'countryCode';

  static const String createTable =
      '''
      CREATE TABLE $tableName(
        $addressId INTEGER NOT NULL PRIMARY KEY,
        $tourism TEXT,
        $houseNumber INTEGER,
        $road TEXT,
        $town TEXT NOT NULL,
        $state TEXT NOT NULL,
        $postcode TEXT,
        $country TEXT NOT NULL,
        $countryCode TEXT NOT NULL
      )
      ''';
}
