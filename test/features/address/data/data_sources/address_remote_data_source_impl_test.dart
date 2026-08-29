import 'package:flower_app/features/address/api/address_api_client.dart';
import 'package:flower_app/features/address/data/data_sources/address_remote_data_source_impl.dart';
import 'package:flower_app/features/address/data/models/add_address_request.dart';
import 'package:flower_app/features/address/data/models/add_address_response.dart';
import 'package:flower_app/features/address/data/models/address_dto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'address_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([AddressApiClient])
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

  late MockAddressApiClient addressApiClient;
  late AddressRemoteDataSourceImpl dataSource;

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
    addressApiClient = MockAddressApiClient();
    dataSource = AddressRemoteDataSourceImpl(addressApiClient: addressApiClient);
  });

  group('getAddresses', () {
    test('returns AddressResponse when api call succeeds', () async {
      final response = successResponse();
      when(addressApiClient.getAddresses()).thenAnswer((_) async => response);

      final result = await dataSource.getAddresses();

      expect(result, response);
      expect(result.data, hasLength(1));
      expect(result.data.first.id, 'addr-1');
      verify(addressApiClient.getAddresses()).called(1);
    });

    test('throws when api call fails', () async {
      final exception = Exception('Get addresses failed');
      when(addressApiClient.getAddresses()).thenThrow(exception);

      expect(() => dataSource.getAddresses(), throwsA(exception));
      verify(addressApiClient.getAddresses()).called(1);
    });
  });

  group('addAddress', () {
    test('returns AddressResponse when api call succeeds', () async {
      final response = successResponse();
      when(
        addressApiClient.addAddress(request),
      ).thenAnswer((_) async => response);

      final result = await dataSource.addAddress(request);

      expect(result, response);
      expect(result.success, isTrue);
      verify(addressApiClient.addAddress(request)).called(1);
    });

    test('throws when api call fails', () async {
      final exception = Exception('Add address failed');
      when(addressApiClient.addAddress(request)).thenThrow(exception);

      expect(() => dataSource.addAddress(request), throwsA(exception));
      verify(addressApiClient.addAddress(request)).called(1);
    });
  });

  group('deleteAddress', () {
    const addressId = 'addr-1';

    test('completes when api call succeeds', () async {
      when(addressApiClient.deleteAddress(addressId)).thenAnswer((_) async {});

      await dataSource.deleteAddress(addressId);

      verify(addressApiClient.deleteAddress(addressId)).called(1);
    });

    test('throws when api call fails', () async {
      final exception = Exception('Delete address failed');
      when(addressApiClient.deleteAddress(addressId)).thenThrow(exception);

      expect(() => dataSource.deleteAddress(addressId), throwsA(exception));
      verify(addressApiClient.deleteAddress(addressId)).called(1);
    });
  });
}
