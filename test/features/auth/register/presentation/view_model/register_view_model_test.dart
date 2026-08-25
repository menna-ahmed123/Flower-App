import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/auth/register/data/models/register_request.dart';
import 'package:flower_app/features/auth/register/domain/entity/register_entity.dart';
import 'package:flower_app/features/auth/register/domain/use_case/register_usecase.dart';
import 'package:flower_app/features/auth/register/presentation/view_model/register_state.dart';
import 'package:flower_app/features/auth/register/presentation/view_model/register_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../support/register_test_support.dart';
import 'register_view_model_test.mocks.dart';

@GenerateMocks([RegisterUseCase])
void main() {
  late MockRegisterUseCase mockRegisterUseCase;
  late RegisterViewModel viewModel;

  setUp(() {
    provideDummy<BaseResponse<RegisterEntity>>(fakeRegisterSuccess);
    mockRegisterUseCase = MockRegisterUseCase();
    viewModel = RegisterViewModel(mockRegisterUseCase);
  });

  tearDown(() async {
    await viewModel.close();
  });

  test('starts with empty state', () {
    expect(viewModel.state, const RegisterState());
    expect(viewModel.state.registerState.isLoading, isFalse);
    expect(viewModel.state.registerState.errorMessage, '');
    expect(viewModel.state.registerState.data, isNull);
  });

  test('should emit loading state when register is submitted', () async {
    when(mockRegisterUseCase(any)).thenAnswer((_) async => fakeRegisterSuccess);

    viewModel.doEvent(validRegisterSubmitted());

    expect(viewModel.state.registerState.isLoading, isTrue);
    expect(viewModel.state.registerState.errorMessage, '');
  });

  test('should emit success state when register succeeds', () async {
    when(mockRegisterUseCase(any)).thenAnswer((_) async => fakeRegisterSuccess);

    viewModel.doEvent(validRegisterSubmitted());
    await Future<void>.delayed(Duration.zero);

    expect(viewModel.state.registerState.isLoading, isFalse);
    expect(viewModel.state.registerState.data, fakeRegisterEntity);
    expect(viewModel.state.registerState.errorMessage, '');
    verify(mockRegisterUseCase(any)).called(1);
  });

  test('should emit error state when register fails', () async {
    when(mockRegisterUseCase(any)).thenAnswer(
      (_) async =>
          ErrorResponse(appError: BadResponseError(AppString.signupFailed)),
    );

    viewModel.doEvent(validRegisterSubmitted());
    await Future<void>.delayed(Duration.zero);

    expect(viewModel.state.registerState.isLoading, isFalse);
    expect(viewModel.state.registerState.errorMessage, AppString.signupFailed);
    verify(mockRegisterUseCase(any)).called(1);
  });

  test('builds OpenAPI request body and trims identity fields', () async {
    when(mockRegisterUseCase(any)).thenAnswer((_) async => fakeRegisterSuccess);

    viewModel.doEvent(
      validRegisterSubmitted(
        firstName: ' Sara ',
        lastName: ' Ali ',
        email: '  sara@example.com  ',
        phoneNumber: ' 01012345678 ',
      ),
    );
    await Future<void>.delayed(Duration.zero);

    final captured =
        verify(mockRegisterUseCase(captureAny)).captured.single
            as RegisterRequest;
    expect(captured.toJson(), expectedFemaleBody());
  });

  test('maps Male gender for OpenAPI contract', () async {
    when(mockRegisterUseCase(any)).thenAnswer((_) async => fakeRegisterSuccess);

    viewModel.doEvent(validRegisterSubmitted(gender: 'Male'));
    await Future<void>.delayed(Duration.zero);

    final captured =
        verify(mockRegisterUseCase(captureAny)).captured.single
            as RegisterRequest;
    expect(captured.gender, 'Male');
  });
}
