enum Gender { female, male }

extension GenderApiValue on Gender {
  String get apiValue => switch (this) {
    Gender.female => 'Female',
    Gender.male => 'Male',
  };
}


extension GenderParsing on Gender {
  static Gender? fromApiValue(String? value) {
    return switch (value) {
      'Female' => Gender.female,
      'Male' => Gender.male,
      _ => null,
    };
  }
}
