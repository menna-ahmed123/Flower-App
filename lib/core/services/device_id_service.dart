import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

@lazySingleton
class DeviceIdService {
  DeviceIdService(this._secureStorage);

  final FlutterSecureStorage _secureStorage;

  static const String _deviceIdKey = 'DEVICE_ID';
  static const Uuid _uuid = Uuid();

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
