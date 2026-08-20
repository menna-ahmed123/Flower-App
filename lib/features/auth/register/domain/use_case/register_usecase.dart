import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/auth/register/data/models/register_request.dart';
import 'package:flower_app/features/auth/register/domain/entity/register_entity.dart';
import 'package:flower_app/features/auth/register/domain/repo/register_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class RegisterUseCase {
  final RegisterRepo repo;

  RegisterUseCase(this.repo);

  Future<BaseResponse<RegisterEntity>> call(RegisterRequest request) {
    return repo.register(request);
  }
}
