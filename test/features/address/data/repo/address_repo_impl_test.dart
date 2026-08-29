import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/api_exception.dart';
import 'package:flower_app/core/network/safe_call.dart';
import 'package:flower_app/core/services/geocoding_service.dart';
import 'package:flower_app/core/services/location_service.dart';
import 'package:flower_app/features/address/data/data_sources/address_remote_data_source.dart';
import 'package:flower_app/features/address/data/models/add_address_request.dart';
import 'package:flower_app/features/address/data/models/add_address_response.dart';
import 'package:flower_app/features/address/data/models/address_dto.dart';
import 'package:flower_app/features/address/data/repo/address_repo_impl.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'address_repo_impl_test.mocks.dart';

@GenerateMocks([LocationService, GeocodingService, AddressRemoteDataSource])
void main() {
  provideDummy<AddressResponse>(
    AddressResponse(
      success: true,
      statusCode: 200,
      message: 'Success',
      messageLocalized: 'Success',
      data: const [],
    ),
  );

  late MockLocationService locationService;
  late MockGeocodingService geocodingService;
  late MockAddressRemoteDataSource remoteDataSource;
  late AddressRepositoryImpl repo;

  final request = AddAddressRequest(
    recipientName: 'Joudy',
    phone: '01000000000',
    addressLine: '12 Nile St',
    city: 'Cairo',
    area: 'Dokki',
    label: 'Home',
  );

  final addressDto = AddressDto(
    id: 'addr-1',
    recipientName: 'Joudy',
    phone: '01000000000',
    addressLine: '12 Nile St',
    city: 'Cairo',
    area: 'Dokki',
    lat: 30.0,
    lng: 31.0,
    label: 'Home',
    servingStoreId: 'store-1',
    isServiceable: true,
    isDefault: true,
  );

  AddressResponse successResponse() {
    return AddressResponse(
      success: true,
      statusCode: 200,
      message: 'Success',
      messageLocalized: 'Success',
      data: [addressDto],
    );
  }

  setUp(() {
    locationService = MockLocationService();
    geocodingService = MockGeocodingService();
    remoteDataSource = MockAddressRemoteDataSource();
    repo = AddressRepositoryImpl(
      locationService,
      geocodingService,
      SafeCall(),
      remoteDataSource,
    );
  });

  group('getAddresses', () {
    test('returns SuccessResponse when data source succeeds', () async {
      when(remoteDataSource.getAddresses()).thenAnswer(
        (_) async => successResponse(),
      );

      final result = await repo.getAddresses();

      expect(result, isA<SuccessResponse<List<AddressEntity>>>());
      final data = (result as SuccessResponse<List<AddressEntity>>).data;
      expect(data, hasLength(1));
      expect(data.first.id, 'addr-1');
      expect(data.first.address, '12 Nile St');
      expect(data.first.city, 'Cairo');
      verify(remoteDataSource.getAddresses()).called(1);
    });

    test('returns ErrorResponse when data source fails', () async {
      when(remoteDataSource.getAddresses()).thenThrow(
        ApiException(message: 'Get addresses failed'),
      );

      final result = await repo.getAddresses();

      expect(result, isA<ErrorResponse<List<AddressEntity>>>());
      expect(
        (result as ErrorResponse<List<AddressEntity>>).errorMessage,
        'Get addresses failed',
      );
      verify(remoteDataSource.getAddresses()).called(1);
    });
  });

  group('addAddress', () {
    test('returns SuccessResponse when data source succeeds', () async {
      when(remoteDataSource.addAddress(request)).thenAnswer(
        (_) async => successResponse(),
      );

      final result = await repo.addAddress(request);

      expect(result, isA<SuccessResponse<List<AddressEntity>>>());
      final data = (result as SuccessResponse<List<AddressEntity>>).data;
      expect(data.first.recipientName, 'Joudy');
      expect(data.first.label, 'Home');
      verify(remoteDataSource.addAddress(request)).called(1);
    });

    test('returns ErrorResponse when data source fails', () async {
      when(remoteDataSource.addAddress(request)).thenThrow(
        ApiException(message: 'Add address failed'),
      );

      final result = await repo.addAddress(request);

      expect(result, isA<ErrorResponse<List<AddressEntity>>>());
      expect(
        (result as ErrorResponse<List<AddressEntity>>).errorMessage,
        'Add address failed',
      );
      verify(remoteDataSource.addAddress(request)).called(1);
    });
  });

  group('deleteAddress', () {
    const addressId = 'addr-1';

    test('returns SuccessResponse when data source succeeds', () async {
      when(remoteDataSource.deleteAddress(addressId)).thenAnswer((_) async {});

      final result = await repo.deleteAddress(addressId);

      expect(result, isA<SuccessResponse<bool>>());
      expect((result as SuccessResponse<bool>).data, isTrue);
      verify(remoteDataSource.deleteAddress(addressId)).called(1);
    });

    test('returns ErrorResponse when data source fails', () async {
      when(remoteDataSource.deleteAddress(addressId)).thenThrow(
        ApiException(message: 'Delete address failed'),
      );

      final result = await repo.deleteAddress(addressId);

      expect(result, isA<ErrorResponse<bool>>());
      expect(
        (result as ErrorResponse<bool>).errorMessage,
        'Delete address failed',
      );
      verify(remoteDataSource.deleteAddress(addressId)).called(1);
    });
  });
}
