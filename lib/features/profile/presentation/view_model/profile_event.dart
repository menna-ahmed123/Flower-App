sealed class ProfileEvent {}

/// Dispatched once when the screen is first built. The ViewModel (not the
/// View) decides whether a network call is actually needed, based on its
/// own state, so the View never has to query ViewModel state directly.
class ProfileInitialized extends ProfileEvent {}

class ProfileRequested extends ProfileEvent {}

/// Toggling the notification switch is UI-only for now (no
/// notification-preferences API exists yet), but it still flows through the
/// ViewModel rather than being held as View-local state, so the switch's
/// value stays part of the single source of truth (ProfileState).
class NotificationToggleChanged extends ProfileEvent {
  NotificationToggleChanged(this.isEnabled);

  final bool isEnabled;
}
