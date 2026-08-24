import 'package:flower_app/app/router/app_routes.dart';
import 'package:flower_app/core/auth/auth_guard.dart';
import 'package:flower_app/core/di/di.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthGuardPage extends StatefulWidget {
  const AuthGuardPage({super.key, required this.child});

  final Widget child;

  @override
  State<AuthGuardPage> createState() => _AuthGuardPageState();
}

class _AuthGuardPageState extends State<AuthGuardPage> {
  bool _isChecking = true;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuth();
    });
  }

  Future<void> _checkAuth() async {
    final isAuthenticated = await getIt<AuthGuard>().isAuthenticated();

    if (!mounted) return;

    if (!isAuthenticated) {
      await getIt<AuthGuard>().requireAuth(context);

      if (!mounted) return;

      context.go(AppRoutesName.home);
      return;
    }

    setState(() {
      _isAuthenticated = true;
      _isChecking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking || !_isAuthenticated) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return widget.child;
  }
}
