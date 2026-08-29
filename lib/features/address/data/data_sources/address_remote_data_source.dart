import 'package:flower_app/features/address/data/models/add_address_request.dart';
import 'package:flower_app/features/address/data/models/add_address_response.dart';

abstract interface class AddressRemoteDataSource {
  Future<AddressResponse> getAddresses();

  Future<AddressResponse> addAddress(AddAddressRequest request);

  Future<void> deleteAddress(String id);
}
