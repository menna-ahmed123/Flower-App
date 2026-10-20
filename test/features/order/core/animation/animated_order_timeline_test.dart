import 'package:flower_app/features/order/core/animation/order_time_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const steps = [
    (title: 'Received your order', time: '10:00'),
    (title: 'Preparing your order', time: '10:20'),
    (title: 'Out for delivery', time: ''),
    (title: 'Delivered', time: ''),
  ];

  testWidgets('renders every step title', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: const AnimatedOrderTimeline(currentStep: 1, steps: steps),
          ),
        ),
      ),
    );
    for (final s in steps) {
      expect(find.text(s.title), findsOneWidget);
    }
  });

  testWidgets('done steps show a check, the current step pulses',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: const AnimatedOrderTimeline(currentStep: 2, steps: steps),
          ),
        ),
      ),
    );
    // steps 0 and 1 are before currentStep 2 -> two checks.
    expect(find.byIcon(Icons.check), findsNWidgets(2));
    // the current step's pulsing dot lives in a ScaleTransition (bounded: the
    // route's zoom transition adds one of its own outside the timeline).
    expect(
      find.descendant(
        of: find.byType(AnimatedOrderTimeline),
        matching: find.byType(ScaleTransition),
      ),
      findsOneWidget,
    );
  });

  testWidgets('current step title is emphasised (bolder weight)',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: const AnimatedOrderTimeline(currentStep: 0, steps: steps),
          ),
        ),
      ),
    );
    final current = tester.widget<Text>(find.text('Received your order'));
    final future = tester.widget<Text>(find.text('Preparing your order'));
    expect(current.style?.fontWeight, FontWeight.w700);
    expect(future.style?.fontWeight, FontWeight.w500);
  });

  testWidgets('empty timestamps render an empty time line without crashing',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: const AnimatedOrderTimeline(currentStep: 3, steps: steps),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });
}
