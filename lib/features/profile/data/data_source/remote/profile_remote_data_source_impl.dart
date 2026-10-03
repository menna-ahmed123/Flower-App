import 'package:flower_app/features/profile/data/api/profile_api_client.dart';
import 'package:dio/dio.dart';
import 'package:flower_app/features/profile/data/data_source/remote/profile_remote_data_source.dart';
import 'package:flower_app/core/base/api_response.dart';
import 'package:flower_app/features/profile/data/models/profile_model.dart';
import 'package:flower_app/features/profile/data/models/update_profile_request.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ProfileApiClient profileApiClient;

  ProfileRemoteDataSourceImpl(this.profileApiClient);

  @override
  Future<ApiResponse<ProfileModel>> getMyProfile() {
    return profileApiClient.getMyProfile();
  }

  @override
  Future<ApiResponse<ProfileModel>> updateMyProfile({
    required UpdateProfileRequest updateProfileRequest,
  }) async {
    final profilePicture = updateProfileRequest.profilePicture == null
        ? null
        : await MultipartFile.fromFile(
            updateProfileRequest.profilePicture!.path,
          );

    return profileApiClient.updateMyProfile(
      updateProfileRequest.firstName,
      updateProfileRequest.lastName,
      updateProfileRequest.phoneNumber,
      updateProfileRequest.gender.value.toString(),
      profilePicture,
    );
  }
}
