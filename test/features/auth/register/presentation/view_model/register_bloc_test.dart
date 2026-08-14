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
  setUp(() => useCase = FakeRegisterUseCase());
  testBlocStartsEmpty(() => useCase);
  testBlocUpdatesFields(() => useCase);
  testBlocClearsValidFieldError(() => useCase);
  testBlocSetsInvalidEmailError(() => useCase);
  testBlocSkipsSubmitWhenEmpty(() => useCase);
  testBlocNavigatesOnSuccess(() => useCase);
  testBlocTrimsEmailOnSubmit(() => useCase);
  testBlocShowsErrorOnFailure(() => useCase);
  testBlocNavigateToLoginIntent(() => useCase);
}

RegisterBloc _bloc(FakeRegisterUseCase Function() useCase) {
  return RegisterBloc(useCase(), const RegisterFormValidator());
}

void testBlocStartsEmpty(FakeRegisterUseCase Function() useCase) {
  test('starts with empty state', () {
    final bloc = _bloc(useCase);
    addTearDown(bloc.close);
    expect(bloc.state, const RegisterState());
  });
}

void testBlocUpdatesFields(FakeRegisterUseCase Function() useCase) {
  blocTest<RegisterBloc, RegisterState>(
    'updates fields from intents',
    build: () => _bloc(useCase),
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
}

void testBlocClearsValidFieldError(FakeRegisterUseCase Function() useCase) {
  blocTest<RegisterBloc, RegisterState>(
    'clears errors for valid input on changed field',
    build: () => _bloc(useCase),
    act: (bloc) => bloc.add(
      const RegisterFieldChangedIntent(RegisterField.firstName, 'Sara'),
    ),
    expect: () => [
      isA<RegisterState>()
          .having((state) => state.firstName, 'firstName', 'Sara')
          .having((state) => state.fieldErrors.firstName, 'err', isNull),
    ],
  );
}

void testBlocSetsInvalidEmailError(FakeRegisterUseCase Function() useCase) {
  blocTest<RegisterBloc, RegisterState>(
    'sets error code for invalid email on changed field',
    build: () => _bloc(useCase),
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
          ),
    ],
  );
}

void testBlocSkipsSubmitWhenEmpty(FakeRegisterUseCase Function() useCase) {
  blocTest<RegisterBloc, RegisterState>(
    'validates fields and skips use case when form is empty',
    build: () => _bloc(useCase),
    act: (bloc) => bloc.add(const SubmitRegisterIntent()),
    expect: () => [
      isA<RegisterState>()
          .having((state) => state.fieldErrors.hasErrors, 'hasErrors', isTrue)
          .having((state) => state.isLoading, 'isLoading', isFalse),
    ],
    verify: (_) => expect(useCase().callCount, 0),
  );
}

RegisterState get _successState {
  return filledRegisterState.copyWith(
    isLoading: false,
    fieldErrors: RegisterFieldErrors.empty,
    data: fakeRegisterSuccess.data,
    effect: const NavigateToLoginEffect(
      successMessage: 'Account registered successfully.',
    ),
  );
}

void testBlocNavigatesOnSuccess(FakeRegisterUseCase Function() useCase) {
  blocTest<RegisterBloc, RegisterState>(
    'emits isLoading then NavigateToLoginEffect on success',
    build: () => _bloc(useCase),
    seed: () => filledRegisterState,
    act: (bloc) => bloc.add(const SubmitRegisterIntent()),
    expect: () => [
      filledRegisterState.copyWith(isLoading: true, clearData: true),
      _successState,
    ],
  );
}

void testBlocTrimsEmailOnSubmit(FakeRegisterUseCase Function() useCase) {
  blocTest<RegisterBloc, RegisterState>(
    'trims email before calling the use case',
    build: () => _bloc(useCase),
    seed: () => filledRegisterState.copyWith(email: '  sara@example.com  '),
    act: (bloc) => bloc.add(const SubmitRegisterIntent()),
    verify: (_) => expect(useCase().lastRequest?.email, 'sara@example.com'),
  );
}

RegisterState get _failureState {
  return filledRegisterState.copyWith(
    isLoading: false,
    clearData: true,
    effect: ShowErrorMessageEffect(AppString.signupFailed),
  );
}

void testBlocShowsErrorOnFailure(FakeRegisterUseCase Function() useCase) {
  blocTest<RegisterBloc, RegisterState>(
    'emits isLoading then ShowErrorMessageEffect on failure',
    build: () {
      useCase().shouldFail = true;
      return _bloc(useCase);
    },
    seed: () => filledRegisterState,
    act: (bloc) => bloc.add(const SubmitRegisterIntent()),
    expect: () => [
      filledRegisterState.copyWith(isLoading: true, clearData: true),
      _failureState,
    ],
  );
}

void testBlocNavigateToLoginIntent(FakeRegisterUseCase Function() useCase) {
  blocTest<RegisterBloc, RegisterState>(
    'NavigateToLoginIntent emits effect',
    build: () => _bloc(useCase),
    act: (bloc) => bloc.add(const NavigateToLoginIntent()),
    expect: () => [
      isA<RegisterState>().having(
        (state) => state.effect,
        'effect',
        const NavigateToLoginEffect(),
      ),
    ],
  );
}
