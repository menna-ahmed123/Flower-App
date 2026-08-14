import 'package:flutter/material.dart';

/// Shows a one-shot success [SnackBar] after the route is built.
class RouteSuccessSnackBar extends StatefulWidget {
  const RouteSuccessSnackBar({
    super.key,
    required this.child,
    this.message,
  });

  final Widget child;
  final String? message;

  @override
  State<RouteSuccessSnackBar> createState() => _RouteSuccessSnackBarState();
}

class _RouteSuccessSnackBarState extends State<RouteSuccessSnackBar> {
  @override
  void initState() {
    super.initState();
    _showSuccessMessage();
  }

  void _showSuccessMessage() {
    final message = widget.message;
    if (message == null || message.isEmpty) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
