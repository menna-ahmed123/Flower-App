import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flower_app/core/constants/api_request_params.dart';
import 'package:flower_app/features/profile/data/models/profile_response.dart';
import 'package:retrofit/retrofit.dart';

part 'profile_api_client.g.dart';

@RestApi()
abstract class ProfileApiClient {
  factory ProfileApiClient(Dio dio, {String baseUrl}) = _ProfileApiClient;

  @GET(ApiEndpoints.myProfile)
  Future<ProfileResponse> getMyProfile();

  @MultiPart()
  @PUT(ApiEndpoints.myProfile)
  Future<ProfileResponse> updateMyProfile(
    @Part(name: ApiRequestParams.firstName) String firstName,
    @Part(name: ApiRequestParams.lastName) String lastName,
    @Part(name: ApiRequestParams.email) String? email,
    @Part(name: ApiRequestParams.phoneNumber) String? phoneNumber,
    @Part(name: ApiRequestParams.gender) String? gender,
    @Part(name: ApiRequestParams.profilePicture) File? profilePicture,
  );
}
