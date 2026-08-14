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

import '../../features/auth/register/api/dio_register_api.dart' as _i347;
import '../../features/auth/register/api/register_api.dart' as _i397;
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
import '../modules/dio_module.dart' as _i948;
import '../modules/register_module.dart' as _i505;
import '../network/auth_interceptors.dart' as _i466;
import '../network/safe_call.dart' as _i185;
import '../network/token_refresher.dart' as _i1058;
import '../network/token_storage.dart' as _i964;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    final dioModule = _$DioModule();
    gh.factory<_i185.SafeCall>(() => _i185.SafeCall());
    gh.factory<_i495.RegisterFormValidator>(
      () => const _i495.RegisterFormValidator(),
    );
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => registerModule.secureStorage,
    );
    gh.lazySingleton<_i1058.TokenRefresher>(
      () => _i1058.UnconfiguredTokenRefresher(),
    );
    gh.lazySingleton<_i964.TokenStorage>(
      () => _i964.SecureTokenStorage(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i466.AuthInterceptors>(
      () => _i466.AuthInterceptors(
        gh<_i964.TokenStorage>(),
        gh<_i1058.TokenRefresher>(),
      ),
    );
    gh.singleton<_i361.Dio>(
      () => dioModule.provideDio(gh<_i466.AuthInterceptors>()),
    );
    gh.lazySingleton<_i397.RegisterApi>(
      () => _i347.DioRegisterApi(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i682.RegisterRemoteDataSource>(
      () => _i550.RegisterRemoteDataSourceImpl(gh<_i397.RegisterApi>()),
    );
    gh.lazySingleton<_i57.RegisterRepository>(
      () => _i200.RegisterRepositoryImpl(
        gh<_i682.RegisterRemoteDataSource>(),
        gh<_i185.SafeCall>(),
      ),
    );
    gh.factory<_i118.RegisterUseCase>(
      () => _i753.RegisterUseCaseImpl(gh<_i57.RegisterRepository>()),
    );
    gh.factory<_i213.RegisterBloc>(
      () => _i213.RegisterBloc(
        gh<_i118.RegisterUseCase>(),
        gh<_i495.RegisterFormValidator>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i505.RegisterModule {}

class _$DioModule extends _i948.DioModule {}
