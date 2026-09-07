import 'package:dio/dio.dart';
import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flower_app/core/constants/api_query_params.dart';
import 'package:flower_app/features/address/data/models/add_address_request.dart';
import 'package:flower_app/features/address/data/models/add_address_response.dart';
import 'package:retrofit/retrofit.dart';

part 'address_api_client.g.dart';

@RestApi()
abstract class AddressApiClient {
  factory AddressApiClient(Dio dio, {String baseUrl}) = _AddressApiClient;

  @POST(ApiEndpoints.addAddress)
  Future<AddressResponse> createAddress(@Body() AddAddressRequest request);

  @GET(ApiEndpoints.addressById)
  Future<AddressResponse> addressDetails(@Path(ApiQueryParams.id) String id);

  @GET(ApiEndpoints.addAddress)
  Future<AddressResponse> getAddresses();

  @DELETE(ApiEndpoints.addressById)
  Future<void> deleteAddress(@Path(ApiQueryParams.id) String id);

  @PUT(ApiEndpoints.addressById)
  Future<void> updateAddress(
    @Path(ApiQueryParams.id) String id,
    @Body() AddAddressRequest request,
  );
}
