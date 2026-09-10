import 'package:easy_localization/easy_localization.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/theme/app_theme.dart';
import 'package:flower_app/features/auth/core/domain/repos/auth_repository.dart';
import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/auth/core/presentation/view_model/auth_cubit.dart';
import 'package:flower_app/features/profile/domain/entities/update_profile_params.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flower_app/features/profile/domain/repo/profile_repo.dart';
import 'package:flower_app/features/profile/domain/use_case/get_profile_use_case.dart';
import 'package:flower_app/features/profile/domain/use_case/update_profile_use_case.dart';
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
    profileViewModel = ProfileViewModel(
      GetProfileUseCase(profileRepo),
      UpdateProfileUseCase(profileRepo),
    );
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

  testWidgets('navigates to saved addresses when the row is tapped', (
    tester,
  ) async {
    await _pumpProfileScreen(tester, router, authCubit, profileViewModel);

    await tester.tap(find.text(AppString.savedAddresses));
    await tester.pumpAndSettle();

    expect(_path(router), '/save_address');
  });

  testWidgets('toggles the notification switch locally', (tester) async {
    await _pumpProfileScreen(tester, router, authCubit, profileViewModel);

    expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    expect(tester.widget<Switch>(find.byType(Switch)).value, isFalse);
  });

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
        builder: (context, _) => MultiBlocProvider(
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
  );
  await tester.pumpAndSettle();
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
    emailChanged: false,
  );

  @override
  Future<BaseResponse<ProfileEntity>> getMyProfile() async {
    return const SuccessResponse(profile);
  }

  @override
  Future<BaseResponse<ProfileEntity>> updateMyProfile(
    UpdateProfileParams params,
  ) async {
    return const SuccessResponse(profile);
  }
}
