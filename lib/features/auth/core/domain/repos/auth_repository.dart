abstract class AuthRepository {
  Future<bool> isAuthenticated();

  Future<void> logout();

  Future<void> startSessionRefresh();

  void stopSessionRefresh();

  Stream<void> get sessionExpired;
}