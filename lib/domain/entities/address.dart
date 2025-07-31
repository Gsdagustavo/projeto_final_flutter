class Address {
  int? addressId;
  final String tourism;
  int? houseNumber;
  String? road;
  final String city;
  String? county;
  final String state;
  String? ISO3166;
  String? postcode;
  final String country;
  final String countryCode;

  Address({
    this.addressId,
    required this.tourism,
    this.houseNumber,
    this.road,
    required this.city,
    this.county,
    required this.state,
    this.ISO3166,
    this.postcode,
    required this.country,
    required this.countryCode,
  });
}
