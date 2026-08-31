import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/entities/location_entity.dart';
import 'package:flower_app/features/address/presentation/new_address/view/view_model/address_event.dart';
import 'package:flower_app/features/address/presentation/new_address/view/view_model/address_state.dart';
import 'package:flower_app/features/address/presentation/new_address/view/view_model/address_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/mockito.dart';

import 'address_view_model_test.mocks.dart';

void main() {
  provideDummy<BaseResponse<bool>>(
    const SuccessResponse<bool>(true),
  );

  provideDummy<BaseResponse<LocationPermission>>(
    const SuccessResponse<LocationPermission>(
      LocationPermission.whileInUse,
    ),
  );

  provideDummy<BaseResponse<LocationEntity>>(
    const SuccessResponse<LocationEntity>(
      LocationEntity(
        latitude: 27.18,
        longitude: 31.18,
      ),
    ),
  );

  provideDummy<BaseResponse<AddressEntity>>(
    const SuccessResponse<AddressEntity>(
      AddressEntity(
        address: '123 Street',
        phoneNumber: '01000000000',
        recipientName: 'Menna',
        city: 'Sohag',
        area: 'Sohag',
      ),
    ),
  );

  late MockIsLocationServiceEnabledUseCase
      isLocationServiceEnabledUseCase;

  late MockCheckLocationPermissionUseCase
      checkLocationPermissionUseCase;

  late MockRequestLocationPermissionUseCase
      requestLocationPermissionUseCase;

  late MockOpenLocationSettingsUseCase
      openLocationSettingsUseCase;

  late MockOpenAppSettingsUseCase
      openAppSettingsUseCase;

  late MockGetCurrentLocationUseCase
      getCurrentLocationUseCase;

  late MockGetAddressFromLocationUseCase
      getAddressFromLocationUseCase;

  late AddressViewModel addressViewModel;

  setUp(() {
    isLocationServiceEnabledUseCase =
        MockIsLocationServiceEnabledUseCase();

    checkLocationPermissionUseCase =
        MockCheckLocationPermissionUseCase();

    requestLocationPermissionUseCase =
        MockRequestLocationPermissionUseCase();

    openLocationSettingsUseCase =
        MockOpenLocationSettingsUseCase();

    openAppSettingsUseCase =
        MockOpenAppSettingsUseCase();

    getCurrentLocationUseCase =
        MockGetCurrentLocationUseCase();

    getAddressFromLocationUseCase =
        MockGetAddressFromLocationUseCase();

    addressViewModel = AddressViewModel(
      isLocationServiceEnabledUseCase,
      checkLocationPermissionUseCase,
      requestLocationPermissionUseCase,
      openLocationSettingsUseCase,
      openAppSettingsUseCase,
      getCurrentLocationUseCase,
      getAddressFromLocationUseCase,
    );
  });

  // ============================================================
  // GetCurrentAddress
  // ============================================================

  group('GetCurrentAddress', () {
    test('should get current address successfully', () async {
      const location = LocationEntity(
        latitude: 27.18,
        longitude: 31.18,
      );

      const address = AddressEntity(
        address: '123 Street',
        phoneNumber: '01000000000',
        recipientName: 'Menna',
        city: 'Sohag',
        area: 'Sohag',
      );

      when(
        isLocationServiceEnabledUseCase.call(),
      ).thenAnswer(
        (_) async => const SuccessResponse<bool>(true),
      );

      when(
        checkLocationPermissionUseCase.call(),
      ).thenAnswer(
        (_) async => const SuccessResponse<LocationPermission>(
          LocationPermission.whileInUse,
        ),
      );

      when(
        getCurrentLocationUseCase.call(),
      ).thenAnswer(
        (_) async => const SuccessResponse<LocationEntity>(location),
      );

      when(
        getAddressFromLocationUseCase(
          latitude: location.latitude,
          longitude: location.longitude,
        ),
      ).thenAnswer(
        (_) async => const SuccessResponse<AddressEntity>(address),
      );

      final future = expectLater(
        addressViewModel.stream,
        emitsInOrder([
          isA<AddressState>()
              .having(
                (state) => state.locationState.isLoading,
                'location isLoading',
                true,
              )
              .having(
                (state) => state.addressState.isLoading,
                'address isLoading',
                true,
              ),

          isA<AddressState>()
              .having(
                (state) => state.locationState.isLoading,
                'location isLoading',
                false,
              )
              .having(
                (state) => state.locationState.data,
                'location',
                location,
              )
              .having(
                (state) => state.addressState.isLoading,
                'address isLoading',
                true,
              ),

          isA<AddressState>()
              .having(
                (state) => state.addressState.isLoading,
                'address isLoading',
                false,
              )
              .having(
                (state) => state.addressState.data,
                'address',
                address,
              ),
        ]),
      );

      await addressViewModel.doEvent(
        GetCurrentAddress(),
      );

      await future;

      verify(
        isLocationServiceEnabledUseCase.call(),
      ).called(1);

      verify(
        checkLocationPermissionUseCase.call(),
      ).called(1);

      verify(
        getCurrentLocationUseCase.call(),
      ).called(1);

      verify(
        getAddressFromLocationUseCase(
          latitude: location.latitude,
          longitude: location.longitude,
        ),
      ).called(1);
    });

    test('should handle location service disabled', () async {
      when(
        isLocationServiceEnabledUseCase.call(),
      ).thenAnswer(
        (_) async => const SuccessResponse<bool>(false),
      );

      final future = expectLater(
        addressViewModel.stream,
        emitsInOrder([
          isA<AddressState>()
              .having(
                (state) => state.locationState.isLoading,
                'location isLoading',
                true,
              )
              .having(
                (state) => state.addressState.isLoading,
                'address isLoading',
                true,
              ),

          isA<AddressState>()
              .having(
                (state) => state.locationState.isLoading,
                'location isLoading',
                false,
              )
              .having(
                (state) => state.locationState.errorMessage,
                'location errorMessage',
                AppString.locationServicesDisabled,
              )
              .having(
                (state) => state.addressState.isLoading,
                'address isLoading',
                false,
              )
              .having(
                (state) => state.addressState.errorMessage,
                'address errorMessage',
                AppString.locationServicesDisabled,
              ),
        ]),
      );

      await addressViewModel.doEvent(
        GetCurrentAddress(),
      );

      await future;

      verify(
        isLocationServiceEnabledUseCase.call(),
      ).called(1);

      verifyNever(
        checkLocationPermissionUseCase.call(),
      );

      verifyNever(
        requestLocationPermissionUseCase.call(),
      );

      verifyNever(
        getCurrentLocationUseCase.call(),
      );
    });

    test('should handle location service check error', () async {
      final appError = NoInternetError(
        Exception(),
      );

      when(
        isLocationServiceEnabledUseCase.call(),
      ).thenAnswer(
        (_) async => ErrorResponse<bool>(
          appError: appError,
        ),
      );

      final future = expectLater(
        addressViewModel.stream,
        emitsInOrder([
          isA<AddressState>()
              .having(
                (state) => state.locationState.isLoading,
                'location isLoading',
                true,
              )
              .having(
                (state) => state.addressState.isLoading,
                'address isLoading',
                true,
              ),

          isA<AddressState>()
              .having(
                (state) => state.locationState.isLoading,
                'location isLoading',
                false,
              )
              .having(
                (state) => state.locationState.errorMessage,
                'location errorMessage',
                appError.message,
              )
              .having(
                (state) => state.addressState.isLoading,
                'address isLoading',
                false,
              )
              .having(
                (state) => state.addressState.errorMessage,
                'address errorMessage',
                appError.message,
              ),
        ]),
      );

      await addressViewModel.doEvent(
        GetCurrentAddress(),
      );

      await future;

      verify(
        isLocationServiceEnabledUseCase.call(),
      ).called(1);

      verifyNever(
        checkLocationPermissionUseCase.call(),
      );

      verifyNever(
        getCurrentLocationUseCase.call(),
      );
    });

    test(
      'should request permission when permission is denied',
      () async {
        const location = LocationEntity(
          latitude: 27.18,
          longitude: 31.18,
        );

        const address = AddressEntity(
          address: '123 Street',
          phoneNumber: '01000000000',
          recipientName: 'Menna',
          city: 'Sohag',
          area: 'Sohag',
        );

        when(
          isLocationServiceEnabledUseCase.call(),
        ).thenAnswer(
          (_) async => const SuccessResponse<bool>(true),
        );

        when(
          checkLocationPermissionUseCase.call(),
        ).thenAnswer(
          (_) async => const SuccessResponse<LocationPermission>(
            LocationPermission.denied,
          ),
        );

        when(
          requestLocationPermissionUseCase.call(),
        ).thenAnswer(
          (_) async => const SuccessResponse<LocationPermission>(
            LocationPermission.whileInUse,
          ),
        );

        when(
          getCurrentLocationUseCase.call(),
        ).thenAnswer(
          (_) async => const SuccessResponse<LocationEntity>(
            location,
          ),
        );

        when(
          getAddressFromLocationUseCase(
            latitude: location.latitude,
            longitude: location.longitude,
          ),
        ).thenAnswer(
          (_) async => const SuccessResponse<AddressEntity>(
            address,
          ),
        );

        final future = expectLater(
          addressViewModel.stream,
          emitsInOrder([
            isA<AddressState>().having(
              (state) => state.locationState.isLoading,
              'location isLoading',
              true,
            ),

            isA<AddressState>()
                .having(
                  (state) => state.locationState.isLoading,
                  'location isLoading',
                  false,
                )
                .having(
                  (state) => state.locationState.data,
                  'location',
                  location,
                ),

            isA<AddressState>()
                .having(
                  (state) => state.addressState.isLoading,
                  'address isLoading',
                  false,
                )
                .having(
                  (state) => state.addressState.data,
                  'address',
                  address,
                ),
          ]),
        );

        await addressViewModel.doEvent(
          GetCurrentAddress(),
        );

        await future;

        verify(
          isLocationServiceEnabledUseCase.call(),
        ).called(1);

        verify(
          checkLocationPermissionUseCase.call(),
        ).called(1);

        verify(
          requestLocationPermissionUseCase.call(),
        ).called(1);

        verify(
          getCurrentLocationUseCase.call(),
        ).called(1);
      },
    );

    test(
      'should handle permission permanently denied',
      () async {
        when(
          isLocationServiceEnabledUseCase.call(),
        ).thenAnswer(
          (_) async => const SuccessResponse<bool>(true),
        );

        when(
          checkLocationPermissionUseCase.call(),
        ).thenAnswer(
          (_) async => const SuccessResponse<LocationPermission>(
            LocationPermission.deniedForever,
          ),
        );

        final future = expectLater(
          addressViewModel.stream,
          emitsInOrder([
            isA<AddressState>()
                .having(
                  (state) => state.locationState.isLoading,
                  'location isLoading',
                  true,
                )
                .having(
                  (state) => state.addressState.isLoading,
                  'address isLoading',
                  true,
                ),

            isA<AddressState>()
                .having(
                  (state) => state.locationState.isLoading,
                  'location isLoading',
                  false,
                )
                .having(
                  (state) => state.locationState.errorMessage,
                  'location errorMessage',
                  AppString.locationPermissionPermanentlyDenied,
                )
                .having(
                  (state) => state.addressState.isLoading,
                  'address isLoading',
                  false,
                )
                .having(
                  (state) => state.addressState.errorMessage,
                  'address errorMessage',
                  AppString.locationPermissionPermanentlyDenied,
                ),
          ]),
        );

        await addressViewModel.doEvent(
          GetCurrentAddress(),
        );

        await future;

        verify(
          isLocationServiceEnabledUseCase.call(),
        ).called(1);

        verify(
          checkLocationPermissionUseCase.call(),
        ).called(1);

        verifyNever(
          requestLocationPermissionUseCase.call(),
        );

        verifyNever(
          getCurrentLocationUseCase.call(),
        );
      },
    );

    test(
      'should handle permission denied after request',
      () async {
        when(
          isLocationServiceEnabledUseCase.call(),
        ).thenAnswer(
          (_) async => const SuccessResponse<bool>(true),
        );

        when(
          checkLocationPermissionUseCase.call(),
        ).thenAnswer(
          (_) async => const SuccessResponse<LocationPermission>(
            LocationPermission.denied,
          ),
        );

        when(
          requestLocationPermissionUseCase.call(),
        ).thenAnswer(
          (_) async => const SuccessResponse<LocationPermission>(
            LocationPermission.denied,
          ),
        );

        final future = expectLater(
          addressViewModel.stream,
          emitsInOrder([
            isA<AddressState>().having(
              (state) => state.locationState.isLoading,
              'location isLoading',
              true,
            ),

            isA<AddressState>()
                .having(
                  (state) => state.locationState.isLoading,
                  'location isLoading',
                  false,
                )
                .having(
                  (state) => state.locationState.errorMessage,
                  'location errorMessage',
                  AppString.locationPermissionDenied,
                )
                .having(
                  (state) => state.addressState.isLoading,
                  'address isLoading',
                  false,
                ),
          ]),
        );

        await addressViewModel.doEvent(
          GetCurrentAddress(),
        );

        await future;

        verify(
          isLocationServiceEnabledUseCase.call(),
        ).called(1);

        verify(
          checkLocationPermissionUseCase.call(),
        ).called(1);

        verify(
          requestLocationPermissionUseCase.call(),
        ).called(1);

        verifyNever(
          getCurrentLocationUseCase.call(),
        );
      },
    );

    test(
      'should handle current location error',
      () async {
        final appError = NoInternetError(
          Exception(),
        );

        when(
          isLocationServiceEnabledUseCase.call(),
        ).thenAnswer(
          (_) async => const SuccessResponse<bool>(true),
        );

        when(
          checkLocationPermissionUseCase.call(),
        ).thenAnswer(
          (_) async => const SuccessResponse<LocationPermission>(
            LocationPermission.whileInUse,
          ),
        );

        when(
          getCurrentLocationUseCase.call(),
        ).thenAnswer(
          (_) async => ErrorResponse<LocationEntity>(
            appError: appError,
          ),
        );

        final future = expectLater(
          addressViewModel.stream,
          emitsInOrder([
            isA<AddressState>()
                .having(
                  (state) => state.locationState.isLoading,
                  'location isLoading',
                  true,
                )
                .having(
                  (state) => state.addressState.isLoading,
                  'address isLoading',
                  true,
                ),

            isA<AddressState>()
                .having(
                  (state) => state.locationState.isLoading,
                  'location isLoading',
                  false,
                )
                .having(
                  (state) => state.locationState.errorMessage,
                  'location errorMessage',
                  appError.message,
                )
                .having(
                  (state) => state.addressState.isLoading,
                  'address isLoading',
                  false,
                )
                .having(
                  (state) => state.addressState.errorMessage,
                  'address errorMessage',
                  appError.message,
                ),
          ]),
        );

        await addressViewModel.doEvent(
          GetCurrentAddress(),
        );

        await future;

        verify(
          isLocationServiceEnabledUseCase.call(),
        ).called(1);

        verify(
          checkLocationPermissionUseCase.call(),
        ).called(1);

        verify(
          getCurrentLocationUseCase.call(),
        ).called(1);
      },
    );

    test(
      'should handle address error',
      () async {
        const location = LocationEntity(
          latitude: 27.18,
          longitude: 31.18,
        );

        final appError = BadResponseError(
          'Failed to get address',
        );

        when(
          isLocationServiceEnabledUseCase.call(),
        ).thenAnswer(
          (_) async => const SuccessResponse<bool>(true),
        );

        when(
          checkLocationPermissionUseCase.call(),
        ).thenAnswer(
          (_) async => const SuccessResponse<LocationPermission>(
            LocationPermission.whileInUse,
          ),
        );

        when(
          getCurrentLocationUseCase.call(),
        ).thenAnswer(
          (_) async => const SuccessResponse<LocationEntity>(
            location,
          ),
        );

        when(
          getAddressFromLocationUseCase(
            latitude: location.latitude,
            longitude: location.longitude,
          ),
        ).thenAnswer(
          (_) async => ErrorResponse<AddressEntity>(
            appError: appError,
          ),
        );

        final future = expectLater(
          addressViewModel.stream,
          emitsInOrder([
            isA<AddressState>()
                .having(
                  (state) => state.locationState.isLoading,
                  'location isLoading',
                  true,
                )
                .having(
                  (state) => state.addressState.isLoading,
                  'address isLoading',
                  true,
                ),

            isA<AddressState>()
                .having(
                  (state) => state.locationState.isLoading,
                  'location isLoading',
                  false,
                )
                .having(
                  (state) => state.locationState.data,
                  'location',
                  location,
                )
                .having(
                  (state) => state.addressState.isLoading,
                  'address isLoading',
                  true,
                ),

            isA<AddressState>()
                .having(
                  (state) => state.addressState.isLoading,
                  'address isLoading',
                  false,
                )
                .having(
                  (state) => state.addressState.errorMessage,
                  'address errorMessage',
                  appError.message,
                ),
          ]),
        );

        await addressViewModel.doEvent(
          GetCurrentAddress(),
        );

        await future;

        verify(
          isLocationServiceEnabledUseCase.call(),
        ).called(1);

        verify(
          checkLocationPermissionUseCase.call(),
        ).called(1);

        verify(
          getCurrentLocationUseCase.call(),
        ).called(1);

        verify(
          getAddressFromLocationUseCase(
            latitude: location.latitude,
            longitude: location.longitude,
          ),
        ).called(1);
      },
    );
  });

  // ============================================================
  // LocationSelected
  // ============================================================

  group('LocationSelected', () {
    test(
      'should get address successfully when location is selected',
      () async {
        const latitude = 27.18;
        const longitude = 31.18;

        const address = AddressEntity(
          address: '123 Street',
          phoneNumber: '01000000000',
          recipientName: 'Menna',
          city: 'Sohag',
          area: 'Sohag',
        );

        when(
          getAddressFromLocationUseCase(
            latitude: latitude,
            longitude: longitude,
          ),
        ).thenAnswer(
          (_) async => const SuccessResponse<AddressEntity>(
            address,
          ),
        );

        final future = expectLater(
          addressViewModel.stream,
          emitsInOrder([
            isA<AddressState>().having(
              (state) => state.addressState.isLoading,
              'address isLoading',
              true,
            ),

            isA<AddressState>()
                .having(
                  (state) => state.addressState.isLoading,
                  'address isLoading',
                  false,
                )
                .having(
                  (state) => state.addressState.data,
                  'address',
                  address,
                ),
          ]),
        );

        await addressViewModel.doEvent(
          LocationSelected(
            latitude: latitude,
            longitude: longitude,
          ),
        );

        await future;

        verify(
          getAddressFromLocationUseCase(
            latitude: latitude,
            longitude: longitude,
          ),
        ).called(1);

        verifyNever(
          getCurrentLocationUseCase.call(),
        );

        verifyNever(
          isLocationServiceEnabledUseCase.call(),
        );

        verifyNever(
          checkLocationPermissionUseCase.call(),
        );
      },
    );

    test(
      'should handle error when location is selected',
      () async {
        const latitude = 27.18;
        const longitude = 31.18;

        final appError = NoInternetError(
          Exception(),
        );

        when(
          getAddressFromLocationUseCase(
            latitude: latitude,
            longitude: longitude,
          ),
        ).thenAnswer(
          (_) async => ErrorResponse<AddressEntity>(
            appError: appError,
          ),
        );

        final future = expectLater(
          addressViewModel.stream,
          emitsInOrder([
            isA<AddressState>().having(
              (state) => state.addressState.isLoading,
              'address isLoading',
              true,
            ),

            isA<AddressState>()
                .having(
                  (state) => state.addressState.isLoading,
                  'address isLoading',
                  false,
                )
                .having(
                  (state) => state.addressState.errorMessage,
                  'address errorMessage',
                  appError.message,
                ),
          ]),
        );

        await addressViewModel.doEvent(
          LocationSelected(
            latitude: latitude,
            longitude: longitude,
          ),
        );

        await future;

        verify(
          getAddressFromLocationUseCase(
            latitude: latitude,
            longitude: longitude,
          ),
        ).called(1);

        verifyNever(
          getCurrentLocationUseCase.call(),
        );

        verifyNever(
          isLocationServiceEnabledUseCase.call(),
        );

        verifyNever(
          checkLocationPermissionUseCase.call(),
        );
      },
    );
  });

  // ============================================================
  // Settings
  // ============================================================

  group('Settings', () {
    test(
      'should open location settings',
      () async {
        when(
          openLocationSettingsUseCase.call(),
        ).thenAnswer(
          (_) async => const SuccessResponse<bool>(true),
        );

        await addressViewModel.openLocationSettings();

        verify(
          openLocationSettingsUseCase.call(),
        ).called(1);
      },
    );

    test(
      'should open app settings',
      () async {
        when(
          openAppSettingsUseCase.call(),
        ).thenAnswer(
          (_) async => const SuccessResponse<bool>(true),
        );

        await addressViewModel.openAppSettings();

        verify(
          openAppSettingsUseCase.call(),
        ).called(1);
      },
    );
  });
}

