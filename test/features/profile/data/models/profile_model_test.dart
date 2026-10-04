import 'package:flower_app/features/profile/data/models/profile_model.dart';
import 'package:flower_app/features/profile/domain/entities/gender.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps the new profile response shape to the domain entity', () {
    final entity = ProfileModel.fromJson({
      'id': 'u1',
      'firstName': 'Nour',
      'lastName': 'Mohamed',
      'email': 'nour@example.com',
      'phoneNumber': '01010000001',
      'gender': 1,
      'profilePictureUrl': '/media/avatar.png',
    }).toDomain();

    expect(entity.id, 'u1');
    expect(entity.firstName, 'Nour');
    expect(entity.lastName, 'Mohamed');
    expect(entity.gender, Gender.female);
    expect(entity.profilePictureUrl, '/media/avatar.png');
  });

  test('uses the safe male fallback for an unknown gender value', () {
    expect(Gender.fromValue(null), Gender.male);
    expect(Gender.fromValue(99), Gender.male);
  });
}