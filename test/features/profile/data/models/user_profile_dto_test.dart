import 'package:flower_app/features/auth/register/domain/entity/gender.dart';
import 'package:flower_app/features/profile/data/models/user_profile_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserProfileDto.toDomain', () {
    test('maps a customer profile with null driver-only fields', () {
      final dto = UserProfileDto(
        userId: 'u1',
        fullName: 'Nour Mohamed',
        firstName: 'Nour',
        lastName: 'Mohamed',
        email: 'nour@example.com',
        phoneNumber: '01010000001',
        gender: 'Female',
        profilePictureUrl: '/uploads/avatars/a.jpg',
        roles: const ['Customer'],
        emailChanged: false,
      );

      final entity = dto.toDomain();

      expect(entity.gender, Gender.female);
      expect(entity.vehicleType, isNull);
      expect(entity.vehiclePlateNumber, isNull);
      expect(entity.country, isNull);
    });

    test('maps a driver profile carrying the driver-only fields', () {
      final dto = UserProfileDto(
        userId: 'u2',
        fullName: 'Omar Khaled',
        firstName: 'Omar',
        lastName: 'Khaled',
        email: 'omar@example.com',
        phoneNumber: '01010000002',
        gender: 'Male',
        profilePictureUrl: null,
        roles: const ['Driver'],
        emailChanged: false,
        vehicleType: 'Car',
        vehiclePlateNumber: 'UP16DL0007',
        country: 'Egypt',
      );

      final entity = dto.toDomain();

      expect(entity.vehicleType, 'Car');
      expect(entity.vehiclePlateNumber, 'UP16DL0007');
      expect(entity.country, 'Egypt');
    });
  });
}
