import 'package:dio/dio.dart';
import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flower_app/core/constants/api_query_params.dart';
import 'package:flower_app/features/address/data/models/add_address_request.dart';
import 'package:flower_app/features/address/data/models/add_address_response.dart';
import 'package:flower_app/features/address/data/models/city_response.dart';
import 'package:flower_app/features/address/data/models/country_response.dart';
import 'package:flower_app/features/address/data/models/governorate_response.dart';
import 'package:flower_app/features/address/data/models/reverse_geocoding_response.dart';
import 'package:retrofit/retrofit.dart';

part 'address_api_client.g.dart';

@RestApi()
abstract class AddressApiClient {
  factory AddressApiClient(Dio dio, {String baseUrl}) = _AddressApiClient;

  @POST(ApiEndpoints.addAddress)
  Future<AddressResponse> createAddress(@Body() AddAddressRequest request);

  @GET(ApiEndpoints.addressById)
  Future<AddressResponse> addressDetails(@Path(ApiQueryParams.id) String id);

  @GET(ApiEndpoints.getAddress)
  Future<AddressResponse> getAddresses();

  @DELETE(ApiEndpoints.addressById)
  Future<void> deleteAddress(@Path(ApiQueryParams.id) String id);

  @PUT(ApiEndpoints.addressById)
  Future<AddressResponse> updateAddress(
    @Path(ApiQueryParams.id) String id,
    @Body() AddAddressRequest request,
  );

  @PATCH(ApiEndpoints.setDefaultAddress)
  Future<AddressResponse> setDefaultAddress(
    @Path(ApiQueryParams.addressId) String addressId,
  );

  @GET(ApiEndpoints.getCountries)
  Future<CountryResponse> getCountries();

  @GET(ApiEndpoints.getGovernorates)
  Future<GovernorateResponse> getGovernorates();

  @GET(ApiEndpoints.getCities)
  Future<CityResponse> getCities(
    @Path('governorateId') int governorateId,
  );

  @GET(ApiEndpoints.reverseGeocode)
  Future<ReverseGeocodingResponse> reverseGeocode(
    @Query('lat') double lat,
    @Query('lng') double lng,
  );
}
