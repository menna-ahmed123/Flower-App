import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(dotenv.clean);

  test('normalizeBaseUrl appends /api/v1 when missing', () {
    expect(
      ApiEndpoints.normalizeBaseUrl('http://192.0.2.1:8080'),
      'http://192.0.2.1:8080/api/v1',
    );
  });

  test('normalizeBaseUrl keeps an existing /api/v1 suffix', () {
    expect(
      ApiEndpoints.normalizeBaseUrl('http://192.0.2.1:8080/api/v1/'),
      'http://192.0.2.1:8080/api/v1',
    );
  });

  test('loadBaseUrl keeps BASE_URL from an already loaded dotenv', () async {
    dotenv.loadFromString(envString: 'BASE_URL=http://192.0.2.1:8080');
    await ApiEndpoints.loadBaseUrl();
    expect(ApiEndpoints.resolvedBaseUrl, 'http://192.0.2.1:8080/api/v1');
  });

  test('keeps LAN BASE_URL on Android emulator', () {
    expect(
      ApiEndpoints.rewriteHostForLocalClient(
        'http://192.168.1.13:8080',
        androidEmulator: true,
        iosSimulator: false,
      ),
      'http://192.168.1.13:8080',
    );
  });

  test('rewrites Android emulator loopback to 10.0.2.2', () {
    expect(
      ApiEndpoints.rewriteHostForLocalClient(
        'http://127.0.0.1:8080',
        androidEmulator: true,
        iosSimulator: false,
      ),
      'http://10.0.2.2:8080',
    );
  });

  test('rewrites iOS simulator loopback to 127.0.0.1', () {
    expect(
      ApiEndpoints.rewriteHostForLocalClient(
        'http://localhost:8080',
        androidEmulator: false,
        iosSimulator: true,
      ),
      'http://127.0.0.1:8080',
    );
  });
}
