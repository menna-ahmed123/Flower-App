import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/auth/login/data/models/login_request.dart';
import 'package:flower_app/features/auth/login/domain/entity/auth_entity.dart';
import 'package:flower_app/features/auth/login/domain/repo/auth_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginUseCase {
  final AuthRepo repo;

  LoginUseCase(this.repo);

  Future<BaseResponse<AuthEntity>> call({
  required String email,
  required String password,
  }) {
    final request = LoginRequest(email: email, password: password);
    return repo.signIn(
      email: request.email,
      password: request.password,
    );
  }
}
