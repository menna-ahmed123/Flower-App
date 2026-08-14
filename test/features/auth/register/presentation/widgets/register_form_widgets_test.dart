import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/features/auth/register/domain/models/register_request.dart';
import 'package:flower_app/features/auth/register/presentation/widgets/register_field_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/register_test_support.dart';

void main() {
  nameFieldsGroup();
  genderGroup();
  submitGroup();
}

void nameFieldsGroup() {
  group('RegisterNameFields', () {
    testWidgets('shows errorText', (tester) async {
      await pumpThemedWidget(tester, RegisterNameFields(
        firstName: '', lastName: '', enabled: true,
        onFirstNameChanged: (_) {}, onLastNameChanged: (_) {},
        firstNameError: AppString.fieldIsRequired(AppString.firstName),
      ));
      expect(find.text(AppString.fieldIsRequired(AppString.firstName)), findsOneWidget);
    });
  });
}

void genderGroup() {
  group('RegisterGenderSelector', () {
    testWidgets('selects male option', (tester) async {
      await pumpThemedWidget(tester, RegisterGenderSelectorHarness(initial: Gender.female));
      await tester.tap(find.text(AppString.male));
      await tester.pumpAndSettle();
      expect(find.text('selected:Male'), findsOneWidget);
    });
  });
}

void submitGroup() {
  group('RegisterSubmitButton', () {
    testWidgets('shows loading indicator', (tester) async {
      await pumpLoadingSubmitButton(tester);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
