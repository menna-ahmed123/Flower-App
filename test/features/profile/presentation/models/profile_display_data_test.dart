import 'package:flower_app/features/profile/domain/entities/gender.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flower_app/features/profile/presentation/models/profile_display_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('resolves the server profile picture through the configured resolver', () {
    const profile = ProfileEntity(
      id: 'u1',
      firstName: 'Ahmed',
      lastName: 'Osama',
      email: 'ahmed@example.com',
      phoneNumber: '01000000000',
      gender: Gender.male,
      profilePictureUrl: 'Storage/Users/u1/avatar.jpg',
    );

    final displayData = ProfileDisplayData.fromEntity(
      profile,
      mediaUrlResolver: (path) => 'https://api.example.com/$path',
    );

    expect(
      displayData.photoUrl,
      'https://api.example.com/Storage/Users/u1/avatar.jpg',
    );
  });
}