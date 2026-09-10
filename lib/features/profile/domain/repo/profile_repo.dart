import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/profile/data/models/update_profile_request.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';

abstract interface class ProfileRepo {
  Future<BaseResponse<ProfileEntity>> getMyProfile();

  Future<BaseResponse<ProfileEntity>> updateMyProfile(
    UpdateProfileRequest request,
  );
}
