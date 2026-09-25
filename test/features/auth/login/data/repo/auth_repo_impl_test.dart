import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/core/network/safe_call.dart';
import 'package:flower_app/core/network/token_storage.dart';
import 'package:flower_app/features/auth/login/data/data_source/remote/auth_remote_data_source.dart';
import 'package:flower_app/features/auth/login/data/models/login_request.dart';
import 'package:flower_app/features/auth/login/data/models/login_response.dart';
import 'package:flower_app/features/auth/login/data/repo/auth_repo_impl.dart';
import 'package:flower_app/features/auth/login/domain/entity/auth_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_repo_impl_test.mocks.dart';

@GenerateMocks([AuthRemoteDataSource, TokenStorage])
void main() {
  late AuthRemoteDataSource authRemoteDataSource;
  late SafeCall safeCall;
  late TokenStorage tokenStorage;
  late AuthRepositoryImpl authRepositoryImpl;

  setUpAll(() {
    authRemoteDataSource = MockAuthRemoteDataSource();
    safeCall = SafeCall();
    tokenStorage = MockTokenStorage();
    authRepositoryImpl = AuthRepositoryImpl(
      authRemoteDataSource,
      safeCall,
      tokenStorage,
    );
  });
  final request = LoginRequest(email: 'test@test.com', password: '123456');
  final response = LoginResponse(
    status: true,
    code: 200,
    message: 'Login successful',
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
      token: 'access-token',
      refreshToken: 'refresh-token',
    ),
  );
  final authEntity = AuthEntity(
    accessToken: 'access-token',
    refreshToken: 'refresh-token',
    role: 'Customer',
    expiresIn: 900,
  );
  group("Login", () {
    test(
      "should return SuccessResponse and save tokens when login succeeds",
      () async {
        provideDummy<BaseResponse<AuthEntity>>(SuccessResponse(authEntity));
        when(
          authRemoteDataSource.login(request),
        ).thenAnswer((_) async => response);

        when(
          tokenStorage.saveTokens(
            accessToken: "access-token",
            refreshToken: "refresh-token",
            expiresIn: null,
          ),
        ).thenAnswer((_) async {});
        final result = await authRepositoryImpl.signIn(request);
        // Assert
        expect(result, isA<SuccessResponse<AuthEntity>>());
        final successResult = result as SuccessResponse<AuthEntity>;
        expect(successResult.data.accessToken, "access-token");
        verify(authRemoteDataSource.login(request)).called(1);

        verify(
          tokenStorage.saveTokens(
            accessToken: "access-token",
            refreshToken: "refresh-token",
            expiresIn: null,
          ),
        ).called(1);
      },
    );

    test('should clear tokens when signOut is called', () async {
      when(tokenStorage.clearTokens()).thenAnswer((_) async {});

      await authRepositoryImpl.signOut();

      verify(tokenStorage.clearTokens()).called(1);
    });
  });
  test(
    "should return ErrorResponse and unsave tokens when login error",
    () async {
      String dummyErrorMessage = "Dummy Message";
      final error = BadResponseError(dummyErrorMessage);
      provideDummy<BaseResponse<AuthEntity>>(ErrorResponse(appError: error));
      final exception = Exception('Something went wrong.');
      when(authRemoteDataSource.login(request)).thenThrow(exception);

      expect(() => authRemoteDataSource.login(request), throwsA(exception));
      verify(authRemoteDataSource.login(request)).called(1);
    },
  );
}
