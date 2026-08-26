import 'package:freezed_annotation/freezed_annotation.dart';

import '../../pending_action.dart';

part 'auth_event.freezed.dart';

@freezed
abstract class AuthEvent with _$AuthEvent {
  const factory AuthEvent.authCheckRequested() = AuthCheckRequested;

  const factory AuthEvent.authLogoutRequested() = AuthLogoutRequested;

  const factory AuthEvent.authGuestRequested() = AuthGuestRequested;

  const factory AuthEvent.authAuthenticationRequired({
    PendingAction? pendingAction,
  }) = AuthAuthenticationRequired;

  const factory AuthEvent.authLoginSucceeded() = AuthLoginSucceeded;

  const factory AuthEvent.authAuthenticationCancelled() =
      AuthAuthenticationCancelled;
}