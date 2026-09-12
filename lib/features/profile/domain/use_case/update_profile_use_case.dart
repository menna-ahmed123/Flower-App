import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/profile/data/models/update_profile_request.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flower_app/features/profile/domain/repo/profile_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateProfileUseCase {
  final ProfileRepo repo;

  UpdateProfileUseCase(this.repo);

  Future<BaseResponse<ProfileEntity>> call(UpdateProfileRequest request) {
    return repo.updateMyProfile(request);
  }
}
