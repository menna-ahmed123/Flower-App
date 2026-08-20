import 'package:flower_app/app/router/app_routes.dart';
import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/core/navigation/route_success_snack_bar.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/theme/app_theme.dart';
import 'package:flower_app/features/auth/register/data/models/register_request.dart';
import 'package:flower_app/features/auth/register/data/models/register_response.dart';
import 'package:flower_app/features/auth/register/domain/entity/gender.dart';
import 'package:flower_app/features/auth/register/domain/entity/register_entity.dart';
import 'package:flower_app/features/auth/register/domain/repo/register_repo.dart';
import 'package:flower_app/features/auth/register/domain/use_case/register_usecase.dart';
import 'package:flower_app/features/auth/register/presentation/view/pages/register_page.dart';
import 'package:flower_app/features/auth/register/presentation/view_model/register_event.dart';
import 'package:flower_app/features/auth/register/presentation/view_model/register_view_model.dart';
import 'package:flower_app/features/auth/register/presentation/widgets/register_gender_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

const fakeRegisterEntity = RegisterEntity(
  userId: 'user-1',
  email: 'sara@example.com',
  role: 'Customer',
  status: 'Active',
  message: 'Account registered successfully.',
);

const SuccessResponse<RegisterEntity> fakeRegisterSuccess = SuccessResponse(
  fakeRegisterEntity,
);

RegisterRequest validRegisterRequest({
  String fullName = 'Sara Ali',
  String email = 'sara@example.com',
  String phoneNumber = '01012345678',
  String gender = 'Female',
  String password = 'Pass1234',
  String confirmPassword = 'Pass1234',
}) {
  return RegisterRequest(
    fullName: fullName,
    email: email,
    phoneNumber: phoneNumber,
    gender: gender,
    password: password,
    confirmPassword: confirmPassword,
  );
}

RegisterSubmitted validRegisterSubmitted({
  String firstName = 'Sara',
  String lastName = 'Ali',
  String email = 'sara@example.com',
  String password = 'Pass1234',
  String confirmPassword = 'Pass1234',
  String phoneNumber = '01012345678',
  String gender = 'Female',
}) {
  return RegisterSubmitted(
    firstName: firstName,
    lastName: lastName,
    email: email,
    password: password,
    confirmPassword: confirmPassword,
    phoneNumber: phoneNumber,
    gender: gender,
  );
}

RegisterResponse successfulRegisterResponse({
  String message = 'Account registered successfully.',
}) {
  return RegisterResponse(
    isSuccess: true,
    statusCode: 201,
    message: message,
    data: RegisterData(
      userId: 'user-1',
      email: 'sara@example.com',
      role: 'Customer',
      status: 'Active',
    ),
  );
}

Map<String, dynamic> expectedFemaleBody() {
  return {
    'fullName': 'Sara Ali',
    'email': 'sara@example.com',
    'phoneNumber': '01012345678',
    'gender': 'Female',
    'password': 'Pass1234',
    'confirmPassword': 'Pass1234',
  };
}

class _UnusedRegisterRepo implements RegisterRepo {
  @override
  Future<BaseResponse<RegisterEntity>> register(RegisterRequest request) {
    throw UnimplementedError();
  }
}

class FakeRegisterUseCase extends RegisterUseCase {
  FakeRegisterUseCase() : super(_UnusedRegisterRepo());

  RegisterRequest? lastRequest;
  int callCount = 0;
  bool shouldFail = false;
  Duration delay = Duration.zero;
  RegisterEntity result = fakeRegisterEntity;

  @override
  Future<BaseResponse<RegisterEntity>> call(RegisterRequest request) async {
    callCount++;
    lastRequest = request;
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    if (shouldFail) {
      return ErrorResponse(appError: BadResponseError(AppString.signupFailed));
    }
    return SuccessResponse(result);
  }
}

RegisterViewModel testRegisterViewModel(FakeRegisterUseCase useCase) {
  return RegisterViewModel(useCase);
}

void ignoreOverflowErrors() {
  final originalOnError = FlutterError.onError;
  FlutterError.onError = (details) {
    if (details.exceptionAsString().contains('A RenderFlex overflowed')) {
      return;
    }
    originalOnError?.call(details);
  };
  addTearDown(() {
    FlutterError.onError = originalOnError;
  });
}

Future<void> pumpThemedWidget(WidgetTester tester, Widget child) async {
  ignoreOverflowErrors();
  tester.view.physicalSize = const Size(375, 900);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) => MaterialApp(
        theme: AppTheme(lightThemeColors).themeData,
        home: Scaffold(body: child),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> pumpRegisterPage(
  WidgetTester tester, {
  required FakeRegisterUseCase useCase,
}) async {
  ignoreOverflowErrors();
  tester.view.physicalSize = const Size(375, 900);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) => MaterialApp.router(
        theme: AppTheme(lightThemeColors).themeData,
        routerConfig: registerTestRouter(useCase: useCase),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

GoRouter registerTestRouter({required FakeRegisterUseCase useCase}) {
  return GoRouter(
    initialLocation: AppRoutesName.register,
    routes: [
      GoRoute(
        path: AppRoutesName.register,
        builder: (context, state) => BlocProvider(
          create: (_) => RegisterViewModel(useCase),
          child: const RegisterPage(),
        ),
      ),
      GoRoute(
        path: AppRoutesName.login,
        builder: (context, state) => RouteSuccessSnackBar(
          message: state.uri.queryParameters['success'],
          child: const Scaffold(body: Text('Login Screen')),
        ),
      ),
    ],
  );
}

Future<void> fillValidRegisterForm(WidgetTester tester) async {
  await enterField(tester, AppString.enterFirstName, 'Sara');
  await enterField(tester, AppString.enterLastName, 'Ali');
  await enterField(tester, AppString.enterYourEmail, 'sara@example.com');
  await enterField(tester, AppString.enterPassword, 'Pass1234');
  await enterField(tester, AppString.confirmPassword, 'Pass1234');
  await enterField(tester, AppString.enterPhoneNumber, '01012345678');
}

Future<void> enterField(WidgetTester tester, String hint, String value) async {
  await tester.enterText(find.widgetWithText(TextFormField, hint), value);
  await tester.pump();
}

Future<void> tapSignUp(WidgetTester tester) async {
  await tester.tap(find.widgetWithText(ElevatedButton, AppString.signUp));
  await tester.pump();
}

class RegisterGenderSelectorHarness extends StatefulWidget {
  const RegisterGenderSelectorHarness({super.key, required this.initial});

  final Gender initial;

  @override
  State<RegisterGenderSelectorHarness> createState() =>
      RegisterGenderSelectorHarnessState();
}

class RegisterGenderSelectorHarnessState
    extends State<RegisterGenderSelectorHarness> {
  late Gender value;

  @override
  void initState() {
    super.initState();
    value = widget.initial;
  }

  void onGenderChanged(Gender gender) => setState(() => value = gender);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RegisterGenderSelector(
          value: value,
          enabled: true,
          onChanged: onGenderChanged,
        ),
        Text('selected:${value.apiValue}'),
      ],
    );
  }
}
