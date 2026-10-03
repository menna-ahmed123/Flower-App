import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/widgets/app_web_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

// WebViewController needs a real platform implementation (method channels)
// that flutter_test doesn't provide, so AppWebViewScreen itself isn't
// instantiated here. WebViewContentSwitcher is the extracted, state-driven
// piece of its UI (loading / error / content), and it's plain Flutter with
// no platform dependency, so it's tested directly instead.
void main() {
  Future<void> pumpSwitcher(
    WidgetTester tester, {
    required bool isLoading,
    required bool hasError,
    required VoidCallback onRetry,
  }) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, _) => MaterialApp(
          home: Scaffold(
            body: WebViewContentSwitcher(
              isLoading: isLoading,
              hasError: hasError,
              onRetry: onRetry,
              webView: const Text('WEB_PAGE_CONTENT'),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('shows a loading indicator over the page while loading', (
    tester,
  ) async {
    await pumpSwitcher(
      tester,
      isLoading: true,
      hasError: false,
      onRetry: () {},
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('WEB_PAGE_CONTENT'), findsOneWidget);
  });

  testWidgets('hides the loading indicator once loaded', (tester) async {
    await pumpSwitcher(
      tester,
      isLoading: false,
      hasError: false,
      onRetry: () {},
    );

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('WEB_PAGE_CONTENT'), findsOneWidget);
  });

  testWidgets('shows a retryable error view instead of the page on error', (
    tester,
  ) async {
    await pumpSwitcher(
      tester,
      isLoading: false,
      hasError: true,
      onRetry: () {},
    );

    expect(find.text('WEB_PAGE_CONTENT'), findsNothing);
    expect(find.text(AppString.somethingWrong), findsOneWidget);
    expect(find.text(AppString.retry), findsOneWidget);
  });

  testWidgets('tapping retry calls onRetry', (tester) async {
    var retried = false;

    await pumpSwitcher(
      tester,
      isLoading: false,
      hasError: true,
      onRetry: () => retried = true,
    );

    await tester.tap(find.text(AppString.retry));
    await tester.pump();

    expect(retried, isTrue);
  });
}
