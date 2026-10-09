
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebView extends StatefulWidget {
  const PaymentWebView({
    super.key,
    required this.sessionUrl,
    required this.successUrl,
    required this.cancelUrl,
  });

  final String sessionUrl;
  final String successUrl;
  final String cancelUrl;

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late final WebViewController _controller;

  bool _isLoading = true;
  bool _hasError = false;
  bool _resultHandled = false;
  bool _invalidSessionUrl = false;

  @override
  void initState() {
    super.initState();

    final sessionUri = Uri.tryParse(widget.sessionUrl.trim());

    _invalidSessionUrl = sessionUri == null ||
        sessionUri.scheme.toLowerCase() != 'https' ||
        sessionUri.host.isEmpty;

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            if (_matchesUrl(request.url, widget.successUrl)) {
              _finishPayment(true);
              return NavigationDecision.prevent;
            }

            if (_matchesUrl(request.url, widget.cancelUrl)) {
              _finishPayment(false);
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
          onPageStarted: (_) {
            if (!mounted || _resultHandled) return;

            setState(() {
              _isLoading = true;
              _hasError = false;
            });
          },
          onPageFinished: (_) {
            if (!mounted || _resultHandled) return;

            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (error) {
            if (error.isForMainFrame == false ||
                !mounted ||
                _resultHandled) {
              return;
            }

            setState(() {
              _isLoading = false;
              _hasError = true;
            });
          },
        ),
      );

   if (_invalidSessionUrl) {
  _isLoading = false;
  _hasError = true;
} else {
  _controller.loadRequest(sessionUri!);
}
  }

  bool _matchesUrl(String currentUrl, String targetUrl) {
    final current = Uri.tryParse(currentUrl.trim());
    final target = Uri.tryParse(targetUrl.trim());

    if (current == null || target == null) return false;

    return current.scheme.toLowerCase() == 'https' &&
        target.scheme.toLowerCase() == 'https' &&
        current.host.isNotEmpty &&
        current.host.toLowerCase() == target.host.toLowerCase() &&
        current.port == target.port &&
        _normalizePath(current.path) == _normalizePath(target.path);
  }

  String _normalizePath(String path) {
    if (path.length > 1 && path.endsWith('/')) {
      return path.substring(0, path.length - 1);
    }

    return path;
  }

  void _finishPayment(bool success) {
    if (_resultHandled || !mounted) return;

    _resultHandled = true;
    context.pop<bool>(success);
  }

  void _retryLoading() {
    if (_invalidSessionUrl || _resultHandled) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    _controller.loadRequest(
      Uri.parse(widget.sessionUrl.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _finishPayment(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppString.payment),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => _finishPayment(false),
          ),
        ),
        body: _hasError
            ? _buildErrorView()
            : Stack(
                children: [
                  WebViewWidget(controller: _controller),
                  if (_isLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
            ),
            const SizedBox(height: 12),
            const Text(
              AppString.unableToLoadPaymentPage,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    _invalidSessionUrl ? null : _retryLoading,
                child: const Text(AppString.retry),
              ),
            ),
            TextButton(
              onPressed: () => _finishPayment(false),
              child: const Text(AppString.cancel),
            ),
          ],
        ),
      ),
    );
  }
}