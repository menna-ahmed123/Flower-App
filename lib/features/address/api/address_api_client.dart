import 'package:dio/dio.dart';
import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flower_app/features/address/data/models/add_address_request.dart';
import 'package:flower_app/features/address/data/models/add_address_response.dart';
import 'package:retrofit/retrofit.dart';

part 'address_api_client.g.dart';
@RestApi()
abstract class AddressApiClient {
  factory AddressApiClient(Dio dio, {String baseUrl}) = _AddressApiClient;

  @GET(ApiEndpoints.addAddress)
  Future<AddressResponse> getAddresses();

  @POST(ApiEndpoints.addAddress)
  Future<AddressResponse> addAddress(@Body() AddAddressRequest request);

  @DELETE(ApiEndpoints.addressById)
  Future<void> deleteAddress(@Path('id') String id);
}
