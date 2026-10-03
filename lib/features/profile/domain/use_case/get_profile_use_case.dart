import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flower_app/features/profile/domain/repo/profile_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetProfileUseCase {
  final ProfileRepo repo;

  GetProfileUseCase(this.repo);

  Future<BaseResponse<ProfileEntity>> call() {
    return repo.getMyProfile();
  }
}
