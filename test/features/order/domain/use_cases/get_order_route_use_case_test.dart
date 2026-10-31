import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/order/domain/entities/geo_point.dart';
import 'package:flower_app/features/order/domain/repos/order_repo.dart';
import 'package:flower_app/features/order/domain/use_cases/get_order_route_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_order_route_use_case_test.mocks.dart';

@GenerateMocks([OrderRepo])
void main() {
  provideDummy<BaseResponse<List<GeoPoint>>>(
    const SuccessResponse<List<GeoPoint>>([]),
  );

  late MockOrderRepo orderRepo;
  late GetOrderRouteUseCase useCase;

  const from = GeoPoint(30.05, 31.23);
  const to = GeoPoint(30.06, 31.24);

  setUp(() {
    orderRepo = MockOrderRepo();
    useCase = GetOrderRouteUseCase(orderRepo);
  });

  group('call', () {
    test('passes both end points to the repository', () async {
      when(orderRepo.fetchRoute(
        from: anyNamed('from'),
        to: anyNamed('to'),
      )).thenAnswer((_) async => const SuccessResponse(<GeoPoint>[]));

      await useCase.call(from: from, to: to);

      verify(orderRepo.fetchRoute(from: from, to: to)).called(1);
    });

    test('returns the mapped route unchanged', () async {
      const route = [GeoPoint(30.05, 31.23), GeoPoint(30.06, 31.24)];
      when(orderRepo.fetchRoute(from: from, to: to))
          .thenAnswer((_) async => const SuccessResponse(route));

      final result = await useCase.call(from: from, to: to);

      expect((result as SuccessResponse).data, route);
    });

    test('relays a failure untouched', () async {
      when(orderRepo.fetchRoute(from: from, to: to)).thenAnswer(
        (_) async =>
            ErrorResponse(appError: BadResponseError('Route is unavailable.')),
      );

      final result = await useCase.call(from: from, to: to);

      expect(result, isA<ErrorResponse>());
      expect((result as ErrorResponse).appError.message,
          'Route is unavailable.');
    });
  });
}
