import 'package:flower_app/features/profile/data/models/user_profile_dto.dart';
import 'package:flower_app/features/profile/domain/entities/gender.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  UserProfileDto buildDto({String? gender}) {
    return UserProfileDto(
      userId: 'u1',
      fullName: 'Nour Mohamed',
      firstName: 'Nour',
      lastName: 'Mohamed',
      email: 'nour@example.com',
      phoneNumber: '01010000001',
      gender: gender,
      profilePictureUrl: '/media/avatar.png',
      roles: const ['Customer'],
    );
  }

  test('maps a known gender value to the matching enum', () {
    final entity = buildDto(gender: 'Female').toDomain();

    expect(entity.gender, Gender.female);
  });

  test('maps the other known gender value to the matching enum', () {
    final entity = buildDto(gender: 'Male').toDomain();

    expect(entity.gender, Gender.male);
  });

  test('maps an unrecognized gender string to null instead of throwing', () {
    final entity = buildDto(gender: 'unspecified').toDomain();

    expect(entity.gender, isNull);
  });

  test('maps a null gender to null', () {
    final entity = buildDto(gender: null).toDomain();

    expect(entity.gender, isNull);
  });

  test('carries the rest of the fields through unchanged', () {
    final entity = buildDto(gender: 'Female').toDomain();

    expect(entity.userId, 'u1');
    expect(entity.fullName, 'Nour Mohamed');
    expect(entity.firstName, 'Nour');
    expect(entity.lastName, 'Mohamed');
    expect(entity.email, 'nour@example.com');
    expect(entity.phoneNumber, '01010000001');
    expect(entity.profilePictureUrl, '/media/avatar.png');
    expect(entity.roles, const ['Customer']);
  });

  test('maps null optional fields through as null', () {
    final dto = UserProfileDto(
      userId: 'u1',
      fullName: 'Nour Mohamed',
      firstName: 'Nour',
      lastName: 'Mohamed',
      roles: const [],
    );

    final entity = dto.toDomain();

    expect(entity.email, isNull);
    expect(entity.phoneNumber, isNull);
    expect(entity.gender, isNull);
    expect(entity.profilePictureUrl, isNull);
  });
}
