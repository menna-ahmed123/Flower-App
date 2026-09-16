import 'package:flower_app/core/network/token_storage.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/network/token_refresh_coordinator.dart';
import '../../../../../core/network/token_refresh_scheduler.dart';
import '../../domain/repos/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._tokenStorage, this._scheduler, this._coordinator);

  final TokenStorage _tokenStorage;
  final TokenRefreshScheduler _scheduler;
  final TokenRefreshCoordinator _coordinator;

  @override
  Future<bool> isAuthenticated() async {
    final token = await _tokenStorage.getAccessToken();

    return token != null && token.isNotEmpty;
  }

  @override
  Future<void> logout() async {
    await _tokenStorage.clearTokens();
  }

  @override
  Future<void> startSessionRefresh() => _scheduler.start();

  @override
  void stopSessionRefresh() => _scheduler.stop();

  @override
  Stream<void> get sessionExpired => _coordinator.sessionExpired;
}
