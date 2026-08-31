import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'address_api_client.g.dart';

@RestApi()
abstract class AddressApiClient {
  factory AddressApiClient(Dio dio, {String baseUrl}) = _AddressApiClient;

}
