import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/api_exception.dart';
import 'package:flower_app/core/network/safe_call.dart';
import 'package:flower_app/features/profile/data/data_source/remote/profile_remote_data_source.dart';
import 'package:flower_app/features/profile/data/models/update_profile_request.dart';
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
      _validateResponse(response);
      return response.data!.toDomain();
    });
  }

  @override
  Future<BaseResponse<ProfileEntity>> updateMyProfile(
    UpdateProfileRequest updateProfileRequest,
  ) {
    return safeCall.safeApiCall(() async {
      final response = await remoteDataSource.updateMyProfile(
        updateProfileRequest: updateProfileRequest,
      );
      _validateResponse(response);
      return response.data!.toDomain();
    });
  }

  void _validateResponse(dynamic response) {
    if (!response.status || response.errors != null || response.data == null) {
      throw ApiException(
        message: response.errorMessage,
        statusCode: response.code,
      );
    }
  }
}
