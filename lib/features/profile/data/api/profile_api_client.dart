import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flower_app/features/profile/data/models/profile_response.dart';
import 'package:retrofit/retrofit.dart';

part 'profile_api_client.g.dart';

@RestApi()
abstract class ProfileApiClient {
  factory ProfileApiClient(Dio dio, {String baseUrl}) = _ProfileApiClient;

  @GET(ApiEndpoints.myProfile)
  Future<ProfileResponse> getMyProfile();

  @PUT(ApiEndpoints.myProfile)
  @MultiPart()
  Future<ProfileResponse> updateMyProfile(
    @Part(name: 'fullName') String fullName,
    @Part(name: 'email') String email,
    @Part(name: 'phoneNumber') String phoneNumber,
    @Part(name: 'gender') String gender,
    @Part(name: 'profilePicture') File? profilePicture,
  );
}
