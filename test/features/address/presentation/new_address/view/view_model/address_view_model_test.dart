import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/entities/location_entity.dart';
import 'package:flower_app/features/address/domain/use_cases/get_address_from_location_use_case.dart';
import 'package:flower_app/features/address/domain/use_cases/get_current_location_use_case.dart';
import 'package:flower_app/features/address/presentation/new_address/view/view_model/address_event.dart';
import 'package:flower_app/features/address/presentation/new_address/view/view_model/address_state.dart';
import 'package:flower_app/features/address/presentation/new_address/view/view_model/address_view_model.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'address_view_model_test.mocks.dart';

@GenerateMocks([
  GetCurrentLocationUseCase,
  GetAddressFromLocationUseCase,
])
void main() {
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

  late MockGetCurrentLocationUseCase getCurrentLocationUseCase;
  late MockGetAddressFromLocationUseCase getAddressFromLocationUseCase;
  late AddressViewModel addressViewModel;

  setUp(() {
    getCurrentLocationUseCase = MockGetCurrentLocationUseCase();
    getAddressFromLocationUseCase =
        MockGetAddressFromLocationUseCase();

    addressViewModel = AddressViewModel(
      getCurrentLocationUseCase,
      getAddressFromLocationUseCase,
    );
  });

  // ============================================================
  // GetCurrentAddress
  // ============================================================

  group('GetCurrentAddress', () {
    test('should get current address successfully', () async {
      // Arrange

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

      when(getCurrentLocationUseCase.call()).thenAnswer(
        (_) async =>
            const SuccessResponse<LocationEntity>(location),
      );

      when(
        getAddressFromLocationUseCase(
          latitude: location.latitude,
          longitude: location.longitude,
        ),
      ).thenAnswer(
        (_) async =>
            const SuccessResponse<AddressEntity>(address),
      );

      final future = expectLater(
        addressViewModel.stream,
        emitsInOrder([
          // 1. Initial Loading
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

          // 2. Location Success
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

          // 3. Address Success
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

      // Act
      await addressViewModel.doEvent(
        GetCurrentAddress(),
      );

      await future;

      // Assert
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

    test('should handle location error', () async {
      // Arrange

      final appError = NoInternetError(Exception());

      when(getCurrentLocationUseCase.call()).thenAnswer(
        (_) async => ErrorResponse<LocationEntity>(
          appError: appError,
        ),
      );

      final future = expectLater(
        addressViewModel.stream,
        emitsInOrder([
          // 1. Loading
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

          // 2. Error
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

      // Act
      await addressViewModel.doEvent(
        GetCurrentAddress(),
      );

      await future;

      // Assert
      verify(
        getCurrentLocationUseCase.call(),
      ).called(1);

      verifyNever(
        getAddressFromLocationUseCase(
          latitude: anyNamed('latitude'),
          longitude: anyNamed('longitude'),
        ),
      );
    });

    test('should handle address error', () async {
      // Arrange

      const location = LocationEntity(
        latitude: 27.18,
        longitude: 31.18,
      );

      final appError = BadResponseError(
        'Failed to get address',
      );

      when(getCurrentLocationUseCase.call()).thenAnswer(
        (_) async =>
            const SuccessResponse<LocationEntity>(location),
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
          // 1. Initial Loading
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

          // 2. Location Success
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

          // 3. Address Error
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

      // Act
      await addressViewModel.doEvent(
        GetCurrentAddress(),
      );

      await future;

      // Assert
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
  });

  // ============================================================
  // LocationSelected
  // ============================================================

  group('LocationSelected', () {
    test(
      'should get address successfully when location is selected',
      () async {
        // Arrange

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
          (_) async =>
              const SuccessResponse<AddressEntity>(address),
        );

        final future = expectLater(
          addressViewModel.stream,
          emitsInOrder([
            // 1. Loading
            isA<AddressState>().having(
              (state) => state.addressState.isLoading,
              'address isLoading',
              true,
            ),

            // 2. Success
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

        // Act
        await addressViewModel.doEvent(
          LocationSelected(
            latitude: latitude,
            longitude: longitude,
          ),
        );

        await future;

        // Assert
        verify(
          getAddressFromLocationUseCase(
            latitude: latitude,
            longitude: longitude,
          ),
        ).called(1);

        verifyNever(
          getCurrentLocationUseCase.call(),
        );
      },
    );

    test(
      'should handle error when location is selected',
      () async {
        // Arrange

        const latitude = 27.18;
        const longitude = 31.18;

        final appError = NoInternetError(Exception());

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
            // 1. Loading
            isA<AddressState>().having(
              (state) => state.addressState.isLoading,
              'address isLoading',
              true,
            ),

            // 2. Error
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

        // Act
        await addressViewModel.doEvent(
          LocationSelected(
            latitude: latitude,
            longitude: longitude,
          ),
        );

        await future;

        // Assert
        verify(
          getAddressFromLocationUseCase(
            latitude: latitude,
            longitude: longitude,
          ),
        ).called(1);

        verifyNever(
          getCurrentLocationUseCase.call(),
        );
      },
    );
  });
}

