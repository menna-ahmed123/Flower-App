import 'dart:async';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flutter/material.dart';

class ResendCodeButton extends StatefulWidget {
  const ResendCodeButton({
    super.key,
    required this.onResend,
    this.cooldownSeconds = 30,
  });

  final VoidCallback onResend;
  final int cooldownSeconds;

  @override
  State<ResendCodeButton> createState() => _ResendCodeButtonState();
}

class _ResendCodeButtonState extends State<ResendCodeButton> {
  Timer? _timer;
  late int _remainingSeconds;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.cooldownSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _remainingSeconds = widget.cooldownSeconds);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 1) {
        timer.cancel();
        setState(() => _remainingSeconds = 0);
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  void _handleTap() {
    if (_remainingSeconds > 0) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text(AppString.pleaseWaitBeforeResend)),
        );
      return;
    }

    widget.onResend();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = _remainingSeconds == 0;

    return GestureDetector(
      onTap: _handleTap,
      child: Text(
        isEnabled
            ? AppString.resend
            : '${AppString.resend} (${_remainingSeconds}s)',
        style: TextStyle(
          color: isEnabled ? Colors.pink : Colors.grey,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
