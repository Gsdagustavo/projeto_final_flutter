import '../../domain/entities/address.dart';
import '../local/database/tables/addresses_table.dart';

class AddressModel {
  int? addressId;
  String? tourism;
  int? houseNumber;
  String? road;
  final String town;
  final String state;
  final String country;
  final String countryCode;

  AddressModel({
    this.addressId,
    required this.tourism,
    this.houseNumber,
    this.road,
    required this.town,
    required this.state,
    required this.country,
    required this.countryCode,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      town: json['town'] ?? '',
      tourism: json['tourism'] ?? '',
      houseNumber: json['house_number'] is int
          ? json['house_number']
          : int.tryParse(json['house_number']?.toString() ?? ''),
      road: json['road'],
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      countryCode: json['country_code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tourism': tourism,
      'house_number': houseNumber,
      'road': road,
      'state': state,
      'country': country,
      'country_code': countryCode,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      town: map[AddressesTable.town],
      addressId: map[AddressesTable.addressId],
      tourism: map[AddressesTable.tourism] ?? '',
      houseNumber: map[AddressesTable.houseNumber],
      road: map[AddressesTable.road],
      state: map[AddressesTable.state] ?? '',
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
      AddressesTable.state: state,
      AddressesTable.country: country,
      AddressesTable.countryCode: countryCode,
      AddressesTable.town: town
    };
  }

  factory AddressModel.fromEntity(Address entity) {
    return AddressModel(
      addressId: entity.addressId,
      tourism: entity.tourism,
      houseNumber: entity.houseNumber,
      road: entity.road,
      state: entity.state,
      country: entity.country,
      countryCode: entity.countryCode,
      town: AddressesTable.town
    );
  }

  Address toEntity() {
    return Address(
      town: town,
      addressId: addressId,
      tourism: tourism,
      houseNumber: houseNumber,
      road: road,
      state: state,
      country: country,
      countryCode: countryCode,
    );
  }
}
