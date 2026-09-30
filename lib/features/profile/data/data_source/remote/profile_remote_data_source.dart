import 'package:flower_app/core/base/api_response.dart';
import 'package:flower_app/features/profile/data/models/profile_model.dart';
import 'package:flower_app/features/profile/data/models/update_profile_request.dart';

abstract interface class ProfileRemoteDataSource {
  Future<ApiResponse<ProfileModel>> getMyProfile();

  Future<ApiResponse<ProfileModel>> updateMyProfile({
    required UpdateProfileRequest updateProfileRequest,
  });
}
