import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flower_app/features/profile/domain/entities/update_profile_params.dart';
import 'package:flower_app/features/profile/domain/repo/profile_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateProfileUseCase {
  final ProfileRepo repo;

  UpdateProfileUseCase(this.repo);

  Future<BaseResponse<ProfileEntity>> call(UpdateProfileParams params) {
    return repo.updateMyProfile(params);
  }
}
