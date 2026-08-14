import 'package:dio/dio.dart';
import 'package:flower_app/core/network/safe_call.dart';
import 'package:flower_app/features/auth/register/api/dio_register_api.dart';
import 'package:flower_app/features/auth/register/data/data_sources/register_remote_data_source.dart';
import 'package:flower_app/features/auth/register/data/data_sources/register_remote_data_source_impl.dart';
import 'package:flower_app/features/auth/register/data/repositories/register_repository_impl.dart';
import 'package:flower_app/features/auth/register/domain/repositories/register_repository.dart';
import 'package:flower_app/features/auth/register/domain/use_cases/register_use_case.dart';
import 'package:flower_app/features/auth/register/domain/use_cases/register_use_case_impl.dart';
import 'package:flower_app/features/auth/register/domain/validators/register_form_validator.dart';
import 'package:flower_app/features/auth/register/presentation/view_model/register_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'di.config.dart';

final getIt = GetIt.instance;
@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
Future <void> configureDependencies() async {
  getIt.init();
  _registerSignupDependencies();
}

void _registerSignupDependencies() {
  if (getIt.isRegistered<RegisterBloc>()) return;
  _registerSignupValidator();
  _registerSignupApi();
  _registerSignupData();
  _registerSignupBloc();
}

void _registerSignupValidator() {
  getIt.registerFactory<RegisterFormValidator>(
    () => const RegisterFormValidator(),
  );
}

void _registerSignupApi() {
  getIt.registerLazySingleton<DioRegisterApi>(
    () => DioRegisterApi(getIt<Dio>()),
  );
}

void _registerSignupData() {
  getIt.registerFactory<RegisterRemoteDataSource>(
    () => RegisterRemoteDataSourceImpl(getIt<DioRegisterApi>()),
  );
  getIt.registerFactory<RegisterRepository>(
    () => RegisterRepositoryImpl(
      getIt<RegisterRemoteDataSource>(),
      getIt<SafeCall>(),
    ),
  );
  getIt.registerFactory<RegisterUseCase>(
    () => RegisterUseCaseImpl(getIt<RegisterRepository>()),
  );
}

void _registerSignupBloc() {
  getIt.registerFactory<RegisterBloc>(
    () => RegisterBloc(
      getIt<RegisterUseCase>(),
      getIt<RegisterFormValidator>(),
    ),
  );
}
