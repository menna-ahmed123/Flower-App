import 'package:flower_app/features/order/presentation/order_tracking/view/widgets/driver_marker_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../helpers/pump_app.dart';

void main() {
  testWidgets('renders the scooter SVG at the requested size', (tester) async {
    await pumpApp(tester, const Scaffold(body: Center(child: DriverMarkerIcon(size: 60))));
    expect(find.byType(SvgPicture), findsOneWidget);
    expect(tester.getSize(find.byType(DriverMarkerIcon)), const Size(60, 60));
  });
}
