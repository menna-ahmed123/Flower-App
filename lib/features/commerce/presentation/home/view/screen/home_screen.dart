import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../app/router/app_routes.dart';
import '../../../../../../core/auth/auth_guard.dart';
import '../../../../../../core/di/di.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Test Home Screen')
        ),
        body: Center(child: ElevatedButton(onPressed: () async {
          await getIt<AuthGuard>().requireAuth(
            context,
            pendingAction: () async {
              if (!context.mounted) return;
              context.push(AppRoutesName.profile);
            },
          );
        }, child: Text('Go to Profile Screen'),),
        )
    );
  }
}