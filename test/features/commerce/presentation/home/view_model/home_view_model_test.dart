import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/features/commerce/domain/entities/home_layout_entity.dart';
import 'package:flower_app/features/commerce/domain/use_cases/home_use_case.dart';
import 'package:flower_app/features/commerce/presentation/home/view_model/home_event.dart';
import 'package:flower_app/features/commerce/presentation/home/view_model/home_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../home/home_test_support.dart';
import 'home_view_model_test.mocks.dart';

@GenerateMocks([HomeUseCase])
void main() {
  late MockHomeUseCase useCase;
  late HomeViewModel viewModel;
  final layout = HomeLayoutEntity(
    sections: [sectionEntity(type: 'banner', id: 'b')],
  );

  setUp(() {
    useCase = MockHomeUseCase();
    viewModel = HomeViewModel(useCase);
  });

  tearDown(() async => viewModel.close());

  test('emits success sections when load succeeds', () async {
    provideDummy<BaseResponse<HomeLayoutEntity>>(SuccessResponse(layout));
    when(useCase()).thenAnswer((_) async => SuccessResponse(layout));
    viewModel.doEvent(HomeRequested());
    await Future<void>.delayed(Duration.zero);
    expect(viewModel.state.homeState.data, layout);
    expect(viewModel.state.homeState.isLoading, isFalse);
  });

  test('emits error when load fails', () async {
    provideDummy<BaseResponse<HomeLayoutEntity>>(SuccessResponse(layout));
    when(useCase()).thenAnswer((_) async {
      return ErrorResponse(appError: BadResponseError('failed'));
    });
    viewModel.doEvent(HomeRequested());
    await Future<void>.delayed(Duration.zero);
    expect(viewModel.state.homeState.errorMessage, 'failed');
  });
}
