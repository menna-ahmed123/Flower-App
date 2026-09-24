import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/constants/api_query_params.dart';
import '../data/models/response/session_response.dart';

part 'session_api_client.g.dart';

@RestApi()
abstract class SessionApiClient {
  factory SessionApiClient(Dio dio, {String baseUrl}) = _SessionApiClient;

  @GET(ApiEndpoints.session)
  Future<SessionResponse> getSessions();

  @DELETE(ApiEndpoints.sessionById)
  Future<void> revokeSession(@Path(ApiQueryParams.sessionId) String sessionId);
}