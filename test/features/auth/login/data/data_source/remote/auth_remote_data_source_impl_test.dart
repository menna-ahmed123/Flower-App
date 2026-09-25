import 'package:flower_app/features/auth/login/data/api/auth_api_client.dart';
import 'package:flower_app/features/auth/login/data/data_source/remote/auth_remote_data_source_impl.dart';
import 'package:flower_app/features/auth/login/data/models/login_request.dart';
import 'package:flower_app/features/auth/login/data/models/login_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([AuthApiClient])
void main() {
  late AuthApiClient authApiClient;
  late AuthRemoteDatasourceImpl datasourceImpl;

  setUpAll(() {
    authApiClient = MockAuthApiClient();
    datasourceImpl = AuthRemoteDatasourceImpl(authApiClient);
  });
  final request = LoginRequest(email: 'test@test.com', password: '123456');

  group(" call authApiClient.login", () {
    test("should call authApiClient.login and return LoginResponse", () async {
      //arrange
      final response = LoginResponse(
        status: true,
        code: 200,
        message: 'Login successful.',
        data: LoginData(
          user: LoginUser(
            id: 'user-1',
            email: 'test@test.com',
            phone: '01012345678',
            name: 'Test User',
            roles: ['CUSTOMER'],
            createdAt: DateTime.parse('2026-01-01T00:00:00Z'),
            updatedAt: DateTime.parse('2026-01-01T00:00:00Z'),
            gender: 'MALE',
            notificationStatus: 'ON',
          ),
          token: 'access_token',
          refreshToken: 'refresh_token',
        ),
      );
      when(authApiClient.login(request)).thenAnswer((_) async => response);

      // Act
      final result = await datasourceImpl.login(request);

      // Assert
      expect(result, response);
      verify(authApiClient.login(request)).called(1);
    });
  });
  test(
    'should throw exception when authApiClient.login throws an exception',
    () async {
      // Arrange

      final exception = Exception('Login failed');

      when(authApiClient.login(request)).thenThrow(exception);

      // Act & Assert
      expect(() => datasourceImpl.login(request), throwsA(exception));

      verify(authApiClient.login(request)).called(1);
    },
  );
}
