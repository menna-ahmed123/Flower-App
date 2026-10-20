sealed class HomeEvent {}

class HomeRequested extends HomeEvent {}

class HomeNotificationPermissionRequested extends HomeEvent {
  HomeNotificationPermissionRequested({required this.notificationsEnabled});

  final bool notificationsEnabled;
}

class HomeNotificationSettingsRequested extends HomeEvent {}

class HomeNotificationSettingsPromptDismissed extends HomeEvent {}
