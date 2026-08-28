sealed class SearchEvent {}

class SearchQueryChanged extends SearchEvent {
  SearchQueryChanged(this.query);

  final String query;
}

class SearchSubmitted extends SearchEvent {
  SearchSubmitted(this.query);

  final String query;
}

class SearchCleared extends SearchEvent {}
