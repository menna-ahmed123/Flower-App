import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/commerce/domain/entities/home_layout_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:flower_app/features/commerce/domain/use_cases/home_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_use_case_test.mocks.dart';

@GenerateMocks([CommerceRepo])
void main() {
  late MockCommerceRepo repo;
  late HomeUseCase useCase;
  const layout = HomeLayoutEntity(sections: []);

  setUp(() {
    repo = MockCommerceRepo();
    useCase = HomeUseCase(repo);
  });

  test('returns success from commerce repo', () async {
    provideDummy<BaseResponse<HomeLayoutEntity>>(SuccessResponse(layout));
    when(repo.getHomeLayout()).thenAnswer((_) async => SuccessResponse(layout));
    final result = await useCase();
    expect(result, isA<SuccessResponse<HomeLayoutEntity>>());
    verify(repo.getHomeLayout()).called(1);
  });

  test('returns error from commerce repo', () async {
    final error = ErrorResponse<HomeLayoutEntity>(
      appError: BadResponseError('failed'),
    );
    provideDummy<BaseResponse<HomeLayoutEntity>>(error);
    when(repo.getHomeLayout()).thenAnswer((_) async => error);
    final result = await useCase();
    expect(result, isA<ErrorResponse<HomeLayoutEntity>>());
  });
}
