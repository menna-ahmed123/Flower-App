enum Gender { female, male }

extension GenderApiValue on Gender {
  int get apiValue => switch (this) {
    Gender.male => 0,
    Gender.female => 1,
  };
}
