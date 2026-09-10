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
import 'package:geolocator/geolocator.dart' as _i699;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/address/api/address_api_client.dart' as _i328;
import '../../features/address/data/data_sources/address_remote_data_source.dart'
    as _i581;
import '../../features/address/data/data_sources/address_remote_data_source_impl.dart'
    as _i784;
import '../../features/address/data/repo/address_repo_impl.dart' as _i660;
import '../../features/address/domain/repo/address_repo.dart' as _i366;
import '../../features/address/domain/use_cases/add_address_use_case.dart'
    as _i458;
import '../../features/address/domain/use_cases/check_location_permission_use_case.dart'
    as _i203;
import '../../features/address/domain/use_cases/delete_address_use_case.dart'
    as _i951;
import '../../features/address/domain/use_cases/get_address_details_use_case.dart'
    as _i99;
import '../../features/address/domain/use_cases/get_address_from_location_use_case.dart'
    as _i848;
import '../../features/address/domain/use_cases/get_address_use_case.dart'
    as _i270;
import '../../features/address/domain/use_cases/get_current_location_use_case.dart'
    as _i990;
import '../../features/address/domain/use_cases/is_location_service_enabled_use_case.dart'
    as _i373;
import '../../features/address/domain/use_cases/open_app_settings_use_case.dart'
    as _i84;
import '../../features/address/domain/use_cases/open_location_settings_use_case.dart'
    as _i920;
import '../../features/address/domain/use_cases/request_location_permission_use_case.dart'
    as _i94;
import '../../features/address/domain/use_cases/set_default_address_use_case.dart'
    as _i1017;
import '../../features/address/domain/use_cases/update_address_use_case.dart'
    as _i130;
import '../../features/address/presentation/default_address_view_model/default_address_view_model.dart'
    as _i349;
import '../../features/address/presentation/new_address/view_model/address_view_model.dart'
    as _i28;
import '../../features/address/presentation/save_address/view_model/save_address_view_model.dart'
    as _i236;
import '../../features/auth/core/data/repos/auth_repository_impl.dart' as _i436;
import '../../features/auth/core/domain/repos/auth_repository.dart' as _i179;
import '../../features/auth/core/presentation/view_model/auth_cubit.dart'
    as _i571;
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
import '../../features/auth/login/domain/use_case/logout_usecase.dart' as _i609;
import '../../features/auth/login/presentation/view_model/login_view_model.dart'
    as _i188;
import '../../features/auth/register/data/api/register_api_client.dart' as _i3;
import '../../features/auth/register/data/data_source/remote/register_remote_data_source.dart'
    as _i258;
import '../../features/auth/register/data/data_source/remote/register_remote_data_source_impl.dart'
    as _i453;
import '../../features/auth/register/data/repo/register_repo_impl.dart'
    as _i934;
import '../../features/auth/register/domain/repo/register_repo.dart' as _i926;
import '../../features/auth/register/domain/use_case/register_usecase.dart'
    as _i95;
import '../../features/auth/register/presentation/view_model/register_view_model.dart'
    as _i656;
import '../../features/cart/api/cart_api_client.dart' as _i1046;
import '../../features/cart/data/data_sources/cart_remote_data_source.dart'
    as _i164;
import '../../features/cart/data/data_sources/cart_remote_data_source_impl.dart'
    as _i916;
import '../../features/cart/data/repo/cart_repo_impl.dart' as _i234;
import '../../features/cart/domain/repo/cart_repo.dart' as _i379;
import '../../features/cart/domain/use_cases/cart_use_case.dart' as _i886;
import '../../features/cart/presentation/view_model/cart_view_model.dart'
    as _i572;
import '../../features/commerce/api/commerce_api_client.dart' as _i243;
import '../../features/commerce/data/data_sources/commerce_remote_data_source.dart'
    as _i696;
import '../../features/commerce/data/data_sources/commerce_remote_data_source_impl.dart'
    as _i1023;
import '../../features/commerce/data/repo/commerce_repo_impl.dart' as _i861;
import '../../features/commerce/domain/repo/commerce_repo.dart' as _i772;
import '../../features/commerce/domain/use_cases/category_use_case.dart'
    as _i242;
