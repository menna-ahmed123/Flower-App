import 'package:flower_app/features/order/presentation/order_tracking/view/page/order_success_page.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../helpers/pump_app.dart';

void main() {
  testWidgets('shows the success message and Track Order button', (tester) async {
    await pumpApp(tester, OrderSuccessPage(onTrackOrder: () {}));
    expect(find.textContaining('Placed'), findsOneWidget);
    expect(find.text('Track Order'), findsOneWidget);
  });

  testWidgets('Track Order calls the callback (no navigation inside the page)', (tester) async {
    var taps = 0;
    await pumpApp(tester, OrderSuccessPage(onTrackOrder: () => taps++));
    await tester.tap(find.text('Track Order'));
    expect(taps, 1);
  });
}
