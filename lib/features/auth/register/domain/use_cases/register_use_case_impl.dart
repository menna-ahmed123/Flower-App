import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/auth/register/domain/models/register_request.dart';
import 'package:flower_app/features/auth/register/domain/models/register_result.dart';
import 'package:flower_app/features/auth/register/domain/repositories/register_repository.dart';
import 'package:flower_app/features/auth/register/domain/use_cases/register_use_case.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: RegisterUseCase)
class RegisterUseCaseImpl implements RegisterUseCase {
  RegisterUseCaseImpl(this._repository);

  final RegisterRepository _repository;

  @override
  Future<BaseResponse<RegisterResult>> call(RegisterRequest request) {
    return _repository.register(request);
  }
}
