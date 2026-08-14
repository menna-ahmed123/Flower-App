import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flower_app/features/auth/register/api/dio_register_api.dart';
import 'package:flower_app/features/auth/register/api/register_api.dart';
import 'package:flower_app/features/auth/register/data/data_sources/register_remote_data_source.dart';
import 'package:flower_app/app/router/app_routes.dart';
import 'package:flower_app/core/navigation/route_success_snackbar.dart';
import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/theme/app_theme.dart';
import 'package:flower_app/features/auth/register/domain/models/register_request.dart';
import 'package:flower_app/features/auth/register/domain/models/register_result.dart';
import 'package:flower_app/features/auth/register/domain/repositories/register_repository.dart';
import 'package:flower_app/features/auth/register/domain/use_cases/register_use_case.dart';
import 'package:flower_app/features/auth/register/domain/use_cases/register_use_case_impl.dart';
import 'package:flower_app/features/auth/register/presentation/intent/register_intent.dart';
import 'package:flower_app/features/auth/register/presentation/pages/register_page.dart';
import 'package:flower_app/features/auth/register/domain/validators/register_form_validator.dart';
import 'package:flower_app/features/auth/register/presentation/view_model/register_bloc.dart';
import 'package:flower_app/features/auth/register/presentation/state/register_state.dart';
import 'package:flower_app/features/auth/register/presentation/widgets/register_form_footer.dart';
import 'package:flower_app/features/auth/register/presentation/widgets/register_gender_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

RegisterRequest validRegisterRequest({
  Gender gender = Gender.female,
  String email = 'sara@example.com',
}) {
  return RegisterRequest(
    firstName: 'Sara',
    lastName: 'Ali',
    email: email,
    password: 'Pass1234',
    phoneNumber: '01012345678',
    gender: gender,
  );
}

const validRegisterFormInput = RegisterFormInput(
  firstName: 'Sara',
  lastName: 'Ali',
  email: 'sara@example.com',
  password: 'Pass1234',
  confirmPassword: 'Pass1234',
  phoneNumber: '01012345678',
);

const emptyRegisterFormInput = RegisterFormInput(
  firstName: '',
  lastName: '',
  email: '',
  password: '',
  confirmPassword: '',
  phoneNumber: '',
);

class RegisterBlocTestEnv {
  RegisterBlocTestEnv._(this.useCase, this.bloc);

  final FakeRegisterUseCase useCase;
  final RegisterBloc bloc;

  factory RegisterBlocTestEnv({FakeRegisterUseCase? useCase}) {
    final fake = useCase ?? FakeRegisterUseCase();
    return RegisterBlocTestEnv._(
      fake,
      RegisterBloc(fake, const RegisterFormValidator()),
    );
  }

  Future<void> dispose() => bloc.close();
}

Future<void> dispatchIntent(
  RegisterBloc bloc,
  RegisterIntent intent, {
  bool Function(RegisterState state)? until,
}) async {
  final predicate = until ?? (_) => true;
  if (predicate(bloc.state)) {
    bloc.add(intent);
    await Future<void>.microtask(() {});
    if (predicate(bloc.state)) return;
  }
  final done = bloc.stream.firstWhere(predicate);
  bloc.add(intent);
  await done;
}

Future<void> submitRegisterForm(RegisterBloc bloc) async {
  for (final intent in _seedRegisterIntents()) {
    await dispatchIntent(bloc, intent, until: _intentApplied(intent, bloc.state));
  }
  await dispatchIntent(
    bloc,
    const SubmitRegisterIntent(),
    until: (state) =>
        state.effect != null ||
        (!state.isLoading && state.fieldErrors.hasErrors),
  );
}

Iterable<RegisterIntent> _seedRegisterIntents() {
  return [
    const RegisterFieldChangedIntent(RegisterField.firstName, 'Sara'),
    const RegisterFieldChangedIntent(RegisterField.lastName, 'Ali'),
    const RegisterFieldChangedIntent(RegisterField.email, 'sara@example.com'),
    const RegisterFieldChangedIntent(RegisterField.password, 'Pass1234'),
    const RegisterFieldChangedIntent(
      RegisterField.confirmPassword,
      'Pass1234',
    ),
    const RegisterFieldChangedIntent(
      RegisterField.phoneNumber,
      '01012345678',
    ),
  ];
}

bool Function(RegisterState) _intentApplied(
  RegisterIntent intent,
  RegisterState before,
) {
  return switch (intent) {
    RegisterFieldChangedIntent(:final field, :final value) => (state) =>
        switch (field) {
          RegisterField.firstName => state.firstName == value,
          RegisterField.lastName => state.lastName == value,
          RegisterField.email => state.email == value,
          RegisterField.password => state.password == value,
          RegisterField.confirmPassword => state.confirmPassword == value,
          RegisterField.phoneNumber => state.phoneNumber == value,
        },
    RegisterGenderChangedIntent(:final gender) =>
      (state) => state.gender == gender,
    _ => (_) => true,
  };
}

void seedRegisterForm(RegisterBloc bloc) {
  for (final intent in _seedRegisterIntents()) {
    bloc.add(intent);
  }
}

