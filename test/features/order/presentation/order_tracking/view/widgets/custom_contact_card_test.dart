import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/features/order/core/helper/url_launcher_service.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/custom_contact_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../helpers/pump_app.dart';

/// Records what was asked to launch and reports a configurable result.
class _FakeLauncher implements UrlLauncherService {
  _FakeLauncher({this.ok = true});

  final bool ok;
  final List<String> phone = [];
  final List<String> whatsapp = [];

  @override
  Future<bool> launchPhone(String phoneNumber) async {
    phone.add(phoneNumber);
    return ok;
  }

  @override
  Future<bool> launchWhatsApp(String phoneNumber) async {
    whatsapp.add(phoneNumber);
    return ok;
  }
}

Widget _card(_FakeLauncher launcher) => Scaffold(
      body: CustomContactCard(phoneNumber: '01012345678', launcher: launcher),
    );

void main() {
  testWidgets('phone button launches the injected service (no platform)',
      (tester) async {
    final launcher = _FakeLauncher();
    await pumpApp(tester, _card(launcher));

    final buttons = find.byType(IconButton);
    await tester.tap(buttons.first); // phone
    await tester.pump();

    expect(launcher.phone, ['01012345678']);
    expect(launcher.whatsapp, isEmpty);
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('whatsapp button launches the injected service', (tester) async {
    final launcher = _FakeLauncher();
    await pumpApp(tester, _card(launcher));

    final buttons = find.byType(IconButton);
    await tester.tap(buttons.last); // whatsapp
    await tester.pump();

    expect(launcher.whatsapp, ['01012345678']);
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('failed launch shows the localized snackbar', (tester) async {
    final launcher = _FakeLauncher(ok: false);
    await pumpApp(tester, _card(launcher));

    await tester.tap(find.byType(IconButton).first);
    await tester.pump(); // the await resolves

    expect(find.text(AppString.somethingWrong), findsOneWidget);
  });
}
