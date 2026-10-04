import 'package:flower_app/features/address/data/models/add_address_request.dart';
import 'package:flower_app/features/address/data/models/add_address_response.dart';
import 'package:flower_app/features/address/data/models/city_response.dart';
import 'package:flower_app/features/address/data/models/country_response.dart';
import 'package:flower_app/features/address/data/models/governorate_response.dart';
import 'package:flower_app/features/address/data/models/reverse_geocoding_response.dart';

abstract interface class AddressRemoteDataSource {
  Future<AddressResponse> getAddresses();
  Future<AddressResponse> createAddress(AddAddressRequest request);
  Future<void> deleteAddress(String id);
  Future<AddressResponse> updateAddress(String id, AddAddressRequest request);
  Future<AddressResponse> addressDetails(String id);
  Future<AddressResponse> setDefaultAddress(String addressId);
  Future<CountryResponse> getCountries();
  Future<GovernorateResponse> getGovernorates();
  Future<CityResponse> getCities(int governorateId);
  Future<ReverseGeocodingResponse> reverseGeocode(double lat, double lng);
}
