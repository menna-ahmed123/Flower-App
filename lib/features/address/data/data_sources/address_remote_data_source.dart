import 'package:flower_app/features/address/data/models/add_address_request.dart';
import 'package:flower_app/features/address/data/models/add_address_response.dart';

abstract interface class AddressRemoteDataSource {
  Future<AddressResponse> getAddresses();
  Future<AddressResponse> createAddress(AddAddressRequest request);
  Future<void> deleteAddress(String id);
  Future<void> updateAddress(String id, AddAddressRequest request);
  Future<AddressResponse> addressDetails(String id);
}