import '../../features/commerce/domain/use_cases/home_use_case.dart' as _i1049;
import '../../features/commerce/domain/use_cases/occasion_use_case.dart'
    as _i682;
import '../../features/commerce/domain/use_cases/product_details_use_case.dart'
    as _i172;
import '../../features/commerce/domain/use_cases/product_use_case.dart'
    as _i613;
import '../../features/commerce/domain/use_cases/search_use_case.dart' as _i864;
import '../../features/commerce/presentation/best_seller/view_model/best_seller_view_model.dart'
    as _i969;
import '../../features/commerce/presentation/category/view_model/category_view_model.dart'
    as _i605;
import '../../features/commerce/presentation/home/view_model/home_view_model.dart'
    as _i369;
import '../../features/commerce/presentation/occasion/view_model/occasion_view_model.dart'
    as _i421;
import '../../features/commerce/presentation/prodect_details/view_model/product_details_view_model.dart'
    as _i784;
import '../../features/commerce/presentation/search/view_model/search_view_model.dart'
    as _i1068;
import '../modules/api_module.dart' as _i98;
import '../modules/dio_module.dart' as _i948;
import '../modules/location_module.dart' as _i917;
import '../modules/register_module.dart' as _i505;
import '../network/auth_interceptors.dart' as _i466;
import '../network/safe_call.dart' as _i185;
import '../network/token_refresher.dart' as _i1058;
import '../network/token_storage.dart' as _i964;
import '../services/geocoding_service.dart' as _i980;
import '../services/location_service.dart' as _i669;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final locationModule = _$LocationModule();
    final registerModule = _$RegisterModule();
    final dioModule = _$DioModule();
    final apiModule = _$ApiModule();
    gh.factory<_i185.SafeCall>(() => _i185.SafeCall());
    gh.factory<_i980.GeocodingService>(() => _i980.GeocodingService());
    gh.lazySingleton<_i699.GeolocatorPlatform>(() => locationModule.geolocator);
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => registerModule.secureStorage,
    );
    await gh.lazySingletonAsync<_i460.SharedPreferences>(
      () => registerModule.prefs(),
      preResolve: true,
    );
    gh.lazySingleton<_i1058.TokenRefresher>(() => _i1058.ApiTokenRefresher());
    gh.lazySingleton<_i964.TokenStorage>(
      () => _i964.SecureTokenStorage(gh<_i558.FlutterSecureStorage>()),
    );
    gh.factory<_i669.LocationService>(
      () => _i669.LocationService(gh<_i699.GeolocatorPlatform>()),
    );
    gh.lazySingleton<_i466.AuthInterceptors>(
      () => _i466.AuthInterceptors(
        gh<_i964.TokenStorage>(),
        gh<_i1058.TokenRefresher>(),
      ),
    );
    gh.lazySingleton<_i179.AuthRepository>(
      () => _i436.AuthRepositoryImpl(gh<_i964.TokenStorage>()),
    );
    gh.lazySingleton<_i571.AuthCubit>(
      () => _i571.AuthCubit(gh<_i179.AuthRepository>()),
    );
    gh.singleton<_i361.Dio>(
      () => dioModule.provideDio(gh<_i466.AuthInterceptors>()),
    );
    gh.singleton<_i597.ForgetPasswordApiClient>(
      () => apiModule.provideForgetPasswordApiClient(gh<_i361.Dio>()),
    );
    gh.singleton<_i144.AuthApiClient>(
      () => apiModule.provideAuthApiClient(gh<_i361.Dio>()),
    );
    gh.singleton<_i3.RegisterApiClient>(
      () => apiModule.provideRegisterApiClient(gh<_i361.Dio>()),
    );
    gh.singleton<_i243.CommerceApiClient>(
      () => apiModule.provideCommerceApiClient(gh<_i361.Dio>()),
    );
    gh.singleton<_i328.AddressApiClient>(
      () => apiModule.provideAddressApiClient(gh<_i361.Dio>()),
    );
    gh.singleton<_i1046.CartApiClient>(
      () => apiModule.provideCartApiClient(gh<_i361.Dio>()),
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
    gh.factory<_i696.CommerceRemoteDataSource>(
      () => _i1023.CommerceRemoteDataSourceImpl(gh<_i243.CommerceApiClient>()),
    );
    gh.factory<_i258.RegisterRemoteDataSource>(
      () => _i453.RegisterRemoteDataSourceImpl(gh<_i3.RegisterApiClient>()),
    );
    gh.factory<_i772.CommerceRepo>(
      () => _i861.CommerceRepoImpl(
        gh<_i696.CommerceRemoteDataSource>(),
        gh<_i185.SafeCall>(),
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
    gh.factory<_i926.RegisterRepo>(
      () => _i934.RegisterRepositoryImpl(
        gh<_i258.RegisterRemoteDataSource>(),
        gh<_i185.SafeCall>(),
      ),
    );
    gh.factory<_i1049.HomeUseCase>(
      () => _i1049.HomeUseCase(gh<_i772.CommerceRepo>()),
    );
    gh.factory<_i682.OccasionUseCase>(
      () => _i682.OccasionUseCase(gh<_i772.CommerceRepo>()),
    );
    gh.factory<_i581.AddressRemoteDataSource>(
      () => _i784.AddressRemoteDataSourceImpl(
        addressApiClient: gh<_i328.AddressApiClient>(),
      ),
    );
    gh.factory<_i864.SearchUseCase>(
      () => _i864.SearchUseCase(gh<_i772.CommerceRepo>()),
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
    gh.factory<_i172.ProductDetailsUseCase>(
      () => _i172.ProductDetailsUseCase(commerceRepo: gh<_i772.CommerceRepo>()),
    );
    gh.factory<_i1068.SearchViewModel>(
      () => _i1068.SearchViewModel(gh<_i864.SearchUseCase>()),
    );
    gh.factory<_i613.ProductUseCase>(
      () => _i613.ProductUseCase(gh<_i772.CommerceRepo>()),
    );
    gh.factory<_i164.CartRemoteDataSource>(
      () => _i916.CartRemoteDataSourceImpl(gh<_i1046.CartApiClient>()),
    );
    gh.factory<_i366.AddressRepo>(
      () => _i660.AddressRepoImpl(
        gh<_i669.LocationService>(),
        gh<_i980.GeocodingService>(),
        gh<_i185.SafeCall>(),
        gh<_i581.AddressRemoteDataSource>(),
      ),
    );
    gh.factory<_i95.RegisterUseCase>(
      () => _i95.RegisterUseCase(gh<_i926.RegisterRepo>()),
    );
    gh.factory<_i203.CheckLocationPermissionUseCase>(
      () => _i203.CheckLocationPermissionUseCase(gh<_i366.AddressRepo>()),
    );
    gh.factory<_i848.GetAddressFromLocationUseCase>(
      () => _i848.GetAddressFromLocationUseCase(gh<_i366.AddressRepo>()),
    );
    gh.factory<_i990.GetCurrentLocationUseCase>(
      () => _i990.GetCurrentLocationUseCase(gh<_i366.AddressRepo>()),
    );
    gh.factory<_i373.IsLocationServiceEnabledUseCase>(
      () => _i373.IsLocationServiceEnabledUseCase(gh<_i366.AddressRepo>()),
    );
    gh.factory<_i84.OpenAppSettingsUseCase>(
      () => _i84.OpenAppSettingsUseCase(gh<_i366.AddressRepo>()),
    );
    gh.factory<_i920.OpenLocationSettingsUseCase>(
      () => _i920.OpenLocationSettingsUseCase(gh<_i366.AddressRepo>()),
    );
    gh.factory<_i94.RequestLocationPermissionUseCase>(
      () => _i94.RequestLocationPermissionUseCase(gh<_i366.AddressRepo>()),
    );
    gh.factory<_i242.CategoryUseCase>(
      () => _i242.CategoryUseCase(gh<_i772.CommerceRepo>()),
    );
    gh.factory<_i795.ForgetPasswordCubit>(
      () => _i795.ForgetPasswordCubit(
        gh<_i913.ForgetPasswordUseCase>(),
        gh<_i722.VerifyOtpUseCase>(),
        gh<_i22.ResetPasswordUseCase>(),
      ),
    );
    gh.factory<_i379.CartRepo>(
      () => _i234.CartRepoImpl(
        gh<_i164.CartRemoteDataSource>(),
        gh<_i185.SafeCall>(),
      ),
    );
    gh.factory<_i635.LoginUseCase>(
      () => _i635.LoginUseCase(gh<_i483.AuthRepo>()),
    );
    gh.factory<_i969.BestSellerViewModel>(
      () => _i969.BestSellerViewModel(gh<_i613.ProductUseCase>()),
    );
    gh.factory<_i458.AddAddressUseCase>(
      () => _i458.AddAddressUseCase(repo: gh<_i366.AddressRepo>()),
    );
    gh.factory<_i951.DeleteAddressUseCase>(
      () => _i951.DeleteAddressUseCase(repo: gh<_i366.AddressRepo>()),
    );
    gh.factory<_i99.GetAddressDetailsUseCase>(
      () => _i99.GetAddressDetailsUseCase(repo: gh<_i366.AddressRepo>()),
    );
    gh.factory<_i270.GetAddressesUseCase>(
      () => _i270.GetAddressesUseCase(repo: gh<_i366.AddressRepo>()),
    );
    gh.factory<_i130.UpdateAddressUseCase>(
      () => _i130.UpdateAddressUseCase(repo: gh<_i366.AddressRepo>()),
    );
    gh.factory<_i656.RegisterViewModel>(
      () => _i656.RegisterViewModel(gh<_i95.RegisterUseCase>()),
    );
    gh.factory<_i369.HomeViewModel>(
      () => _i369.HomeViewModel(gh<_i1049.HomeUseCase>()),
    );
    gh.factory<_i784.ProductDetailsViewModel>(
      () => _i784.ProductDetailsViewModel(gh<_i172.ProductDetailsUseCase>()),
    );
    gh.factory<_i609.LogoutUseCase>(
      () => _i609.LogoutUseCase(gh<_i483.AuthRepo>()),
    );
    gh.factory<_i605.CategoryViewModel>(
      () => _i605.CategoryViewModel(
        gh<_i242.CategoryUseCase>(),
        gh<_i613.ProductUseCase>(),
      ),
    );
    gh.factory<_i421.OccasionViewModel>(
      () => _i421.OccasionViewModel(
        gh<_i682.OccasionUseCase>(),
        gh<_i613.ProductUseCase>(),
      ),
    );
    gh.factory<_i1017.SetDefaultAddressUseCase>(
      () => _i1017.SetDefaultAddressUseCase(gh<_i366.AddressRepo>()),
    );
    gh.factory<_i886.CartUseCase>(
      () => _i886.CartUseCase(gh<_i379.CartRepo>()),
    );
    gh.factory<_i188.LoginViewModel>(
      () => _i188.LoginViewModel(gh<_i635.LoginUseCase>()),
    );
    gh.factory<_i28.AddressViewModel>(
      () => _i28.AddressViewModel(
        gh<_i373.IsLocationServiceEnabledUseCase>(),
        gh<_i203.CheckLocationPermissionUseCase>(),
        gh<_i94.RequestLocationPermissionUseCase>(),
        gh<_i920.OpenLocationSettingsUseCase>(),
        gh<_i84.OpenAppSettingsUseCase>(),
        gh<_i990.GetCurrentLocationUseCase>(),
        gh<_i848.GetAddressFromLocationUseCase>(),
        gh<_i99.GetAddressDetailsUseCase>(),
      ),
    );
    gh.factory<_i236.SaveAddressViewModel>(
      () => _i236.SaveAddressViewModel(
        gh<_i458.AddAddressUseCase>(),
        gh<_i130.UpdateAddressUseCase>(),
      ),
    );
    gh.lazySingleton<_i572.CartViewModel>(
      () => _i572.CartViewModel(gh<_i886.CartUseCase>()),
    );
    gh.singleton<_i349.DefaultAddressViewModel>(
      () => _i349.DefaultAddressViewModel(
        gh<_i270.GetAddressesUseCase>(),
        gh<_i951.DeleteAddressUseCase>(),
        gh<_i1017.SetDefaultAddressUseCase>(),
      ),
    );
    return this;
  }
}

class _$LocationModule extends _i917.LocationModule {}

class _$RegisterModule extends _i505.RegisterModule {}

class _$DioModule extends _i948.DioModule {}

class _$ApiModule extends _i98.ApiModule {}
