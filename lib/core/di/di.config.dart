// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../modules/dio_module.dart' as _i948;
import '../modules/shared_pref_module.dart' as _i187;
import '../network/auth_interceptors.dart' as _i466;
import '../network/safe_call.dart' as _i185;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final sharedPrefModule = _$SharedPrefModule();
    final dioModule = _$DioModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => sharedPrefModule.prefs,
      preResolve: true,
    );
    gh.factory<_i185.SafeCall>(() => _i185.SafeCall());
    gh.factory<_i466.AuthInterceptors>(
      () => _i466.AuthInterceptors(gh<_i460.SharedPreferences>()),
    );
    gh.singleton<_i361.Dio>(
      () => dioModule.provideDio(gh<_i466.AuthInterceptors>()),
    );
    return this;
  }
}

class _$SharedPrefModule extends _i187.SharedPrefModule {}

class _$DioModule extends _i948.DioModule {}
