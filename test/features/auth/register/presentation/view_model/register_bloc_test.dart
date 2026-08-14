import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/features/auth/register/domain/models/register_request.dart';
import 'package:flower_app/features/auth/register/presentation/effect/register_effect.dart';
import 'package:flower_app/features/auth/register/presentation/intent/register_intent.dart';
import 'package:flower_app/features/auth/register/presentation/state/register_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/register_test_support.dart';

void main() {
  initialStateGroup();
  fieldValuesGroup();
  fieldValidationGroup();
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
      env.bloc.add(const RegisterFieldChangedIntent(RegisterField.email, 'a@b.com'));
      await Future<void>.delayed(Duration.zero);
      expect(env.bloc.state.email, 'a@b.com');
      env.bloc.add(const RegisterGenderChangedIntent(Gender.male));
      await Future<void>.delayed(Duration.zero);
      expect(env.bloc.state.gender, Gender.male);
    });
  });
}

void fieldValidationGroup() {
  group('RegisterBloc field validation', () {
    test('validates only the changed field while typing', () async {
      final env = RegisterBlocTestEnv();
      addTearDown(env.dispose);
      env.bloc.add(const RegisterFieldChangedIntent(RegisterField.firstName, 'S'));
      await Future<void>.delayed(Duration.zero);
      expect(env.bloc.state.fieldErrors.firstName, isNull);
      expect(env.bloc.state.fieldErrors.email, isNull);
    });
  });
}

void submitValidationGroup() {
  group('RegisterBloc submit validation', () {
    test('validates before submit', () async {
      final env = RegisterBlocTestEnv();
      addTearDown(env.dispose);
      env.bloc.add(const SubmitRegisterIntent());
      await Future<void>.delayed(Duration.zero);
      expect(env.useCase.callCount, 0);
      expect(env.bloc.state.fieldErrors.firstName, isNotNull);
    });
  });
}

void submitSuccessGroup() {
  group('RegisterBloc submit success', () {
    test('emits success on valid submit', () async {
      final env = RegisterBlocTestEnv();
      addTearDown(env.dispose);
      await captureSubmitStates(env.bloc);
      expect(env.bloc.state.data?.userId, 'user-1');
      expect(env.bloc.state.effect, const NavigateToLoginEffect(successMessage: 'Account registered successfully.'));
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
      env.bloc.add(const NavigateToLoginIntent());
      await Future<void>.delayed(Duration.zero);
      expect(env.bloc.state.effect, const NavigateToLoginEffect());
    });
  });
}
