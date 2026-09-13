sealed class OccasionEvent {
  const OccasionEvent();
}

class LoadOccasions extends OccasionEvent {
  const LoadOccasions();
}

class SelectOccasionTab extends OccasionEvent {
  final String occasionId;
  final String tab;

  const SelectOccasionTab({required this.occasionId, required this.tab});
}
