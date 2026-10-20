import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/features/order/presentation/my_orders/view/widgets/orders_error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../helpers/pump_app.dart';

void main() {
  testWidgets('shows the message and a working retry', (tester) async {
    var retries = 0;
    await pumpApp(
      tester,
      Scaffold(
        body: OrdersErrorView(
          message: 'Boom',
          onRetry: () => retries++,
        ),
      ),
    );

    expect(find.text('Boom'), findsOneWidget);

    await tester.tap(find.text(AppString.retry));

    expect(retries, 1);
  });
}
