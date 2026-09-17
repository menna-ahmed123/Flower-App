import 'package:flower_app/app/router/app_routes.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Arguments for [AppRoutesName.webView]: the page to load and the title
/// shown in the app bar.
class WebViewArgs {
  const WebViewArgs({required this.url, required this.title});

  final String url;
  final String title;
}

/// Generic in-app browser for static hosted pages (About Us, Terms &
/// Conditions, ...). Reusable across features via [AppRoutesName.webView].
class AppWebViewScreen extends StatefulWidget {
  const AppWebViewScreen({super.key, required this.url, required this.title});

  final String url;
  final String title;

  @override
  State<AppWebViewScreen> createState() => _AppWebViewScreenState();
}

class _AppWebViewScreenState extends State<AppWebViewScreen> {
  late final WebViewController _controller = _buildController();

  bool _isLoading = true;
  bool _hasError = false;

  WebViewController _buildController() {
    return WebViewController()
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

  void _onBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutesName.profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.title, onBack: _onBack),
      body: SafeArea(
        child: Stack(
          children: [
            if (!_hasError) WebViewWidget(controller: _controller),
            if (_isLoading && !_hasError)
              const Center(child: CircularProgressIndicator()),
            if (_hasError) _buildError(),
          ],
        ),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(AppString.somethingWrong, textAlign: TextAlign.center),
          SizedBox(height: 12.h),
          TextButton(
            onPressed: () {
              _setLoading();
              _controller.reload();
            },
            child: const Text(AppString.retry),
          ),
        ],
      ),
    );
  }
}
