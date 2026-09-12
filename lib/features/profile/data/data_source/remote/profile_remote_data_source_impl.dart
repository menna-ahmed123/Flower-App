import 'package:flower_app/features/profile/data/api/profile_api_client.dart';
import 'package:flower_app/features/profile/data/data_source/remote/profile_remote_data_source.dart';
import 'package:flower_app/features/profile/data/models/profile_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ProfileApiClient profileApiClient;

  ProfileRemoteDataSourceImpl(this.profileApiClient);

  @override
  Future<ProfileResponse> getMyProfile() {
    return profileApiClient.getMyProfile();
  }
}
