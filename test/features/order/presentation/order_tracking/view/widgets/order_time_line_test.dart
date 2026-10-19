import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/features/order/domain/entities/order_status.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/extensions/tracking_date_format.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/extensions/tracking_timeline_steps.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/order_time_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../fixtures/tracking_fixtures.dart';
import '../../../../../../helpers/pump_app.dart';

void main() {
  testWidgets('renders the four step titles, localized', (tester) async {
    final t = trackingFixture();
    await pumpApp(
      tester,
      Scaffold(
        body: SingleChildScrollView(
          child: OrderTimeLine(
            steps: t.trackingTimeline,
            currentStep: t.uiStepIndex,
          ),
        ),
      ),
    );
    expect(find.text(AppString.trackingStepReceived), findsOneWidget);
    expect(find.text(AppString.trackingStepPreparing), findsOneWidget);
    expect(find.text(AppString.trackingStepOutForDelivery), findsOneWidget);
    expect(find.text(AppString.statusDelivered), findsOneWidget);
  });

  testWidgets('steps without a timestamp render no date/time text', (tester) async {
    await pumpApp(
      tester,
      Scaffold(
        body: SingleChildScrollView(
          child: OrderTimeLine(
            steps: [
              (status: OrderStatus.placed, occurredAt: null),
              (status: OrderStatus.preparing, occurredAt: null),
              (status: OrderStatus.outForDelivery, occurredAt: null),
              (status: OrderStatus.delivered, occurredAt: null),
            ],
            currentStep: 0,
          ),
        ),
      ),
    );

    // Titles are present...
    expect(find.text(AppString.trackingStepReceived), findsOneWidget);
    expect(find.text(AppString.statusDelivered), findsOneWidget);
    // ...but a null time renders the empty string, never a formatted date,
    // so nothing on screen should contain a digit (dd/MMMM/yyyy/h:mm).
    expect(find.textContaining(RegExp(r'\d')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the wording is the presentation label, never a stored title', (
    tester,
  ) async {
    final t = trackingFixture(status: OrderStatus.delivered);
    await pumpApp(
      tester,
      Scaffold(
        body: SingleChildScrollView(
          child: OrderTimeLine(
            steps: t.trackingTimeline,
            currentStep: t.uiStepIndex,
          ),
        ),
      ),
    );

    // A finished order still reads its four labels, with the last one done.
    expect(find.text(AppString.trackingStepReceived), findsOneWidget);
    expect(find.text(AppString.statusDelivered), findsOneWidget);
  });

  testWidgets('a status grouped inside a step keeps its title and timestamp', (
    tester,
  ) async {
    // PICKED_UP is part of the "Out for delivery" step, as before.
    final t = trackingFixture(status: OrderStatus.pickedUp);
    final steps = t.trackingTimeline;
    await pumpApp(
      tester,
      Scaffold(
        body: SingleChildScrollView(
          child: OrderTimeLine(
            steps: steps,
            currentStep: t.uiStepIndex,
          ),
        ),
      ),
    );

    expect(find.text(AppString.trackingStepReceived), findsOneWidget);
    expect(find.text(AppString.trackingStepPreparing), findsOneWidget);
    expect(find.text(AppString.trackingStepOutForDelivery), findsOneWidget);
    expect(find.text(AppString.statusDelivered), findsOneWidget);

    // The picked-up moment is read as the "Out for delivery" step's own time.
    expect(steps[2].occurredAt, DateTime.utc(2024, 9, 3, 12));
    expect(
      find.text(steps[0].occurredAt!.trackingTimelineLabel),
      findsOneWidget,
    );
    expect(
      find.text(steps[2].occurredAt!.trackingTimelineLabel),
      findsOneWidget,
    );
  });
}
