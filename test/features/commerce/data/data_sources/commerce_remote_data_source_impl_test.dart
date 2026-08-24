import 'package:flower_app/features/commerce/api/commerce_api_client.dart';
import 'package:flower_app/features/commerce/data/data_sources/commerce_remote_data_source_impl.dart';
import 'package:flower_app/features/commerce/data/models/occasion_model.dart';
import 'package:flower_app/features/commerce/data/models/occasions_response.dart';
import 'package:flower_app/features/commerce/data/models/product_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'commerce_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([CommerceApiClient])
void main() {
  late MockCommerceApiClient commerceApiClient;
  late CommerceRemoteDataSourceImpl dataSource;

  setUp(() {
    commerceApiClient = MockCommerceApiClient();
    dataSource = CommerceRemoteDataSourceImpl(commerceApiClient);
  });

  group('getAllOccasions', () {
    test('returns occasions response when the API call succeeds', () async {
      final response = OccasionsResponse(
        data: [
          OccasionModel(
            id: 'occasion-1',
            name: 'Birthday',
            imageUrl: 'https://example.com/birthday.jpg',
            sortOrder: 1,
          ),
        ],
        statusCode: 200,
        success: true,
        message: 'Success',
        messageLocalized: 'Success',
      );
      when(
        commerceApiClient.getAllOccasions(),
      ).thenAnswer((_) async => response);

      final result = await dataSource.getAllOccasions();

      expect(result, same(response));
      verify(commerceApiClient.getAllOccasions()).called(1);
    });

    test('propagates the API error when the call fails', () async {
      final error = Exception('Request failed');
      when(commerceApiClient.getAllOccasions()).thenThrow(error);

      expect(() => dataSource.getAllOccasions(), throwsA(same(error)));
    });
  });

  group('getProductsByOccasion', () {
    const occasionId = 'occasion-1';

    test('returns products response when the API call succeeds', () async {
      const response = ProductsResponse(
        data: ProductsDataDto(page: 1, pageSize: 10, totalCount: 0, items: []),
        statusCode: 200,
        success: true,
        message: 'Success',
        messageLocalized: 'Success',
      );
      when(
        commerceApiClient.getProductsByOccasion(occasionId),
      ).thenAnswer((_) async => response);

      final result = await dataSource.getProductsByOccasion(occasionId);

      expect(result, same(response));
      verify(commerceApiClient.getProductsByOccasion(occasionId)).called(1);
    });

    test('propagates the API error when the call fails', () async {
      final error = Exception('Request failed');
      when(
        commerceApiClient.getProductsByOccasion(occasionId),
      ).thenThrow(error);

      expect(
        () => dataSource.getProductsByOccasion(occasionId),
        throwsA(same(error)),
      );
    });
  });
}
