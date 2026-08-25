import 'package:flower_app/features/auth/register/data/api/register_api_client.dart';
import 'package:flower_app/features/auth/register/data/data_source/remote/register_remote_data_source_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../support/register_test_support.dart';
import 'register_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([RegisterApiClient])
void main() {
  late RegisterApiClient registerApiClient;
  late RegisterRemoteDataSourceImpl datasourceImpl;

  setUpAll(() {
    registerApiClient = MockRegisterApiClient();
    datasourceImpl = RegisterRemoteDataSourceImpl(registerApiClient);
  });

  final request = validRegisterRequest();

  group('call registerApiClient.register', () {
    test(
      'should call registerApiClient.register and return RegisterResponse',
      () async {
        final response = successfulRegisterResponse();
        when(
          registerApiClient.register(request),
        ).thenAnswer((_) async => response);

        final result = await datasourceImpl.register(request);

        expect(result, response);
        verify(registerApiClient.register(request)).called(1);
      },
    );
  });

  test(
    'should throw exception when registerApiClient.register throws an exception',
    () async {
      final exception = Exception('Register failed');
      when(registerApiClient.register(request)).thenThrow(exception);

      expect(() => datasourceImpl.register(request), throwsA(exception));
      verify(registerApiClient.register(request)).called(1);
    },
  );
}
