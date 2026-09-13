sealed class OccasionEvent {}

class LoadOccasions extends OccasionEvent {}

class SelectOccasionTab extends OccasionEvent {
  final String occasionId;
  final String tab;

  SelectOccasionTab({required this.occasionId, required this.tab});
}