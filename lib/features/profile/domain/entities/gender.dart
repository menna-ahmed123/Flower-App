enum Gender {
  male(0),
  female(1);

  const Gender(this.value);

  final int value;

  // TODO: confirm with backend: 0 = Male and 1 = Female.
  static Gender fromValue(int? value) {
    return switch (value) {
      0 => Gender.male,
      1 => Gender.female,
      _ => Gender.male,
    };
  }
}

extension GenderApiValue on Gender {
  String get apiValue => switch (this) {
    Gender.female => 'Female',
    Gender.male => 'Male',
  };
}

