import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FcmTokenStorage {
  FcmTokenStorage(this._storage);

  static const String _key = 'LAST_SYNCED_FCM_TOKEN';

  final FlutterSecureStorage _storage;

  Future<String?> getLastSyncedToken() {
    return _storage.read(key: _key);
  }

  Future<void> saveLastSyncedToken(String token) {
    return _storage.write(key: _key, value: token);
  }
}
