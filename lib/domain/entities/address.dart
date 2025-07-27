class Address {
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

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      tourism: json['tourism'] ?? '',
      houseNumber: json['house_number'] is int
          ? json['house_number']
          : int.tryParse(json['house_number']?.toString() ?? ''),
      road: json['road'],
      city: json['city'] ?? '',
      county: json['county'],
      state: json['state'] ?? '',
      ISO3166: json['ISO3166-2-lvl4'],
      postcode: json['postcode'],
      country: json['country'] ?? '',
      countryCode: json['country_code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tourism': tourism,
      'house_number': houseNumber,
      'road': road,
      'city': city,
      'county': county,
      'state': state,
      'ISO3166-2-lvl4': ISO3166,
      'postcode': postcode,
      'country': country,
      'country_code': countryCode,
    };
  }
}
