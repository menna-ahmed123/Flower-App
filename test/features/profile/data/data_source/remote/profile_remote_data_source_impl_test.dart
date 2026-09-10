import 'dart:io';

import 'package:flower_app/features/profile/data/api/profile_api_client.dart';
import 'package:flower_app/features/profile/data/data_source/remote/profile_remote_data_source_impl.dart';
import 'package:flower_app/features/profile/data/models/profile_response.dart';
import 'package:flower_app/features/profile/data/models/update_profile_request.dart';
import 'package:flower_app/features/profile/data/models/user_profile_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late _RecordingProfileApiClient apiClient;
  late ProfileRemoteDataSourceImpl dataSource;

  setUp(() {
    apiClient = _RecordingProfileApiClient();
    dataSource = ProfileRemoteDataSourceImpl(apiClient);
  });

  test('getMyProfile forwards the client response unchanged', () async {
    final response = await dataSource.getMyProfile();

    expect(response, same(apiClient.responseToReturn));
  });

  test('updateMyProfile forwards every request field, including the driver-only ones', () async {
    final request = UpdateProfileRequest(
      fullName: 'Mariam Ahmed',
      email: 'mariam@example.com',
      phoneNumber: '01010000001',
      gender: 'Female',
      vehicleType: 'Motorcycle',
      vehiclePlateNumber: 'UP16DL0007',
      country: 'Egypt',
    );

    await dataSource.updateMyProfile(request);

    expect(apiClient.lastFullName, 'Mariam Ahmed');
    expect(apiClient.lastEmail, 'mariam@example.com');
    expect(apiClient.lastPhoneNumber, '01010000001');
    expect(apiClient.lastGender, 'Female');
    expect(apiClient.lastProfilePicture, isNull);
    expect(apiClient.lastVehicleType, 'Motorcycle');
    expect(apiClient.lastVehiclePlateNumber, 'UP16DL0007');
    expect(apiClient.lastCountry, 'Egypt');
  });

  test('updateMyProfile omits driver-only fields when the request leaves them null', () async {
    const request = UpdateProfileRequest(
      fullName: 'Nour Mohamed',
      email: 'nour@example.com',
      phoneNumber: '01010000002',
      gender: 'Female',
    );

    await dataSource.updateMyProfile(request);

    expect(apiClient.lastVehicleType, isNull);
    expect(apiClient.lastVehiclePlateNumber, isNull);
    expect(apiClient.lastCountry, isNull);
  });
}

/// Hand-written fake for [ProfileApiClient] (a Retrofit-generated interface):
/// records the arguments [ProfileRemoteDataSourceImpl] forwards to it,
/// independent of the generated `_ProfileApiClient` implementation.
class _RecordingProfileApiClient implements ProfileApiClient {
  final responseToReturn = ProfileResponse(
    isSuccess: true,
    statusCode: 200,
    message: 'ok',
    data: UserProfileDto(
      userId: 'u1',
      fullName: 'Mariam Ahmed',
      firstName: 'Mariam',
      lastName: 'Ahmed',
      email: 'mariam@example.com',
      phoneNumber: '01010000001',
      gender: 'Female',
      profilePictureUrl: null,
      roles: const ['Customer'],
      emailChanged: false,
    ),
  );

  String? lastFullName;
  String? lastEmail;
  String? lastPhoneNumber;
  String? lastGender;
  File? lastProfilePicture;
  String? lastVehicleType;
  String? lastVehiclePlateNumber;
  String? lastCountry;

  @override
  Future<ProfileResponse> getMyProfile() async => responseToReturn;

  @override
  Future<ProfileResponse> updateMyProfile(
    String fullName,
    String email,
    String phoneNumber,
    String gender,
    File? profilePicture,
    String? vehicleType,
    String? vehiclePlateNumber,
    String? country,
  ) async {
    lastFullName = fullName;
    lastEmail = email;
    lastPhoneNumber = phoneNumber;
    lastGender = gender;
    lastProfilePicture = profilePicture;
    lastVehicleType = vehicleType;
    lastVehiclePlateNumber = vehiclePlateNumber;
    lastCountry = country;
    return responseToReturn;
  }
}
