import 'package:flower_app/features/profile/data/models/profile_response.dart';
import 'package:flower_app/features/profile/data/models/update_profile_request.dart';

abstract interface class ProfileRemoteDataSource {
  Future<ProfileResponse> getMyProfile();

  Future<ProfileResponse> updateMyProfile(UpdateProfileRequest request);
}
