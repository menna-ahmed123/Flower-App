import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/theme/app_theme.dart';
import 'package:flower_app/core/auth/auth_session_controller.dart';
import 'package:flower_app/features/auth/core/domain/repos/auth_repository.dart';
import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/constants/app_urls.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/core/widgets/app_web_view_screen.dart';
import 'package:flower_app/features/auth/core/presentation/view_model/auth_cubit.dart';
import 'package:flower_app/features/profile/data/models/update_profile_request.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flower_app/features/profile/domain/repo/profile_repo.dart';
import 'package:flower_app/features/profile/domain/use_case/get_profile_use_case.dart';
import 'package:flower_app/features/profile/presentation/view/screen/profile_screen.dart';
import 'package:flower_app/features/profile/presentation/view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  late FakeAuthRepository authRepository;
  late AuthCubit authCubit;
  late ProfileViewModel profileViewModel;
  late GoRouter router;

  setUpAll(() async {
    await EasyLocalization.ensureInitialized();
  });

  setUp(() {
    authRepository = FakeAuthRepository();
    authCubit = AuthCubit(authRepository);
    final profileRepo = FakeProfileRepo();
    profileViewModel = ProfileViewModel(GetProfileUseCase(profileRepo));
    router = _testRouter();
  });

  tearDown(() async {
    await authCubit.close();
    await profileViewModel.close();
    router.dispose();
  });

  testWidgets('renders profile info, options and app version', (
    tester,
  ) async {
    await _pumpProfileScreen(tester, router, authCubit, profileViewModel);

    expect(find.text(FakeProfileRepo.profile.fullName), findsOneWidget);
    expect(find.text(FakeProfileRepo.profile.email!), findsOneWidget);
    expect(find.text(AppString.myOrders), findsOneWidget);
    expect(find.text(AppString.savedAddresses), findsOneWidget);
    expect(find.text(AppString.notification), findsOneWidget);
    expect(find.text(AppString.language), findsOneWidget);
    expect(find.text(AppString.aboutUs), findsOneWidget);
    expect(find.text(AppString.termsAndConditionsRow), findsOneWidget);
    expect(find.text(AppString.logout), findsOneWidget);
    expect(find.text(AppString.appVersion), findsOneWidget);
  });

  testWidgets('renders the pen icon next to the profile name', (
    tester,
  ) async {
    await _pumpProfileScreen(tester, router, authCubit, profileViewModel);

    expect(find.byKey(const Key('profileEditButton')), findsOneWidget);
  });

  testWidgets('tapping the pen icon navigates to edit profile', (
    tester,
  ) async {
    await _pumpProfileScreen(tester, router, authCubit, profileViewModel);

    await tester.tap(find.byKey(const Key('profileEditButton')));
    await tester.pumpAndSettle();

    expect(_path(router), '/edit-profile');
  });

  testWidgets('back navigation from edit profile returns to profile', (
    tester,
  ) async {
    await _pumpProfileScreen(tester, router, authCubit, profileViewModel);

    await tester.tap(find.byKey(const Key('profileEditButton')));
    await tester.pumpAndSettle();

    router.pop();
    await tester.pumpAndSettle();

    expect(_path(router), '/profile');
  });

  testWidgets('navigates to saved addresses when the row is tapped', (
    tester,
  ) async {
    await _pumpProfileScreen(tester, router, authCubit, profileViewModel);

    await tester.tap(find.text(AppString.savedAddresses));
    await tester.pumpAndSettle();

    expect(_path(router), '/save_address');
  });

  testWidgets('tapping About Us opens the About Us web page', (tester) async {
    await _pumpProfileScreen(tester, router, authCubit, profileViewModel);

    await tester.tap(find.text(AppString.aboutUs));
    await tester.pumpAndSettle();

    expect(_path(router), '/web-view');
    expect(
      find.text('${AppString.aboutUs}|${AppUrls.aboutUs}'),
      findsOneWidget,
    );
  });

  testWidgets(
    'tapping Terms & Conditions opens the Terms & Conditions web page',
    (tester) async {
      await _pumpProfileScreen(tester, router, authCubit, profileViewModel);

      await tester.tap(find.text(AppString.termsAndConditionsRow));
      await tester.pumpAndSettle();

      expect(_path(router), '/web-view');
      expect(
        find.text(
          '${AppString.termsAndConditionsRow}|${AppUrls.termsAndConditions}',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'toggling the switch dispatches NotificationToggleChanged and updates '
    'ProfileState, which the switch then reflects',
    (tester) async {
      await _pumpProfileScreen(tester, router, authCubit, profileViewModel);

      expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);
      expect(profileViewModel.state.isNotificationsEnabled, isTrue);

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(profileViewModel.state.isNotificationsEnabled, isFalse);
      expect(tester.widget<Switch>(find.byType(Switch)).value, isFalse);
    },
  );

  testWidgets('shows a loading indicator while the profile request is in '
      'flight', (tester) async {
    final controllableRepo = ControllableProfileRepo();
    final viewModel = ProfileViewModel(GetProfileUseCase(controllableRepo));
    addTearDown(viewModel.close);

    await _pumpProfileScreenWhileLoading(tester, router, authCubit, viewModel);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    controllableRepo.complete(const SuccessResponse(FakeProfileRepo.profile));
    await tester.pumpAndSettle();

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text(FakeProfileRepo.profile.fullName), findsOneWidget);
  });

  testWidgets(
    'shows the error message with a retry button, and retrying reloads the '
    'profile',
    (tester) async {
      final controllableRepo = ControllableProfileRepo();
      final viewModel = ProfileViewModel(GetProfileUseCase(controllableRepo));
      addTearDown(viewModel.close);

      await _pumpProfileScreenWhileLoading(tester, router, authCubit, viewModel);

      controllableRepo.complete(
        ErrorResponse<ProfileEntity>(
          appError: BadResponseError('Could not load profile'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Could not load profile'), findsOneWidget);
      expect(find.text(AppString.retry), findsOneWidget);

      controllableRepo.reset();
      await tester.tap(find.text(AppString.retry));
      await tester.pump();
      controllableRepo.complete(
        const SuccessResponse(FakeProfileRepo.profile),
      );
      await tester.pumpAndSettle();

      expect(find.text('Could not load profile'), findsNothing);
      expect(find.text(FakeProfileRepo.profile.fullName), findsOneWidget);
    },
  );

  testWidgets('cancelling the logout dialog does not log the user out', (
    tester,
  ) async {
    await _pumpProfileScreen(tester, router, authCubit, profileViewModel);

    await tester.tap(find.text(AppString.logout).first);
    await tester.pumpAndSettle();

    expect(find.text(AppString.logoutDialogTitle), findsOneWidget);
    expect(find.text(AppString.confirmLogoutMessage), findsOneWidget);

    await tester.tap(find.text(AppString.cancel));
    await tester.pumpAndSettle();

    expect(find.text(AppString.logoutDialogTitle), findsNothing);
    expect(_path(router), '/profile');
  });

  testWidgets('confirming logout signs the user out and goes to login', (
    tester,
  ) async {
    await _pumpProfileScreen(tester, router, authCubit, profileViewModel);

    await tester.tap(find.text(AppString.logout).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text(AppString.logout).last);
    await tester.pumpAndSettle();

    expect(_path(router), '/login');
  });
}

String _path(GoRouter router) => router.routeInformationProvider.value.uri.path;

Future<void> _pumpProfileScreen(
  WidgetTester tester,
  GoRouter router,
  AuthCubit authCubit,
  ProfileViewModel profileViewModel,
) async {
  await _pumpProfileScreenTree(tester, router, authCubit, profileViewModel);
  await tester.pumpAndSettle();
}

/// Same widget tree as [_pumpProfileScreen], but pumps a single frame
/// instead of settling. CircularProgressIndicator's indeterminate spinner
/// never stops animating on its own, so a test that needs to observe the
/// loading state (before completing a [ControllableProfileRepo] future)
/// must use this instead — pumpAndSettle would time out waiting for an
/// animation that's never meant to finish.
Future<void> _pumpProfileScreenWhileLoading(
  WidgetTester tester,
  GoRouter router,
  AuthCubit authCubit,
  ProfileViewModel profileViewModel,
) async {
  await _pumpProfileScreenTree(tester, router, authCubit, profileViewModel);
  await tester.pump();
}

Future<void> _pumpProfileScreenTree(
  WidgetTester tester,
  GoRouter router,
  AuthCubit authCubit,
  ProfileViewModel profileViewModel,
) async {
  tester.view.physicalSize = const Size(375, 812);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      useOnlyLangCode: true,
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, _) => MultiRepositoryProvider(
          providers: [
            RepositoryProvider<AuthSessionController>.value(value: authCubit),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: authCubit),
              BlocProvider.value(value: profileViewModel),
            ],
            child: Builder(
              builder: (context) => MaterialApp.router(
                theme: AppTheme(lightThemeColors).themeData,
                routerConfig: router,
                locale: context.locale,
                supportedLocales: context.supportedLocales,
                localizationsDelegates: context.localizationDelegates,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

GoRouter _testRouter() {
  return GoRouter(
    initialLocation: '/profile',
    routes: [
      GoRoute(path: '/profile', builder: (_, _) => const ProfileScreen()),
      GoRoute(path: '/login', builder: (_, _) => const Text('LOGIN')),
      GoRoute(
        path: '/save_address',
        builder: (_, _) => const Text('SAVE_ADDRESS'),
      ),
      GoRoute(
        path: '/edit-profile',
        builder: (_, _) => const Text('EDIT_PROFILE'),
      ),
      GoRoute(
        path: '/web-view',
        builder: (_, state) {
          final args = state.extra as WebViewArgs;
          return Text('${args.title}|${args.url}');
        },
      ),
    ],
  );
}

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.authenticated = true});

  bool authenticated;
  bool loggedOut = false;

  @override
  Future<bool> isAuthenticated() async => authenticated;

  @override
  Future<void> logout() async {
    loggedOut = true;
    authenticated = false;
  }
}

class FakeProfileRepo implements ProfileRepo {
  static const profile = ProfileEntity(
    userId: 'u1',
    fullName: 'Nour Mohamed',
    firstName: 'Nour',
    lastName: 'Mohamed',
    email: 'Nour_Mohamed@gmail.com',
    phoneNumber: '01010000001',
    gender: null,
    profilePictureUrl: null,
    roles: ['Customer'],
  );

  @override
  Future<BaseResponse<ProfileEntity>> getMyProfile() async {
    return const SuccessResponse(profile);
  }

  @override
  Future<BaseResponse<ProfileEntity>> updateMyProfile(UpdateProfileRequest updateProfileRequest) {
    // TODO: implement updateMyProfile
    throw UnimplementedError();
  }
}

/// A ProfileRepo whose getMyProfile() call only resolves once [complete] is
/// called, so tests can assert on the in-between loading state. [reset]
/// swaps in a fresh, not-yet-resolved call for a retry.
class ControllableProfileRepo implements ProfileRepo {
  Completer<BaseResponse<ProfileEntity>> _completer = Completer();

  void complete(BaseResponse<ProfileEntity> response) {
    _completer.complete(response);
  }

  void reset() {
    _completer = Completer();
  }

  @override
  Future<BaseResponse<ProfileEntity>> getMyProfile() => _completer.future;

  @override
  Future<BaseResponse<ProfileEntity>> updateMyProfile(UpdateProfileRequest updateProfileRequest) {
    // TODO: implement updateMyProfile
    throw UnimplementedError();
  }
}
