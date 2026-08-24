import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/network/safe_call.dart';
import 'package:flower_app/features/commerce/data/data_sources/commerce_remote_data_source.dart';
import 'package:flower_app/features/commerce/data/models/product_dto.dart';
import 'package:flower_app/features/commerce/data/models/product_response.dart';
import 'package:flower_app/features/commerce/data/repo/commerce_repo_impl.dart';
import 'package:flower_app/features/commerce/domain/entities/product_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'commerce_repo_impl_test.mocks.dart';

@GenerateMocks([CommerceRemoteDataSource])
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

  final dummyProductsEntity = [
    const ProductEntity(
      id: '1',
      name: 'Red Rose Bouquet',
      imageUrl: 'https://example.com/rose.jpg',
      price: 25.0,
      discountedPrice: 20.0,
      discountPercent: 20.0,
      inStock: true,
    ),
    const ProductEntity(
      id: '2',
      name: 'White Lily Bunch',
      imageUrl: 'https://example.com/lily.jpg',
      price: 22.5,
      discountedPrice: 22.5,
      discountPercent: 0.0,
      inStock: false,
    ),
  ];

  late MockCommerceRemoteDataSource remoteDataSource;
  late CommerceRepoImpl repoImpl;

  setUp(() {
    remoteDataSource = MockCommerceRemoteDataSource();
    repoImpl = CommerceRepoImpl(remoteDataSource, SafeCall());
  });

  group('CommerceRepoImpl', () {
    test('should return SuccessResponse with list of products when remote call succeeds',
        () async {
      when(remoteDataSource.getAllProducts())
          .thenAnswer((_) async => dummyProductsResponse);

      final result = await repoImpl.getAllProducts();

      expect(result, isA<SuccessResponse<List<ProductEntity>>>());
      expect((result as SuccessResponse<List<ProductEntity>>).data, dummyProductsEntity);
    });

    test('should return ErrorResponse when remote call fails', () async {
      when(remoteDataSource.getAllProducts()).thenThrow(Exception('No Found Page'));

      final result = await repoImpl.getAllProducts();

      expect(result, isA<ErrorResponse<List<ProductEntity>>>());
      expect((result as ErrorResponse<List<ProductEntity>>).errorMessage, isNotEmpty);
    });
  });
}