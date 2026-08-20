// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/auth/forget_password/api/client/forget_password_api_client.dart'
    as _i597;
import '../../features/auth/forget_password/api/data_source/forget_password_remote_data_source_impl.dart'
    as _i159;
import '../../features/auth/forget_password/data/data_sources/remote/forget_password_remote_data_source.dart'
    as _i24;
import '../../features/auth/forget_password/data/repos/forget_password_repo_impl.dart'
    as _i769;
import '../../features/auth/forget_password/domain/repos/forget_password_repo.dart'
    as _i488;
import '../../features/auth/forget_password/domain/use_cases/forget_password_use_case.dart'
    as _i913;
import '../../features/auth/forget_password/domain/use_cases/reset_password_use_case.dart'
    as _i22;
import '../../features/auth/forget_password/domain/use_cases/verify_otp_use_case.dart'
    as _i722;
import '../../features/auth/forget_password/presentation/view_model/forget_password_cubit.dart'
    as _i795;
import '../../features/auth/login/data/api/auth_api_client.dart' as _i144;
import '../../features/auth/login/data/data_source/remote/auth_remote_data_source.dart'
    as _i441;
import '../../features/auth/login/data/data_source/remote/auth_remote_data_source_impl.dart'
    as _i4;
import '../../features/auth/login/data/repo/auth_repo_impl.dart' as _i641;
import '../../features/auth/login/domain/repo/auth_repo.dart' as _i483;
import '../../features/auth/login/domain/use_case/login_usecase.dart' as _i635;
import '../../features/auth/login/presentation/view_model/login_view_model.dart'
    as _i188;
import '../../features/auth/register/api/dio_register_api.dart' as _i347;
import '../../features/auth/register/data/data_sources/register_remote_data_source.dart'
    as _i682;
import '../../features/auth/register/data/data_sources/register_remote_data_source_impl.dart'
    as _i550;
import '../../features/auth/register/data/repositories/register_repository_impl.dart'
    as _i200;
import '../../features/auth/register/domain/repositories/register_repository.dart'
    as _i57;
import '../../features/auth/register/domain/use_cases/register_use_case.dart'
    as _i118;
import '../../features/auth/register/domain/use_cases/register_use_case_impl.dart'
    as _i753;
import '../../features/auth/register/domain/validators/register_form_validator.dart'
    as _i495;
import '../../features/auth/register/presentation/view_model/register_bloc.dart'
    as _i213;
