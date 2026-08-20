import 'package:flower_app/core/constants/app_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/register_test_support.dart';

void main() {
  group('RegisterPage', () {
    late FakeRegisterUseCase useCase;

    setUp(() {
      useCase = FakeRegisterUseCase();
    });

    testWidgets('renders required register fields and submit button', (
      tester,
    ) async {
      await pumpRegisterPage(tester, useCase: useCase);
      expect(find.text(AppString.signUp), findsWidgets);
      expect(find.text(AppString.firstName), findsOneWidget);
      expect(find.text(AppString.lastName), findsOneWidget);
      expect(find.text(AppString.email), findsOneWidget);
      expect(find.text(AppString.password), findsOneWidget);
      expect(find.text(AppString.confirmPassword), findsWidgets);
      expect(find.text(AppString.phoneNumber), findsOneWidget);
      expect(
        find.widgetWithText(ElevatedButton, AppString.signUp),
        findsOneWidget,
      );
    });

    testWidgets('shows first name validation error', (tester) async {
      await pumpRegisterPage(tester, useCase: useCase);
      await tapSignUp(tester);
      await tester.pumpAndSettle();
      expect(
        find.text(AppString.fieldIsRequired(AppString.firstName)),
        findsOneWidget,
      );
      expect(useCase.callCount, 0);
    });

    testWidgets('clears first name error after the user corrects it', (
      tester,
    ) async {
      await pumpRegisterPage(tester, useCase: useCase);
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
      expect(useCase.callCount, 0);
    });

    testWidgets('shows last name validation error', (tester) async {
      await pumpRegisterPage(tester, useCase: useCase);
      await enterField(tester, AppString.enterFirstName, 'Sara');
      await tapSignUp(tester);
      await tester.pumpAndSettle();
      expect(
        find.text(AppString.fieldIsRequired(AppString.lastName)),
        findsOneWidget,
      );
      expect(useCase.callCount, 0);
    });

    testWidgets('shows email validation error from design', (tester) async {
      await pumpRegisterPage(tester, useCase: useCase);
      await enterField(tester, AppString.enterFirstName, 'Sara');
      await enterField(tester, AppString.enterLastName, 'Ali');
      await enterField(tester, AppString.enterYourEmail, 'not-an-email');
      await enterField(tester, AppString.enterPassword, 'Pass1234');
      await enterField(tester, AppString.confirmPassword, 'Pass1234');
      await enterField(tester, AppString.enterPhoneNumber, '01012345678');
      await tapSignUp(tester);
      await tester.pumpAndSettle();
      expect(find.text(AppString.pleaseEnterValidEmail), findsOneWidget);
      expect(useCase.callCount, 0);
    });

    testWidgets('shows password mismatch validation error', (tester) async {
      await pumpRegisterPage(tester, useCase: useCase);
      await fillValidRegisterForm(tester);
      await enterField(tester, AppString.confirmPassword, 'Pass9999');
      await tapSignUp(tester);
      await tester.pumpAndSettle();
      expect(find.text(AppString.passwordsDoNotMatch), findsOneWidget);
      expect(useCase.callCount, 0);
    });

    testWidgets('shows loading indicator while registration is in progress', (
      tester,
    ) async {
      useCase.delay = const Duration(milliseconds: 50);
      await pumpRegisterPage(tester, useCase: useCase);
      await fillValidRegisterForm(tester);
      await tapSignUp(tester);
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(
        find.widgetWithText(ElevatedButton, AppString.signUp),
        findsNothing,
      );
      await tester.pumpAndSettle();
    });

    testWidgets('submits valid form and navigates to login', (tester) async {
      await pumpRegisterPage(tester, useCase: useCase);
      await fillValidRegisterForm(tester);
      await tapSignUp(tester);
      await tester.pumpAndSettle();
      expect(useCase.callCount, 1);
      expect(useCase.lastRequest?.email, 'sara@example.com');
      expect(useCase.lastRequest?.fullName, 'Sara Ali');
      expect(find.text('Login Screen'), findsOneWidget);
      expect(find.text('Account registered successfully.'), findsOneWidget);
    });

    testWidgets('shows failure snackbar when registration fails', (
      tester,
    ) async {
      useCase.shouldFail = true;
      await pumpRegisterPage(tester, useCase: useCase);
      await fillValidRegisterForm(tester);
      await tapSignUp(tester);
      await tester.pumpAndSettle();
      expect(useCase.callCount, 1);
      expect(find.text(AppString.signupFailed), findsOneWidget);
      expect(find.text('Login Screen'), findsNothing);
    });

    testWidgets('Login link navigates to login screen', (tester) async {
      await pumpRegisterPage(tester, useCase: useCase);
      final loginButton = tester.widget<TextButton>(
        find.widgetWithText(TextButton, AppString.login),
      );
      loginButton.onPressed!();
      await tester.pumpAndSettle();
      expect(find.text('Login Screen'), findsOneWidget);
    });
  });
}
