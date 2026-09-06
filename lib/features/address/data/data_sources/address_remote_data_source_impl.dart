import 'package:flower_app/features/address/api/address_api_client.dart';
import 'package:flower_app/features/address/data/data_sources/address_remote_data_source.dart';
import 'package:flower_app/features/address/data/models/add_address_request.dart';
import 'package:flower_app/features/address/data/models/add_address_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AddressRemoteDataSource)
class AddressRemoteDataSourceImpl implements AddressRemoteDataSource {
  final AddressApiClient addressApiClient;

  AddressRemoteDataSourceImpl({required this.addressApiClient});

  @override
  Future<AddressResponse> getAddresses() {
    return addressApiClient.getAddresses();
  }

  @override
  Future<AddressResponse> createAddress(AddAddressRequest request) {
    return addressApiClient.createAddress(request);
  }

  @override
  Future<void> deleteAddress(String id) {
    return addressApiClient.deleteAddress(id);
  }

  @override
  Future<AddressResponse> addressDetails(String id) {
    return addressApiClient.addressDetails(id);
  }

  @override
  Future<void> updateAddress(String id, AddAddressRequest request) {
    return addressApiClient.updateAddress(id, request);
  }
}
