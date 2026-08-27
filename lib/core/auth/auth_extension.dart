import 'package:flower_app/core/auth/pending_action.dart';
import 'package:flower_app/core/auth/presentation/view_model/auth_cubit.dart';
import 'package:flower_app/core/auth/presentation/view_model/auth_event.dart';
import 'package:flower_app/core/auth/presentation/view_model/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension AuthContextExtension on BuildContext {
  Future<bool> requireAuth({required PendingAction action}) async {
    final authCubit = read<AuthCubit>();

    if (authCubit.state.isAuthenticated) {
      await action();
      return true;
    }

    await authCubit.doEvent(
      AuthEvent.authAuthenticationRequired(pendingAction: action),
    );
    return false;
  }
}
