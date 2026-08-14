import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/features/auth/register/domain/models/register_request.dart';
import 'package:flower_app/features/auth/register/domain/validators/register_form_validator.dart';
import 'package:flower_app/features/auth/register/presentation/effect/register_effect.dart';
import 'package:flower_app/features/auth/register/presentation/intent/register_intent.dart';
import 'package:flower_app/features/auth/register/presentation/state/register_state.dart';
import 'package:flower_app/features/auth/register/presentation/view_model/register_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/register_test_support.dart';

void main() {
  late FakeRegisterUseCase useCase;

  setUp(() {
    useCase = FakeRegisterUseCase();
  });

  RegisterBloc buildBloc() {
    return RegisterBloc(useCase, const RegisterFormValidator());
  }

  test('starts with empty state', () {
    final bloc = buildBloc();
    addTearDown(bloc.close);
    expect(bloc.state, const RegisterState());
  });

  group('RegisterBloc field changes', () {
    blocTest<RegisterBloc, RegisterState>(
      'updates fields from intents',
      build: buildBloc,
      act: (bloc) {
        bloc
          ..add(const RegisterFieldChangedIntent(RegisterField.email, 'a@b.com'))
          ..add(const RegisterGenderChangedIntent(Gender.male));
      },
      expect: () => [
        isA<RegisterState>().having((state) => state.email, 'email', 'a@b.com'),
        isA<RegisterState>()
            .having((state) => state.email, 'email', 'a@b.com')
            .having((state) => state.gender, 'gender', Gender.male),
      ],
    );

    blocTest<RegisterBloc, RegisterState>(
      'clears errors for valid input on changed field',
      build: buildBloc,
      act: (bloc) => bloc.add(
        const RegisterFieldChangedIntent(RegisterField.firstName, 'Sara'),
      ),
      expect: () => [
        isA<RegisterState>()
            .having((state) => state.firstName, 'firstName', 'Sara')
            .having((state) => state.fieldErrors.firstName, 'firstName error', isNull)
            .having((state) => state.fieldErrors.email, 'email error', isNull),
      ],
    );

    blocTest<RegisterBloc, RegisterState>(
      'sets error code for invalid email on changed field',
      build: buildBloc,
      act: (bloc) => bloc.add(
        const RegisterFieldChangedIntent(RegisterField.email, 'not-an-email'),
      ),
      expect: () => [
        isA<RegisterState>()
            .having((state) => state.email, 'email', 'not-an-email')
            .having(
              (state) => state.fieldErrors.email,
              'email error',
              RegisterValidationError.invalid,
            )
            .having((state) => state.fieldErrors.firstName, 'firstName error', isNull),
      ],
    );
  });

  group('RegisterBloc submit', () {
    blocTest<RegisterBloc, RegisterState>(
      'validates fields and skips use case when form is empty',
      build: buildBloc,
      act: (bloc) => bloc.add(const SubmitRegisterIntent()),
      expect: () => [
        isA<RegisterState>()
            .having((state) => state.fieldErrors.hasErrors, 'hasErrors', isTrue)
            .having(
              (state) => state.fieldErrors.firstName,
              'firstName error',
              RegisterValidationError.empty,
            )
            .having((state) => state.isLoading, 'isLoading', isFalse),
      ],
      verify: (_) => expect(useCase.callCount, 0),
    );

    blocTest<RegisterBloc, RegisterState>(
      'emits isLoading then NavigateToLoginEffect on success',
      build: buildBloc,
      seed: () => filledRegisterState,
      act: (bloc) => bloc.add(const SubmitRegisterIntent()),
      expect: () => [
        filledRegisterState.copyWith(isLoading: true, clearData: true),
        filledRegisterState.copyWith(
          isLoading: false,
          fieldErrors: RegisterFieldErrors.empty,
          data: fakeRegisterSuccess.data,
          effect: const NavigateToLoginEffect(
            successMessage: 'Account registered successfully.',
          ),
        ),
      ],
    );

    blocTest<RegisterBloc, RegisterState>(
      'trims email before calling the use case',
      build: buildBloc,
      seed: () => filledRegisterState.copyWith(email: '  sara@example.com  '),
      act: (bloc) => bloc.add(const SubmitRegisterIntent()),
      verify: (_) => expect(useCase.lastRequest?.email, 'sara@example.com'),
    );

    blocTest<RegisterBloc, RegisterState>(
      'emits isLoading then ShowErrorMessageEffect on failure',
      build: () {
        useCase = FakeRegisterUseCase()..shouldFail = true;
        return buildBloc();
      },
      seed: () => filledRegisterState,
      act: (bloc) => bloc.add(const SubmitRegisterIntent()),
      expect: () => [
        filledRegisterState.copyWith(isLoading: true, clearData: true),
        filledRegisterState.copyWith(
          isLoading: false,
          clearData: true,
          effect: ShowErrorMessageEffect(AppString.signupFailed),
        ),
      ],
    );
  });

  group('RegisterBloc navigation', () {
    blocTest<RegisterBloc, RegisterState>(
      'NavigateToLoginIntent emits effect',
      build: buildBloc,
      act: (bloc) => bloc.add(const NavigateToLoginIntent()),
      expect: () => [
        isA<RegisterState>().having(
          (state) => state.effect,
          'effect',
          const NavigateToLoginEffect(),
        ),
      ],
    );
  });
}
