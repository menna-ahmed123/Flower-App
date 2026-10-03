import 'package:dio/dio.dart';
import 'package:flower_app/core/base/api_response.dart';
import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flower_app/core/constants/api_request_params.dart';
import 'package:flower_app/features/profile/data/models/profile_model.dart';
import 'package:retrofit/retrofit.dart';

part 'profile_api_client.g.dart';

@RestApi()
abstract class ProfileApiClient {
  factory ProfileApiClient(Dio dio, {String baseUrl}) = _ProfileApiClient;

  @GET(ApiEndpoints.getMyProfile)
  Future<ApiResponse<ProfileModel>> getMyProfile();

  @MultiPart()
  @PUT(ApiEndpoints.updateProfile)
  Future<ApiResponse<ProfileModel>> updateMyProfile(
    @Part(name: ApiRequestParams.firstName) String firstName,
    @Part(name: ApiRequestParams.lastName) String lastName,
    @Part(name: ApiRequestParams.phoneNumber) String phoneNumber,
    @Part(name: ApiRequestParams.gender) String gender,
    @Part(name: ApiRequestParams.profilePicture) MultipartFile? profilePicture,
  );
}
