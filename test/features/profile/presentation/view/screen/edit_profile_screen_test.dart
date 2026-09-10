import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_theme.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flower_app/features/profile/domain/use_case/get_profile_use_case.dart';
import 'package:flower_app/features/profile/domain/use_case/update_profile_use_case.dart';
import 'package:flower_app/features/profile/presentation/view/screen/edit_profile_screen.dart';
import 'package:flower_app/features/profile/presentation/view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'profile_screen_test.dart' show FakeProfileRepo;

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
}

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
