import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/features/auth/register/domain/entity/gender.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/register_test_support.dart';

void main() {
  nameFieldsGroup();
  genderGroup();
  submitGroup();
}

void nameFieldsGroup() {
  group('Register identity fields', () {
    testWidgets('shows first name validation errorText', (tester) async {
      await pumpRegisterPage(tester, useCase: FakeRegisterUseCase());
      await tapSignUp(tester);
      await tester.pumpAndSettle();
      expect(
        find.text(AppString.fieldIsRequired(AppString.firstName)),
        findsOneWidget,
      );
    });
  });
}

void genderGroup() {
  group('RegisterGenderSelector', () {
    testWidgets('selects male option', (tester) async {
      await pumpThemedWidget(
        tester,
        RegisterGenderSelectorHarness(initial: Gender.female),
      );
      await tester.tap(find.text(AppString.male));
      await tester.pumpAndSettle();
      expect(find.text('selected:Male'), findsOneWidget);
    });
  });
}

void submitGroup() {
  group('Register submit loading', () {
    testWidgets('shows loading indicator', (tester) async {
      final useCase = FakeRegisterUseCase()
        ..delay = const Duration(milliseconds: 50);
      await pumpRegisterPage(tester, useCase: useCase);
      await fillValidRegisterForm(tester);
      await tapSignUp(tester);
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();
    });
  });
}
