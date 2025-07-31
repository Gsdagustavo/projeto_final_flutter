import '../../domain/entities/address.dart';
import '../local/database/tables/addresses_table.dart';

class AddressModel {
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

  AddressModel({
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

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
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

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      addressId: map[AddressesTable.addressId],
      tourism: map[AddressesTable.tourism] ?? '',
      houseNumber: map[AddressesTable.houseNumber],
      road: map[AddressesTable.road],
      city: map[AddressesTable.city] ?? '',
      county: map[AddressesTable.county],
      state: map[AddressesTable.state] ?? '',
      ISO3166: map[AddressesTable.ISO3166],
      postcode: map[AddressesTable.postcode],
      country: map[AddressesTable.country] ?? '',
      countryCode: map[AddressesTable.countryCode] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      AddressesTable.addressId: addressId,
      AddressesTable.tourism: tourism,
      AddressesTable.houseNumber: houseNumber,
      AddressesTable.road: road,
      AddressesTable.city: city,
      AddressesTable.county: county,
      AddressesTable.state: state,
      AddressesTable.ISO3166: ISO3166,
      AddressesTable.postcode: postcode,
      AddressesTable.country: country,
      AddressesTable.countryCode: countryCode,
    };
  }

  factory AddressModel.fromEntity(Address entity) {
    return AddressModel(
      addressId: entity.addressId,
      tourism: entity.tourism,
      houseNumber: entity.houseNumber,
      road: entity.road,
      city: entity.city,
      county: entity.county,
      state: entity.state,
      ISO3166: entity.ISO3166,
      postcode: entity.postcode,
      country: entity.country,
      countryCode: entity.countryCode,
    );
  }

  Address toEntity() {
    return Address(
      addressId: addressId,
      tourism: tourism,
      houseNumber: houseNumber,
      road: road,
      city: city,
      county: county,
      state: state,
      ISO3166: ISO3166,
      postcode: postcode,
      country: country,
      countryCode: countryCode,
    );
  }

  @override
  String toString() {
    return 'AddressModel{addressId: $addressId, tourism: $tourism, houseNumber: $houseNumber, road: $road, city: $city, county: $county, state: $state, ISO3166: $ISO3166, postcode: $postcode, country: $country, countryCode: $countryCode}';
  }
}
