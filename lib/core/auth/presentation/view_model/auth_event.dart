import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.freezed.dart';

@freezed
abstract class AuthEvent with _$AuthEvent {
  const factory AuthEvent.authCheckRequested() = AuthCheckRequested;

  const factory AuthEvent.authLogoutRequested() = AuthLogoutRequested;

  const factory AuthEvent.authGuestRequested() = AuthGuestRequested;
}
