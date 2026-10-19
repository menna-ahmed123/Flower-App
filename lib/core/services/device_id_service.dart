import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

@lazySingleton
class DeviceIdService {
  DeviceIdService(
    this._secureStorage,
    this._uuid,
  );

  final FlutterSecureStorage _secureStorage;
  final Uuid _uuid;

  static const String _deviceIdKey = 'DEVICE_ID';

  Future<String> getDeviceId() async {
    final savedDeviceId = await _secureStorage.read(key: _deviceIdKey);

    if (savedDeviceId != null && savedDeviceId.isNotEmpty) {
      return savedDeviceId;
    }

    final deviceId = _uuid.v4();

    await _secureStorage.write(key: _deviceIdKey, value: deviceId);

    return deviceId;
  }
}
