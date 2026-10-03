import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flower_app/core/base/api_response.dart';
import 'package:flower_app/features/profile/data/api/profile_api_client.dart';
import 'package:flower_app/features/profile/data/data_source/remote/profile_remote_data_source_impl.dart';
import 'package:flower_app/features/profile/data/models/profile_model.dart';
import 'package:flower_app/features/profile/data/models/update_profile_request.dart';
import 'package:flower_app/features/profile/domain/entities/gender.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'profile_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([ProfileApiClient])
void main() {
  test('sends the new multipart update fields without email', () async {
    final apiClient = MockProfileApiClient();
    final dataSource = ProfileRemoteDataSourceImpl(apiClient);
    final request = UpdateProfileRequest(
      firstName: 'Menna',
      lastName: 'Ahmed',
      phoneNumber: '01000000000',
      gender: Gender.female,
    );
    const response = ApiResponse<ProfileModel>(
      status: true,
      code: 200,
      message: 'success',
      data: null,
    );
    when(
      apiClient.updateMyProfile('Menna', 'Ahmed', '01000000000', '1', null),
    ).thenAnswer((_) async => response);

    final result = await dataSource.updateMyProfile(updateProfileRequest: request);

    expect(result, response);
    verify(apiClient.updateMyProfile('Menna', 'Ahmed', '01000000000', '1', null)).called(1);
  });

  test('converts a selected local file to a multipart profile part', () async {
    final apiClient = MockProfileApiClient();
    final dataSource = ProfileRemoteDataSourceImpl(apiClient);
    final directory = await Directory.systemTemp.createTemp('profile-test');
    final imageFile = File('${directory.path}/avatar.jpg');
    await imageFile.writeAsBytes(List<int>.filled(10, 1));
    final request = UpdateProfileRequest(
      firstName: 'Menna',
      lastName: 'Ahmed',
      phoneNumber: '01000000000',
      gender: Gender.female,
      profilePicture: imageFile,
    );
    const response = ApiResponse<ProfileModel>(
      status: true,
      code: 200,
      message: 'success',
      data: null,
    );
    when(
      apiClient.updateMyProfile('Menna', 'Ahmed', '01000000000', '1', any),
    ).thenAnswer((_) async => response);

    final result = await dataSource.updateMyProfile(updateProfileRequest: request);

    expect(result, response);
    final captured = verify(
      apiClient.updateMyProfile(
        'Menna',
        'Ahmed',
        '01000000000',
        '1',
        captureAny,
      ),
    ).captured.single as MultipartFile;
    expect(captured.filename, 'avatar.jpg');
    await directory.delete(recursive: true);
  });
}
