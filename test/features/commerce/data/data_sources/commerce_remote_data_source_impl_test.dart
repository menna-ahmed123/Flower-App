import 'package:flower_app/features/commerce/api/commerce_api_client.dart';
import 'package:flower_app/features/commerce/data/data_sources/commerce_remote_data_source_impl.dart';
import 'package:flower_app/features/commerce/data/models/product_dto.dart';
import 'package:flower_app/features/commerce/data/models/product_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'commerce_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([CommerceApiClient])
void main() {
  final dummyProductsResponse = ProductsResponse(
    data: const ProductsDataDto(
      page: 1,
      pageSize: 2,
      totalCount: 2,
      items: [
        ProductDto(
          id: '1',
          name: 'Red Rose Bouquet',
          imageUrl: 'https://example.com/rose.jpg',
          price: 25.0,
          discountedPrice: 20.0,
          discountPercent: 20.0,
          inStock: true,
        ),
        ProductDto(
          id: '2',
          name: 'White Lily Bunch',
          imageUrl: 'https://example.com/lily.jpg',
          price: 22.5,
          discountedPrice: 22.5,
          discountPercent: 0.0,
          inStock: false,
        ),
      ],
    ),
    statusCode: 200,
    success: true,
    message: 'success',
    messageLocalized: 'success',
  );

  late CommerceApiClient apiClient;
  late CommerceRemoteDataSourceImpl remoteDataSourceImpl;

  setUp(() {
    apiClient = MockCommerceApiClient();
    remoteDataSourceImpl = CommerceRemoteDataSourceImpl(apiClient);
  });

  group('call CommerceApiClient.AllProduct', () {
    test('returns a valid products response when the API call succeeds', () async {
      when(apiClient.getAllProducts()).thenAnswer((_) async => dummyProductsResponse);

      final result = await remoteDataSourceImpl.getAllProducts();

      expect(result.statusCode, 200);
      expect(result.success, isTrue);
      expect(result.data.items.length, 2);
      expect(result.data.items.first.name, 'Red Rose Bouquet');
      verify(apiClient.getAllProducts()).called(1);
    });

    test('should throw exception when the API call fails', () async {
      when(apiClient.getAllProducts()).thenThrow(Exception('No Found Page'));

      expect(
        () => remoteDataSourceImpl.getAllProducts(),
        throwsA(isA<Exception>()),
      );
    });
  });

}