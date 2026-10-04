import 'package:flower_app/features/sessions/domain/entities/session_entity.dart';
import 'package:flower_app/features/sessions/presentation/view_model/session_event.dart';
import 'package:flower_app/features/sessions/presentation/view_model/session_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../view_model/session_view_model.dart';

class SessionsScreen extends StatelessWidget {
  const SessionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Sessions'),
      ),
      body: BlocConsumer<SessionsViewModel, SessionsState>(
        listenWhen: (previous, current) {
          final previousError = previous.sessionsState.errorMessage;
          final currentError = current.sessionsState.errorMessage;

          return previousError.isEmpty && currentError.isNotEmpty;
        },
        listener: (context, state) {
          if (state.sessionsState.data != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.sessionsState.errorMessage),
              ),
            );
          }
        },
        builder: (context, state) {
          final sessionsState = state.sessionsState;

          if (sessionsState.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (sessionsState.errorMessage.isNotEmpty &&
              sessionsState.data == null) {
            return _ErrorView(
              message: sessionsState.errorMessage,
              onRetry: () {
                context.read<SessionsViewModel>().onEvent(
                  LoadSessions(),
                );
              },
            );
          }

          final sessions = sessionsState.data ?? [];

          if (sessions.isEmpty) {
            return const Center(
              child: Text('No active sessions found'),
            );
          }

          return RefreshIndicator(
            onRefresh: () {
              return context.read<SessionsViewModel>().onEvent(
                LoadSessions(),
              );
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: sessions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _SessionCard(
                  session: sessions[index],
                  isRevoking:
                  state.revokingSessionId == sessions[index].id,
                  onRevoke: () {
                    final sessionId = sessions[index].id;

                    if (sessionId == null) {
                      return;
                    }

                    context.read<SessionsViewModel>().onEvent(
                      RevokeSession(sessionId),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  const _SessionCard({
    required this.session,
    required this.isRevoking,
    required this.onRevoke,
  });

  final SessionEntity session;
  final bool isRevoking;
  final VoidCallback onRevoke;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.devices_outlined),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    session.deviceName ?? 'Unknown device',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _SessionInfo(
              label: 'Last active',
              value: session.lastActiveAt ?? 'Unknown',
            ),
            _SessionInfo(
              label: 'Location / IP',
              value: session.approximateLocationOrIp ?? 'Unknown',
            ),
            _SessionInfo(
              label: 'Expires',
              value: session.expiresAt ?? 'Unknown',
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: isRevoking ? null : onRevoke,
                child: isRevoking
                    ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
                    : const Text('Revoke Session'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SessionInfo extends StatelessWidget {
  const _SessionInfo({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}