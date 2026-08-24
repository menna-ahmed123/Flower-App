import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/network/safe_call.dart';
import 'package:flower_app/features/commerce/data/data_sources/commerce_remote_data_source.dart';
import 'package:flower_app/features/commerce/data/models/occasion_model.dart';
import 'package:flower_app/features/commerce/data/models/occasions_response.dart';
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
	late MockCommerceRemoteDataSource remoteDataSource;
	late CommerceRepoImpl repository;

	setUp(() {
		remoteDataSource = MockCommerceRemoteDataSource();
		repository = CommerceRepoImpl(remoteDataSource, SafeCall());
	});

	group('getAllOccasions', () {
		test('returns occasion models when the data source succeeds', () async {
			final occasions = [
				OccasionModel(
					id: 'occasion-1',
					name: 'Birthday',
					imageUrl: 'https://example.com/birthday.jpg',
					sortOrder: 1,
				),
			];
			final response = OccasionsResponse(
				data: occasions,
				statusCode: 200,
				success: true,
				message: 'Success',
				messageLocalized: 'Success',
			);
			when(remoteDataSource.getAllOccasions())
					.thenAnswer((_) async => response);

			final result = await repository.getAllOccasions();

			expect(result, isA<SuccessResponse<List<OccasionModel>>>());
			expect((result as SuccessResponse<List<OccasionModel>>).data, occasions);
			verify(remoteDataSource.getAllOccasions()).called(1);
		});

		test('returns an error response when the data source fails', () async {
			when(remoteDataSource.getAllOccasions())
					.thenThrow(Exception('Request failed'));

			final result = await repository.getAllOccasions();

			expect(result, isA<ErrorResponse<List<OccasionModel>>>());
			verify(remoteDataSource.getAllOccasions()).called(1);
		});
	});

	group('getProductsByOccasion', () {
		const occasionId = 'occasion-1';

		test('maps products when the data source succeeds', () async {
			const product = ProductDto(
				id: 'product-1',
				name: 'Rose Bouquet',
				imageUrl: 'https://example.com/rose.jpg',
				price: 25,
				discountedPrice: 20,
				discountPercent: 20,
				inStock: true,
			);
			const response = ProductsResponse(
				data: ProductsDataDto(
					page: 1,
					pageSize: 10,
					totalCount: 1,
					items: [product],
				),
				statusCode: 200,
				success: true,
				message: 'Success',
				messageLocalized: 'Success',
			);
			when(remoteDataSource.getProductsByOccasion(occasionId))
					.thenAnswer((_) async => response);

			final result = await repository.getProductsByOccasion(occasionId);

			expect(result, isA<SuccessResponse<List<ProductEntity>>>());
			expect(
				(result as SuccessResponse<List<ProductEntity>>).data,
				[product.toDomain()],
			);
			verify(remoteDataSource.getProductsByOccasion(occasionId)).called(1);
		});

		test('returns an error response when the data source fails', () async {
			when(remoteDataSource.getProductsByOccasion(occasionId))
					.thenThrow(Exception('Request failed'));

			final result = await repository.getProductsByOccasion(occasionId);

			expect(result, isA<ErrorResponse<List<ProductEntity>>>());
			verify(remoteDataSource.getProductsByOccasion(occasionId)).called(1);
		});
	});
}
 