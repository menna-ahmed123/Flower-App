enum Gender { female, male }

extension GenderApiValue on Gender {
  String get apiValue => switch (this) {
    Gender.female => 'Female',
    Gender.male => 'Male',
  };
}