Future<List<RegisterState>> captureSubmitStates(RegisterBloc bloc) async {
  final states = <RegisterState>[];
  final sub = bloc.stream.listen(states.add);
  await submitRegisterForm(bloc);
  await sub.cancel();
  return states;
}

class FakeRegisterUseCase implements RegisterUseCase {
  RegisterRequest? lastRequest;
  int callCount = 0;
  bool shouldFail = false;
  Duration delay = Duration.zero;

  @override
  Future<BaseResponse<RegisterResult>> call(RegisterRequest request) async {
    callCount++;
    lastRequest = request;
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    if (shouldFail) {
      return ErrorResponse(appError: BadResponseError(AppString.signupFailed));
    }
    return fakeRegisterSuccess;
  }
}

const SuccessResponse<RegisterResult> fakeRegisterSuccess = SuccessResponse(
  RegisterResult(
    userId: 'user-1',
    email: 'sara@example.com',
    role: 'Customer',
    status: 'Active',
    message: 'Account registered successfully.',
  ),
);

class FakeRegisterRepository implements RegisterRepository {
  FakeRegisterRepository({this.shouldFail = false});

  int callCount = 0;
  RegisterRequest? lastRequest;
  bool shouldFail;

  @override
  Future<BaseResponse<RegisterResult>> register(RegisterRequest request) async {
    callCount++;
    lastRequest = request;
    if (shouldFail) {
      return ErrorResponse(appError: BadResponseError(AppString.signupFailed));
    }
    return fakeRegisterSuccess;
  }
}

RegisterBloc testRegisterBloc(FakeRegisterRepository repository) {
  return RegisterBloc(
    RegisterUseCaseImpl(repository),
    const RegisterFormValidator(),
  );
}

RegisterBloc Function() testRegisterBlocFactory(
  FakeRegisterRepository repository,
) {
  return () => testRegisterBloc(repository);
}

class FakeRegisterApi implements RegisterApi {
  RegisterRequest? lastRequest;
  int callCount = 0;
  Object? errorToThrow;
  RegisterResult result = const RegisterResult(
    userId: 'user-1',
    email: 'sara@example.com',
    role: 'Customer',
    status: 'Active',
    message: 'ok',
  );

  @override
  Future<RegisterResult> register(RegisterRequest request) async {
    callCount++;
    lastRequest = request;
    if (errorToThrow != null) throw errorToThrow!;
    return result;
  }
}

class FakeRegisterRemoteDataSource implements RegisterRemoteDataSource {
  RegisterRequest? lastRequest;
  int callCount = 0;
  Object? errorToThrow;
  RegisterResult result = const RegisterResult(
    userId: 'user-1',
    email: 'sara@example.com',
    role: 'Customer',
    status: 'Active',
  );

  @override
  Future<RegisterResult> register(RegisterRequest request) async {
    callCount++;
    lastRequest = request;
    if (errorToThrow != null) throw errorToThrow!;
    return result;
  }
}

class RecordingAdapter implements HttpClientAdapter {
  RecordingAdapter(this.statusCode, this.payload);

  final int statusCode;
  final Map<String, dynamic> payload;
  RequestOptions? lastOptions;
  Object? lastData;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastOptions = options;
    lastData = options.data;
    return ResponseBody.fromString(
      jsonEncode(payload),
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }
}

DioRegisterApi buildDioRegisterApi(RecordingAdapter adapter) {
  final dio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));
  dio.httpClientAdapter = adapter;
  return DioRegisterApi(dio);
}

RecordingAdapter successAdapter() {
  return RecordingAdapter(201, {
    'isSuccess': true,
    'statusCode': 201,
    'message': 'Account registered successfully.',
    'data': {
      'userId': 'user-1',
      'email': 'sara@example.com',
      'role': 'Customer',
      'status': 'Active',
    },
  });
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

Future<void> pumpThemedWidget(WidgetTester tester, Widget child) async {
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
  required RegisterBloc Function() createBloc,
}) async {
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
        routerConfig: registerTestRouter(createBloc: createBloc),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

GoRouter registerTestRouter({required RegisterBloc Function() createBloc}) {
  return GoRouter(
    initialLocation: AppRoutesName.register,
    routes: [
      GoRoute(
        path: AppRoutesName.register,
        builder: (context, state) => RegisterPage(createBloc: createBloc),
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

Future<void> enterField(
  WidgetTester tester,
  String hint,
  String value,
) async {
  await tester.enterText(find.widgetWithText(TextFormField, hint), value);
  await tester.pump();
}

Future<void> tapSignUp(WidgetTester tester) async {
  await tester.tap(find.widgetWithText(ElevatedButton, AppString.signUp));
  await tester.pump();
}

Future<void> pumpLoadingSubmitButton(WidgetTester tester) async {
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
        home: Scaffold(
          body: RegisterSubmitButton(isLoading: true, onPressed: () {}),
        ),
      ),
    ),
  );
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
        Text('selected:${value.displayName}'),
      ],
    );
  }
}
