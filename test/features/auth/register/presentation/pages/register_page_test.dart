import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/features/auth/register/presentation/view_model/register_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/register_test_support.dart';

void main() {
  group('RegisterPage', () {
    late FakeRegisterRepository repository;
    late RegisterBloc Function() createBloc;

    setUp(() {
      repository = FakeRegisterRepository();
      createBloc = testRegisterBlocFactory(repository);
    });

    testEmptyFirstNameValidation(() => repository, () => createBloc);
    testFirstNameErrorClearsOnValidInput(() => repository, () => createBloc);
    testEmptyLastNameValidation(() => repository, () => createBloc);
    testEmailValidation(() => repository, () => createBloc);
    testPasswordMismatchValidation(() => repository, () => createBloc);
    testSuccessfulSubmissionFlow(() => repository, () => createBloc);
    testFailedSubmissionFlow(() => repository, () => createBloc);
    testLoginLinkNavigation(() => createBloc);
  });
}

void testEmptyFirstNameValidation(
  FakeRegisterRepository Function() repo,
  RegisterBloc Function() Function() createBloc,
) {
  testWidgets('shows first name validation error', (tester) async {
    await pumpRegisterPage(tester, createBloc: createBloc());
    await tapSignUp(tester);
    await tester.pumpAndSettle();
    expect(
      find.text(AppString.fieldIsRequired(AppString.firstName)),
      findsOneWidget,
    );
    expect(repo().callCount, 0);
  });
}

void testFirstNameErrorClearsOnValidInput(
  FakeRegisterRepository Function() repo,
  RegisterBloc Function() Function() createBloc,
) {
  testWidgets('clears first name error after the user corrects it', (
    tester,
  ) async {
    await pumpRegisterPage(tester, createBloc: createBloc());
    await tapSignUp(tester);
    await tester.pumpAndSettle();
    expect(
      find.text(AppString.fieldIsRequired(AppString.firstName)),
      findsOneWidget,
    );
    await enterField(tester, AppString.enterFirstName, 'Sara');
    await tester.pumpAndSettle();
    expect(
      find.text(AppString.fieldIsRequired(AppString.firstName)),
      findsNothing,
    );
    expect(repo().callCount, 0);
  });
}

void testEmptyLastNameValidation(
  FakeRegisterRepository Function() repo,
  RegisterBloc Function() Function() createBloc,
) {
  testWidgets('shows last name validation error', (tester) async {
    await pumpRegisterPage(tester, createBloc: createBloc());
    await enterField(tester, AppString.enterFirstName, 'Sara');
    await tapSignUp(tester);
    await tester.pumpAndSettle();
    expect(
      find.text(AppString.fieldIsRequired(AppString.lastName)),
      findsOneWidget,
    );
    expect(repo().callCount, 0);
  });
}

void testEmailValidation(
  FakeRegisterRepository Function() repo,
  RegisterBloc Function() Function() createBloc,
) {
  testWidgets('shows email validation error from design', (tester) async {
    await pumpRegisterPage(tester, createBloc: createBloc());
    await enterField(tester, AppString.enterFirstName, 'Sara');
    await enterField(tester, AppString.enterLastName, 'Ali');
    await enterField(tester, AppString.enterYourEmail, 'not-an-email');
    await enterField(tester, AppString.enterPassword, 'Pass1234');
    await enterField(tester, AppString.confirmPassword, 'Pass1234');
    await enterField(tester, AppString.enterPhoneNumber, '01012345678');
    await tapSignUp(tester);
    await tester.pumpAndSettle();
    expect(find.text(AppString.pleaseEnterValidEmail), findsOneWidget);
    expect(repo().callCount, 0);
  });
}

void testPasswordMismatchValidation(
  FakeRegisterRepository Function() repo,
  RegisterBloc Function() Function() createBloc,
) {
  testWidgets('shows password mismatch validation error', (tester) async {
    await pumpRegisterPage(tester, createBloc: createBloc());
    await fillValidRegisterForm(tester);
    await enterField(tester, AppString.confirmPassword, 'Pass9999');
    await tapSignUp(tester);
    await tester.pumpAndSettle();
    expect(find.text(AppString.passwordsDoNotMatch), findsOneWidget);
    expect(repo().callCount, 0);
  });
}

void testSuccessfulSubmissionFlow(
  FakeRegisterRepository Function() repo,
  RegisterBloc Function() Function() createBloc,
) {
  testWidgets('submits valid form and navigates to login', (tester) async {
    await pumpRegisterPage(tester, createBloc: createBloc());
    await fillValidRegisterForm(tester);
    await tapSignUp(tester);
    await tester.pumpAndSettle();
    expect(repo().callCount, 1);
    expect(repo().lastRequest?.email, 'sara@example.com');
    expect(find.text('Login Screen'), findsOneWidget);
    expect(find.text('Account registered successfully.'), findsOneWidget);
  });
}

void testFailedSubmissionFlow(
  FakeRegisterRepository Function() repo,
  RegisterBloc Function() Function() createBloc,
) {
  testWidgets('shows failure snackbar when registration fails', (tester) async {
    repo().shouldFail = true;
    await pumpRegisterPage(tester, createBloc: createBloc());
    await fillValidRegisterForm(tester);
    await tapSignUp(tester);
    await tester.pumpAndSettle();
    expect(repo().callCount, 1);
    expect(find.text(AppString.signupFailed), findsOneWidget);
    expect(find.text('Login Screen'), findsNothing);
  });
}

void testLoginLinkNavigation(RegisterBloc Function() Function() createBloc) {
  testWidgets('Login link navigates to login screen', (tester) async {
    await pumpRegisterPage(tester, createBloc: createBloc());
    final loginLink = find.text(AppString.login);
    await tester.ensureVisible(loginLink);
    await tester.tap(loginLink);
    await tester.pumpAndSettle();
    expect(find.text('Login Screen'), findsOneWidget);
  });
}
