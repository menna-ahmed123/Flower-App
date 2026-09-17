import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/network/safe_call.dart';
import 'package:flower_app/features/profile/data/data_source/remote/profile_remote_data_source.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flower_app/features/profile/domain/repo/profile_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ProfileRepo)
class ProfileRepoImpl implements ProfileRepo {
  final ProfileRemoteDataSource remoteDataSource;
  final SafeCall safeCall;

  ProfileRepoImpl(this.remoteDataSource, this.safeCall);

  @override
  Future<BaseResponse<ProfileEntity>> getMyProfile() {
    return safeCall.safeApiCall(() async {
      final response = await remoteDataSource.getMyProfile();
      return response.data.toDomain();
    });
  }
}
