import 'package:flower_app/features/profile/data/models/profile_response.dart';

abstract interface class ProfileRemoteDataSource {
  Future<ProfileResponse> getMyProfile();
}
