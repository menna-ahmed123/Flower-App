import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flower_app/features/profile/domain/use_case/get_profile_use_case.dart';
import 'package:flower_app/features/profile/presentation/view_model/profile_event.dart';
import 'package:flower_app/features/profile/presentation/view_model/profile_state.dart';
import 'package:flower_app/features/profile/presentation/view_model/profile_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'profile_view_model_test.mocks.dart';

@GenerateMocks([GetProfileUseCase])
void main() {
  provideDummy<BaseResponse<ProfileEntity>>(
    const SuccessResponse<ProfileEntity>(_profile),
  );

  late MockGetProfileUseCase getProfileUseCase;

  setUp(() {
    getProfileUseCase = MockGetProfileUseCase();
  });

  ProfileViewModel buildViewModel() {
    return ProfileViewModel(getProfileUseCase);
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

  group('ProfileInitialized', () {
    blocTest<ProfileViewModel, ProfileState>(
      'fetches the profile when no data has been loaded yet',
      build: () {
        when(
          getProfileUseCase(),
        ).thenAnswer((_) async => const SuccessResponse(_profile));
        return buildViewModel();
      },
      act: (cubit) => cubit.doEvent(ProfileInitialized()),
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
      verify: (_) {
        verify(getProfileUseCase()).called(1);
      },
    );

    blocTest<ProfileViewModel, ProfileState>(
      "does nothing when the profile is already loaded, so the View can "
      'always dispatch it without checking ViewModel state itself',
      build: buildViewModel,
      seed: () =>
          const ProfileState(profileState: BaseState(data: _profile)),
      act: (cubit) => cubit.doEvent(ProfileInitialized()),
      expect: () => <ProfileState>[],
      verify: (_) {
        verifyNever(getProfileUseCase());
      },
    );
  });

  group('NotificationToggleChanged', () {
    blocTest<ProfileViewModel, ProfileState>(
      'updates isNotificationsEnabled without touching profileState',
      build: buildViewModel,
      act: (cubit) => cubit.doEvent(NotificationToggleChanged(false)),
      expect: () => [
        isA<ProfileState>().having(
          (s) => s.isNotificationsEnabled,
          'isNotificationsEnabled',
          false,
        ),
      ],
      verify: (_) {
        verifyNever(getProfileUseCase());
      },
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
);
