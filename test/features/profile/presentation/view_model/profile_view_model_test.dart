import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/profile/domain/entities/update_profile_params.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flower_app/features/profile/domain/use_case/get_profile_use_case.dart';
import 'package:flower_app/features/profile/domain/use_case/update_profile_use_case.dart';
import 'package:flower_app/features/profile/presentation/view_model/profile_event.dart';
import 'package:flower_app/features/profile/presentation/view_model/profile_state.dart';
import 'package:flower_app/features/profile/presentation/view_model/profile_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'profile_view_model_test.mocks.dart';

@GenerateMocks([GetProfileUseCase, UpdateProfileUseCase])
void main() {
  provideDummy<BaseResponse<ProfileEntity>>(
    const SuccessResponse<ProfileEntity>(_profile),
  );

  late MockGetProfileUseCase getProfileUseCase;
  late MockUpdateProfileUseCase updateProfileUseCase;

  setUp(() {
    getProfileUseCase = MockGetProfileUseCase();
    updateProfileUseCase = MockUpdateProfileUseCase();
  });

  ProfileViewModel buildViewModel() {
    return ProfileViewModel(getProfileUseCase, updateProfileUseCase);
  }

  group('ProfileRequested', () {
    blocTest<ProfileViewModel, ProfileState>(
      'emits loading then success on ProfileRequested',
      build: () {
        when(
          getProfileUseCase(),
        ).thenAnswer((_) async => const SuccessResponse(_profile));
        return buildViewModel();
      },
      act: (cubit) => cubit.doEvent(ProfileRequested()),
      expect: () => [
        isA<ProfileState>().having(
          (s) => s.profileState.isLoading,
          'isLoading',
          true,
        ),
        isA<ProfileState>()
            .having((s) => s.profileState.isLoading, 'isLoading', false)
            .having((s) => s.profileState.data, 'data', _profile),
      ],
    );

    blocTest<ProfileViewModel, ProfileState>(
      'emits loading then error on failure',
      build: () {
        when(getProfileUseCase()).thenAnswer(
          (_) async => ErrorResponse(appError: BadResponseError('failed')),
        );
        return buildViewModel();
      },
      act: (cubit) => cubit.doEvent(ProfileRequested()),
      expect: () => [
        isA<ProfileState>().having(
          (s) => s.profileState.isLoading,
          'isLoading',
          true,
        ),
        isA<ProfileState>()
            .having((s) => s.profileState.isLoading, 'isLoading', false)
            .having((s) => s.profileState.errorMessage, 'errorMessage', 'failed'),
      ],
    );
  });

  group('ProfileUpdateRequested', () {
    const params = UpdateProfileParams(
      fullName: 'Mariam Ahmed',
      email: 'mariam@example.com',
      phoneNumber: '01010000001',
      gender: 'Female',
    );

    blocTest<ProfileViewModel, ProfileState>(
      'emits update loading then success and refreshes profileState',
      build: () {
        when(
          updateProfileUseCase(params),
        ).thenAnswer((_) async => const SuccessResponse(_profile));
        return buildViewModel();
      },
      act: (cubit) => cubit.doEvent(ProfileUpdateRequested(params)),
      expect: () => [
        isA<ProfileState>().having(
          (s) => s.updateState.isLoading,
          'isLoading',
          true,
        ),
        isA<ProfileState>()
            .having((s) => s.updateState.isLoading, 'isLoading', false)
            .having((s) => s.updateState.data, 'data', _profile)
            .having((s) => s.profileState.data, 'profileState.data', _profile)
            .having((s) => s.requiresReauth, 'requiresReauth', false),
      ],
    );

    blocTest<ProfileViewModel, ProfileState>(
      'emits update loading then error on validation failure',
      build: () {
        when(updateProfileUseCase(params)).thenAnswer(
          (_) async =>
              ErrorResponse(appError: BadResponseError('Email already registered')),
        );
        return buildViewModel();
      },
      act: (cubit) => cubit.doEvent(ProfileUpdateRequested(params)),
      expect: () => [
        isA<ProfileState>().having(
          (s) => s.updateState.isLoading,
          'isLoading',
          true,
        ),
        isA<ProfileState>().having(
          (s) => s.updateState.errorMessage,
          'errorMessage',
          'Email already registered',
        ),
      ],
    );

    blocTest<ProfileViewModel, ProfileState>(
      'requiresReauth becomes true when the update response reports emailChanged',
      build: () {
        when(updateProfileUseCase(params)).thenAnswer(
          (_) async => const SuccessResponse(_profileWithEmailChanged),
        );
        return buildViewModel();
      },
      act: (cubit) => cubit.doEvent(ProfileUpdateRequested(params)),
      expect: () => [
        isA<ProfileState>().having(
          (s) => s.updateState.isLoading,
          'isLoading',
          true,
        ),
        isA<ProfileState>().having((s) => s.requiresReauth, 'requiresReauth', true),
      ],
    );
  });
}

const _profile = ProfileEntity(
  userId: 'u1',
  fullName: 'Mariam Ahmed',
  firstName: 'Mariam',
  lastName: 'Ahmed',
  email: 'mariam@example.com',
  phoneNumber: '01010000001',
  gender: null,
  profilePictureUrl: null,
  roles: ['Customer'],
  emailChanged: false,
);

const _profileWithEmailChanged = ProfileEntity(
  userId: 'u1',
  fullName: 'Mariam Ahmed',
  firstName: 'Mariam',
  lastName: 'Ahmed',
  email: 'mariam-new@example.com',
  phoneNumber: '01010000001',
  gender: null,
  profilePictureUrl: null,
  roles: ['Customer'],
  emailChanged: true,
);
