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

import '../../features/forget_password/api/client/forget_password_api_client.dart'
    as _i864;
import '../../features/forget_password/api/data_source/forget_password_remote_data_source_impl.dart'
    as _i643;
import '../../features/forget_password/data/data_sources/remote/forget_password_remote_data_source.dart'
    as _i881;
import '../../features/forget_password/data/repos/forget_password_repo_impl.dart'
    as _i216;
import '../../features/forget_password/domain/repos/forget_password_repo.dart'
    as _i639;
import '../../features/forget_password/domain/use_cases/forget_password_use_case.dart'
    as _i437;
import '../../features/forget_password/domain/use_cases/verify_otp_use_case.dart'
    as _i222;
import '../../features/forget_password/presentation/view_model/forget_password_cubit.dart'
    as _i1064;
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
    gh.singleton<_i864.ForgetPasswordApiClient>(
      () => apiModule.provideForgetPasswordApiClient(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i881.ForgetPasswordRemoteDataSource>(
      () => _i643.ForgetPasswordRemoteDataSourceImpl(
        forgetPasswordApiClient: gh<_i864.ForgetPasswordApiClient>(),
        safeCall: gh<_i185.SafeCall>(),
      ),
    );
    gh.lazySingleton<_i639.ForgetPasswordRepo>(
      () => _i216.ForgetPasswordRepoImpl(
        remoteDataSource: gh<_i881.ForgetPasswordRemoteDataSource>(),
      ),
    );
    gh.factory<_i437.ForgetPasswordUseCase>(
      () => _i437.ForgetPasswordUseCase(
        forgetPasswordRepo: gh<_i639.ForgetPasswordRepo>(),
      ),
    );
    gh.factory<_i222.VerifyOtpUseCase>(
      () => _i222.VerifyOtpUseCase(
        forgetPasswordRepo: gh<_i639.ForgetPasswordRepo>(),
      ),
    );
    gh.factory<_i1064.ForgetPasswordCubit>(
      () => _i1064.ForgetPasswordCubit(
        gh<_i437.ForgetPasswordUseCase>(),
        gh<_i222.VerifyOtpUseCase>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i505.RegisterModule {}

class _$DioModule extends _i948.DioModule {}

class _$ApiModule extends _i98.ApiModule {}
