class Address {
  int? addressId;
  String? tourism;
  int? houseNumber;
  String? road;
  final String town;
  final String state;
  final String country;
  final String countryCode;

  Address({
    this.addressId,
    required this.tourism,
    this.houseNumber,
    this.road,
    required this.town,
    required this.state,
    required this.country,
    required this.countryCode,
  });
}
