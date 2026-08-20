import 'package:flower_app/features/auth/login/domain/repo/auth_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class LogoutUseCase {
  LogoutUseCase(this._repo);

  final AuthRepo _repo;

  Future<void> call() {
    return _repo.signOut();
  }
}