import '../localization/locale_controller.dart' as _i1066;
import '../localization/locale_storage.dart' as _i463;
import '../modules/api_module.dart' as _i98;
import '../modules/dio_module.dart' as _i948;
import '../modules/register_module.dart' as _i505;
import '../network/auth_interceptors.dart' as _i466;
import '../network/safe_call.dart' as _i185;
import '../network/token_refresher.dart' as _i1058;
import '../network/token_storage.dart' as _i964;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    final dioModule = _$DioModule();
    final dioRegisterApiModule = _$DioRegisterApiModule();
    final apiModule = _$ApiModule();
    gh.factory<_i185.SafeCall>(() => _i185.SafeCall());
    gh.factory<_i495.RegisterFormValidator>(
      () => const _i495.RegisterFormValidator(),
    );
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => registerModule.secureStorage,
    );
    await gh.lazySingletonAsync<_i460.SharedPreferences>(
      () => registerModule.prefs(),
      preResolve: true,
    );
    gh.lazySingleton<_i1058.TokenRefresher>(
      () => _i1058.UnconfiguredTokenRefresher(),
    );
    gh.lazySingleton<_i964.TokenStorage>(
      () => _i964.SecureTokenStorage(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i463.LocaleStorage>(
      () => _i463.PreferencesLocaleStorage(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i466.AuthInterceptors>(
      () => _i466.AuthInterceptors(
        gh<_i964.TokenStorage>(),
        gh<_i1058.TokenRefresher>(),
      ),
    );
    gh.lazySingleton<_i1066.LocaleController>(
      () => _i1066.LocaleController(gh<_i463.LocaleStorage>()),
    );
    gh.singleton<_i361.Dio>(
      () => dioModule.provideDio(gh<_i466.AuthInterceptors>()),
    );
    gh.lazySingleton<_i347.DioRegisterApi>(
      () => dioRegisterApiModule.dioRegisterApi(gh<_i361.Dio>()),
    );
    gh.singleton<_i597.ForgetPasswordApiClient>(
      () => apiModule.provideForgetPasswordApiClient(gh<_i361.Dio>()),
    );
    gh.factory<_i144.AuthApiClient>(
      () => apiModule.authApiClient(gh<_i361.Dio>()),
    );
    gh.factory<_i24.ForgetPasswordRemoteDataSource>(
      () => _i159.ForgetPasswordRemoteDataSourceImpl(
        forgetPasswordApiClient: gh<_i597.ForgetPasswordApiClient>(),
        safeCall: gh<_i185.SafeCall>(),
      ),
    );
    gh.lazySingleton<_i488.ForgetPasswordRepo>(
      () => _i769.ForgetPasswordRepoImpl(
        remoteDataSource: gh<_i24.ForgetPasswordRemoteDataSource>(),
      ),
    );
    gh.factory<_i913.ForgetPasswordUseCase>(
      () => _i913.ForgetPasswordUseCase(
        forgetPasswordRepo: gh<_i488.ForgetPasswordRepo>(),
      ),
    );
    gh.factory<_i22.ResetPasswordUseCase>(
      () => _i22.ResetPasswordUseCase(
        forgetPasswordRepo: gh<_i488.ForgetPasswordRepo>(),
      ),
    );
    gh.factory<_i722.VerifyOtpUseCase>(
      () => _i722.VerifyOtpUseCase(
        forgetPasswordRepo: gh<_i488.ForgetPasswordRepo>(),
      ),
    );
    gh.factory<_i682.RegisterRemoteDataSource>(
      () => _i550.RegisterRemoteDataSourceImpl(gh<_i347.DioRegisterApi>()),
    );
    gh.factory<_i441.AuthRemoteDataSource>(
      () => _i4.AuthRemoteDatasourceImpl(gh<_i144.AuthApiClient>()),
    );
    gh.factory<_i483.AuthRepo>(
      () => _i641.AuthRepositoryImpl(
        gh<_i441.AuthRemoteDataSource>(),
        gh<_i185.SafeCall>(),
        gh<_i964.TokenStorage>(),
      ),
    );
    gh.factory<_i57.RegisterRepository>(
      () => _i200.RegisterRepositoryImpl(
        gh<_i682.RegisterRemoteDataSource>(),
        gh<_i185.SafeCall>(),
      ),
    );
    gh.factory<_i795.ForgetPasswordCubit>(
      () => _i795.ForgetPasswordCubit(
        gh<_i913.ForgetPasswordUseCase>(),
        gh<_i722.VerifyOtpUseCase>(),
        gh<_i22.ResetPasswordUseCase>(),
      ),
    );
    gh.factory<_i118.RegisterUseCase>(
      () => _i753.RegisterUseCaseImpl(gh<_i57.RegisterRepository>()),
    );
    gh.factory<_i635.LoginUseCase>(
      () => _i635.LoginUseCase(gh<_i483.AuthRepo>()),
    );
    gh.factory<_i213.RegisterBloc>(
      () => _i213.RegisterBloc(
        gh<_i118.RegisterUseCase>(),
        gh<_i495.RegisterFormValidator>(),
      ),
    );
    gh.factory<_i188.LoginViewModel>(
      () => _i188.LoginViewModel(gh<_i635.LoginUseCase>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i505.RegisterModule {}

class _$DioModule extends _i948.DioModule {}

class _$DioRegisterApiModule extends _i347.DioRegisterApiModule {}

class _$ApiModule extends _i98.ApiModule {}
