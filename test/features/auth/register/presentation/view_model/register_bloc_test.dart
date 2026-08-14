import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/features/auth/register/domain/models/register_request.dart';
import 'package:flower_app/features/auth/register/domain/validators/register_field_errors.dart';
import 'package:flower_app/features/auth/register/presentation/effect/register_effect.dart';
import 'package:flower_app/features/auth/register/presentation/intent/register_intent.dart';
import 'package:flower_app/features/auth/register/presentation/state/register_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/register_test_support.dart';

void main() {
  initialStateGroup();
  fieldValuesGroup();
  fieldValidationValidGroup();
  fieldValidationInvalidGroup();
  submitValidationGroup();
  submitSuccessGroup();
  submitFailureGroup();
  navigationGroup();
}

void initialStateGroup() {
  group('RegisterBloc initial state', () {
    test('starts with empty state', () async {
      final env = RegisterBlocTestEnv();
      addTearDown(env.dispose);
      expect(env.bloc.state, const RegisterState());
    });
  });
}

void fieldValuesGroup() {
  group('RegisterBloc field values', () {
    test('updates fields from intents', () async {
      final env = RegisterBlocTestEnv();
      addTearDown(env.dispose);
      await dispatchIntent(
        env.bloc,
        const RegisterFieldChangedIntent(RegisterField.email, 'a@b.com'),
        until: (state) => state.email == 'a@b.com',
      );
      expect(env.bloc.state.email, 'a@b.com');
      await dispatchIntent(
        env.bloc,
        const RegisterGenderChangedIntent(Gender.male),
        until: (state) => state.gender == Gender.male,
      );
      expect(env.bloc.state.gender, Gender.male);
    });
  });
}

void fieldValidationValidGroup() {
  group('RegisterBloc field validation valid', () {
    test('clears errors for valid input on changed field', () async {
      final env = RegisterBlocTestEnv();
      addTearDown(env.dispose);
      await dispatchIntent(
        env.bloc,
        const RegisterFieldChangedIntent(RegisterField.firstName, 'Sara'),
        until: (state) => state.firstName == 'Sara',
      );
      expect(env.bloc.state.fieldErrors.firstName, isNull);
      expect(env.bloc.state.fieldErrors.email, isNull);
    });
  });
}

void fieldValidationInvalidGroup() {
  group('RegisterBloc field validation invalid', () {
    test('sets error for invalid email on changed field', () async {
      final env = RegisterBlocTestEnv();
      addTearDown(env.dispose);
      await dispatchIntent(
        env.bloc,
        const RegisterFieldChangedIntent(RegisterField.email, 'not-an-email'),
        until: (state) => state.fieldErrors.email != null,
      );
      expect(env.bloc.state.fieldErrors.email, RegisterValidationError.invalid);
      expect(env.bloc.state.fieldErrors.firstName, isNull);
    });
  });
}

void submitValidationGroup() {
  group('RegisterBloc submit validation', () {
    test('validates before submit', () async {
      final env = RegisterBlocTestEnv();
      addTearDown(env.dispose);
      await dispatchIntent(
        env.bloc,
        const SubmitRegisterIntent(),
        until: (state) => state.fieldErrors.hasErrors,
      );
      expect(env.useCase.callCount, 0);
      expect(env.bloc.state.fieldErrors.firstName, isNotNull);
    });
  });
}

void submitSuccessGroup() {
  group('RegisterBloc submit success', () {
    test('emits loading then success on valid submit', () async {
      final env = RegisterBlocTestEnv();
      addTearDown(env.dispose);
      final states = await captureSubmitStates(env.bloc);
      expect(states.any((state) => state.isLoading), isTrue);
      expect(env.bloc.state.isLoading, isFalse);
      expect(env.bloc.state.data?.userId, 'user-1');
      expect(
        env.bloc.state.effect,
        const NavigateToLoginEffect(
          successMessage: 'Account registered successfully.',
        ),
      );
    });
  });
}

void submitFailureGroup() {
  group('RegisterBloc submit failure', () {
    test('emits failure when use case fails', () async {
      final env = RegisterBlocTestEnv(useCase: FakeRegisterUseCase()..shouldFail = true);
      addTearDown(env.dispose);
      await captureSubmitStates(env.bloc);
      expect(env.bloc.state.effect, ShowErrorMessageEffect(AppString.signupFailed));
    });
  });
}

void navigationGroup() {
  group('RegisterBloc navigation', () {
    test('NavigateToLoginIntent emits effect', () async {
      final env = RegisterBlocTestEnv();
      addTearDown(env.dispose);
      await dispatchIntent(
        env.bloc,
        const NavigateToLoginIntent(),
        until: (state) => state.effect != null,
      );
      expect(env.bloc.state.effect, const NavigateToLoginEffect());
    });

    test('toggles password visibility', () async {
      final env = RegisterBlocTestEnv();
      addTearDown(env.dispose);
      expect(env.bloc.state.obscurePassword, isTrue);
      await dispatchIntent(
        env.bloc,
        const TogglePasswordVisibilityIntent(),
        until: (state) => !state.obscurePassword,
      );
      expect(env.bloc.state.obscurePassword, isFalse);
    });
  });
}
