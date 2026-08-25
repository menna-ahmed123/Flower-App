sealed class HomeEvent {}

class HomeRequested extends HomeEvent {}

class HomeQueryChanged extends HomeEvent {
  HomeQueryChanged(this.query);

  final String query;
}
