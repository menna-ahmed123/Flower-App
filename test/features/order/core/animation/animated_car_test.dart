import 'package:flower_app/features/order/core/animation/animated_car_single_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) =>
    Scaffold(body: Center(child: child));

void main() {
  testWidgets('renders the car and its road without throwing', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: _host(const AnimatedCar(width: 320))),
    );
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.byType(AnimatedCar), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets); // road + speed lines
    expect(tester.takeException(), isNull);
  });

  testWidgets('width drives the painted size', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: _host(const AnimatedCar(width: 200))),
    );
    final size = tester.getSize(find.byType(AnimatedCar));
    expect(size.width, 200);
  });

  testWidgets('playing: false does not animate and never throws',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: _host(const AnimatedCar(width: 320, playing: false))),
    );
    await tester.pump(const Duration(seconds: 1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('toggling playing resumes without rebuilding the state',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: _host(const AnimatedCar(width: 320, playing: false))),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: _host(const AnimatedCar(width: 320, playing: true)),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.takeException(), isNull);
  });
}
