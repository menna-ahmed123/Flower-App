import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/features/order/presentation/my_orders/view/widgets/load_more_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../helpers/pump_app.dart';

void main() {
  testWidgets('renders the label and fires the callback when tapped',
      (tester) async {
    var taps = 0;
    await pumpApp(
      tester,
      Scaffold(body: LoadMoreButton(onPressed: () => taps++)),
    );

    await tester.tap(find.text(AppString.loadMore));

    expect(taps, 1);
  });
}
