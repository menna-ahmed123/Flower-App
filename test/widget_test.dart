import 'package:flower_app/core/constants/app_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'features/auth/register/support/register_test_support.dart';

void main() {
  registerPageSmokeTest();
}

void registerPageSmokeTest() {
  testWidgets('Register page loads sign up screen', (tester) async {
    await pumpRegisterPage(tester, useCase: FakeRegisterUseCase());
    expect(
      find.widgetWithText(ElevatedButton, AppString.signUp),
      findsOneWidget,
    );
  });
}
