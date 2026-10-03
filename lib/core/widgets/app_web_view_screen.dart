import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/widgets/custom_app_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Arguments for the app's web-view route: the page to load and the title
/// shown in the app bar.
class WebViewArgs {
  const WebViewArgs({required this.url, required this.title});

  final String url;
  final String title;
}

class AppWebViewScreen extends StatefulWidget {
  const AppWebViewScreen({
    super.key,
    required this.url,
    required this.title,
    @visibleForTesting this.controller,
  });

  final String url;
  final String title;

  /// Overrides the real controller in tests; production callers should
  /// leave this null.
  @visibleForTesting
  final WebViewController? controller;

  @override
  State<AppWebViewScreen> createState() => _AppWebViewScreenState();
}

class _AppWebViewScreenState extends State<AppWebViewScreen> {
  late final WebViewController _controller;

  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = _configure(widget.controller ?? WebViewController());
  }

  @override
  void didUpdateWidget(covariant AppWebViewScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.url != oldWidget.url) {
      _setLoading();
      _controller.loadRequest(Uri.parse(widget.url));
    }
  }

  WebViewController _configure(WebViewController controller) {
    return controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => _setLoading(),
          onPageFinished: (_) => setState(() => _isLoading = false),
          onWebResourceError: (_) => _setError(),
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  void _setLoading() {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
  }

  void _setError() {
    setState(() {
      _isLoading = false;
      _hasError = true;
    });
  }

  void _retry() {
    _setLoading();
    _controller.reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.title,
        onBack: () => Navigator.of(context).maybePop(),
      ),
      body: SafeArea(
        child: WebViewContentSwitcher(
          isLoading: _isLoading,
          hasError: _hasError,
          onRetry: _retry,
          webView: WebViewWidget(controller: _controller),
        ),
      ),
    );
  }
}


class WebViewContentSwitcher extends StatelessWidget {
  const WebViewContentSwitcher({
    super.key,
    required this.isLoading,
    required this.hasError,
    required this.onRetry,
    required this.webView,
  });

  final bool isLoading;
  final bool hasError;
  final VoidCallback onRetry;
  final Widget webView;

  @override
  Widget build(BuildContext context) {
    if (hasError) {
      return _WebViewErrorView(onRetry: onRetry);
    }

    return Stack(
      children: [
        webView,
        if (isLoading) const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}

class _WebViewErrorView extends StatelessWidget {
  const _WebViewErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(AppString.somethingWrong, textAlign: TextAlign.center),
          SizedBox(height: 12.h),
          TextButton(onPressed: onRetry, child: const Text(AppString.retry)),
        ],
      ),
    );
  }
}
