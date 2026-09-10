import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_theme.dart';
import 'package:flower_app/features/auth/core/presentation/view_model/auth_cubit.dart';
import 'package:flower_app/features/profile/domain/entities/update_profile_params.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flower_app/features/profile/domain/repo/profile_repo.dart';
import 'package:flower_app/features/profile/domain/use_case/get_profile_use_case.dart';
import 'package:flower_app/features/profile/domain/use_case/update_profile_use_case.dart';
import 'package:flower_app/features/profile/presentation/view/screen/edit_profile_screen.dart';
import 'package:flower_app/features/profile/presentation/view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'profile_screen_test.dart' show FakeAuthRepository, FakeProfileRepo;

void main() {
  late ProfileViewModel profileViewModel;

  setUp(() {
    final repo = FakeProfileRepo();
    profileViewModel = ProfileViewModel(
      GetProfileUseCase(repo),
      UpdateProfileUseCase(repo),
    );
  });

  tearDown(() async => profileViewModel.close());

  testWidgets('renders the current profile fields and shows a validation error', (
    tester,
  ) async {
    await _pumpEditProfileScreen(tester, profileViewModel, FakeProfileRepo.profile);

    expect(find.text(FakeProfileRepo.profile.fullName), findsOneWidget);
    expect(find.text(FakeProfileRepo.profile.email!), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextFormField, AppString.email).first, '');
    await tester.tap(find.text(AppString.update));
    await tester.pumpAndSettle();

    expect(find.text(AppString.pleaseEnterYourEmail), findsOneWidget);
  });

  testWidgets(
    'submitting an update with no email change shows a success message and pops',
    (tester) async {
      final repo = _RecordingUpdateProfileRepo(emailChanged: false);
      profileViewModel = ProfileViewModel(
        GetProfileUseCase(repo),
        UpdateProfileUseCase(repo),
      );
      final authRepository = FakeAuthRepository();
      final authCubit = AuthCubit(authRepository);
      final router = _testRouter();
      addTearDown(() async {
        await authCubit.close();
        router.dispose();
      });

      await _pumpEditProfileScreenWithRouter(
        tester,
        router,
        authCubit,
        profileViewModel,
        FakeProfileRepo.profile,
      );

      await tester.tap(find.text(AppString.update));
      await tester.pumpAndSettle();

      expect(find.text(AppString.profileUpdatedSuccess), findsOneWidget);
      expect(_path(router), '/profile-host');
      expect(authRepository.loggedOut, isFalse);
      // The customer-facing Edit Profile form never sets the driver-only fields.
      expect(repo.lastRequest?.vehicleType, isNull);
      expect(repo.lastRequest?.vehiclePlateNumber, isNull);
      expect(repo.lastRequest?.country, isNull);
    },
  );

  testWidgets(
    'submitting an update that changes the email logs the user out and redirects to login',
    (tester) async {
      final repo = _RecordingUpdateProfileRepo(emailChanged: true);
      profileViewModel = ProfileViewModel(
        GetProfileUseCase(repo),
        UpdateProfileUseCase(repo),
      );
      final authRepository = FakeAuthRepository();
      final authCubit = AuthCubit(authRepository);
      final router = _testRouter();
      addTearDown(() async {
        await authCubit.close();
        router.dispose();
      });

      await _pumpEditProfileScreenWithRouter(
        tester,
        router,
        authCubit,
        profileViewModel,
        FakeProfileRepo.profile,
      );

      await tester.tap(find.text(AppString.update));
      await tester.pumpAndSettle();

      expect(find.text(AppString.emailChangedSignInAgain), findsOneWidget);
      expect(authRepository.loggedOut, isTrue);
      expect(_path(router), '/login');
    },
  );
}

String _path(GoRouter router) => router.routeInformationProvider.value.uri.path;

Future<void> _pumpEditProfileScreen(
  WidgetTester tester,
  ProfileViewModel profileViewModel,
  ProfileEntity profile,
) async {
  tester.view.physicalSize = const Size(375, 812);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, _) => BlocProvider.value(
        value: profileViewModel,
        child: MaterialApp(
          theme: AppTheme(lightThemeColors).themeData,
          home: EditProfileScreen(profile: profile),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _pumpEditProfileScreenWithRouter(
  WidgetTester tester,
  GoRouter router,
  AuthCubit authCubit,
  ProfileViewModel profileViewModel,
  ProfileEntity profile,
) async {
  tester.view.physicalSize = const Size(375, 812);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, _) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: authCubit),
          BlocProvider.value(value: profileViewModel),
        ],
        child: MaterialApp.router(
          theme: AppTheme(lightThemeColors).themeData,
          routerConfig: router,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  router.push('/edit-profile-under-test', extra: profile);
  await tester.pumpAndSettle();
}

GoRouter _testRouter() {
  return GoRouter(
    initialLocation: '/profile-host',
    routes: [
      GoRoute(path: '/profile-host', builder: (_, _) => const Text('HOME')),
      GoRoute(path: '/login', builder: (_, _) => const Text('LOGIN')),
      GoRoute(
        path: '/edit-profile-under-test',
        builder: (context, state) =>
            EditProfileScreen(profile: state.extra as ProfileEntity),
      ),
    ],
  );
}

/// Records the request passed to [updateMyProfile] and returns a profile
/// whose `emailChanged` flag is controlled per-test.
class _RecordingUpdateProfileRepo implements ProfileRepo {
  _RecordingUpdateProfileRepo({required this.emailChanged});

  final bool emailChanged;
  UpdateProfileParams? lastRequest;

  @override
  Future<BaseResponse<ProfileEntity>> getMyProfile() async {
    return const SuccessResponse(FakeProfileRepo.profile);
  }

  @override
  Future<BaseResponse<ProfileEntity>> updateMyProfile(
    UpdateProfileParams params,
  ) async {
    lastRequest = params;
    return SuccessResponse(
      ProfileEntity(
        userId: FakeProfileRepo.profile.userId,
        fullName: params.fullName,
        firstName: FakeProfileRepo.profile.firstName,
        lastName: FakeProfileRepo.profile.lastName,
        email: params.email,
        phoneNumber: params.phoneNumber,
        gender: FakeProfileRepo.profile.gender,
        profilePictureUrl: FakeProfileRepo.profile.profilePictureUrl,
        roles: FakeProfileRepo.profile.roles,
        emailChanged: emailChanged,
      ),
    );
  }
}
