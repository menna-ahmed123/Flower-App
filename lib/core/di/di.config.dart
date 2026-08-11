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

import '../../features/auth/login/data/api/auth_api_client.dart' as _i144;
import '../../features/auth/login/data/data_source/remote/auth_remote_data_source.dart'
    as _i441;
import '../../features/auth/login/data/data_source/remote/auth_remote_data_source_impl.dart'
    as _i4;
import '../../features/auth/login/data/repo/auth_repo_impl.dart' as _i641;
import '../../features/auth/login/domain/repo/auth_repo.dart' as _i483;
import '../../features/auth/login/domain/use_case/login_usecase.dart' as _i635;
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
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => registerModule.secureStorage,
    );
    gh.factory<_i441.AuthRemoteDataSource>(
      () => _i4.AuthRemoteDatasourceImpl(gh<_i144.AuthApiClient>()),
    );
    gh.lazySingleton<_i1058.TokenRefresher>(
      () => _i1058.UnconfiguredTokenRefresher(),
    );
    gh.lazySingleton<_i964.TokenStorage>(
      () => _i964.SecureTokenStorage(gh<_i558.FlutterSecureStorage>()),
    );
    gh.factory<_i483.AuthRepo>(
      () => _i641.AuthRepositoryImpl(
        gh<_i441.AuthRemoteDataSource>(),
        gh<_i185.SafeCall>(),
        gh<_i964.TokenStorage>(),
      ),
    );
    gh.lazySingleton<_i466.AuthInterceptors>(
      () => _i466.AuthInterceptors(
        gh<_i964.TokenStorage>(),
        gh<_i1058.TokenRefresher>(),
      ),
    );
    gh.factory<_i635.LoginUseCase>(
      () => _i635.LoginUseCase(gh<_i483.AuthRepo>()),
    );
    gh.singleton<_i361.Dio>(
      () => dioModule.provideDio(gh<_i466.AuthInterceptors>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i505.RegisterModule {}

class _$DioModule extends _i948.DioModule {}
