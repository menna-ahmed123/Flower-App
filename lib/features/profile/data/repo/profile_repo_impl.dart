import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/network/safe_call.dart';
import 'package:flower_app/features/profile/data/data_source/remote/profile_remote_data_source.dart';
import 'package:flower_app/features/profile/data/models/update_profile_request.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flower_app/features/profile/domain/entities/update_profile_params.dart';
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

  @override
  Future<BaseResponse<ProfileEntity>> updateMyProfile(
    UpdateProfileParams params,
  ) {
    return safeCall.safeApiCall(() async {
      final request = UpdateProfileRequest.fromDomain(params);
      final response = await remoteDataSource.updateMyProfile(request);
      return response.data.toDomain();
    });
  }
}
