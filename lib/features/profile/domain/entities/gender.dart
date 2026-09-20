enum Gender {
  female,
  male;

  static Gender? fromString(String? value) {
    return switch (value?.toLowerCase()) {
      'female' => Gender.female,
      'male' => Gender.male,
      _ => null,
    };
  }
}

extension GenderApiValue on Gender {
  String get apiValue => switch (this) {
    Gender.female => 'Female',
    Gender.male => 'Male',
  };
}

