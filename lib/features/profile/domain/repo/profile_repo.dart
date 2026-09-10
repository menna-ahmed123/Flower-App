import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flower_app/features/profile/domain/entities/update_profile_params.dart';

abstract interface class ProfileRepo {
  Future<BaseResponse<ProfileEntity>> getMyProfile();

  Future<BaseResponse<ProfileEntity>> updateMyProfile(
    UpdateProfileParams params,
  );
}
