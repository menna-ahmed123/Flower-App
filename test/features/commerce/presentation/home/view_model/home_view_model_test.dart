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

  test('empty query returns the original product list', () async {
    await _load(viewModel, useCase, _products());
    viewModel.doEvent(HomeQueryChanged(''));
    expect(_names(viewModel), ['Sunny', 'Red roses', 'Spring vase']);
  });

  test('matching query filters products by name', () async {
    await _load(viewModel, useCase, _products());
    viewModel.doEvent(HomeQueryChanged('rose'));
    expect(_names(viewModel), ['Red roses']);
  });

  test('search is case-insensitive', () async {
    await _load(viewModel, useCase, _products());
    viewModel.doEvent(HomeQueryChanged('SUNNY'));
    expect(_names(viewModel), ['Sunny']);
  });

  test('non-matching query returns no products', () async {
    await _load(viewModel, useCase, _products());
    viewModel.doEvent(HomeQueryChanged('xyz'));
    expect(_names(viewModel), isEmpty);
  });

  test('does not mutate the original product list', () async {
    final original = _products();
    await _load(viewModel, useCase, original);
    viewModel.doEvent(HomeQueryChanged('rose'));
    expect(original.sections.single.items.map((item) => item.name), [
      'Sunny',
      'Red roses',
      'Spring vase',
    ]);
  });
}

HomeLayoutEntity _products() {
  return HomeLayoutEntity(
    sections: [
      sectionEntity(
        type: 'product_rail',
        id: 'p',
        items: [railItem('Sunny'), railItem('Red roses'), railItem('Spring vase')],
      ),
    ],
  );
}

List<String> _names(HomeViewModel viewModel) {
  return [
    for (final item in viewModel.displayedSections.single.items) item.name,
  ];
}

Future<void> _load(
  HomeViewModel viewModel,
  MockHomeUseCase useCase,
  HomeLayoutEntity layout,
) async {
  provideDummy<BaseResponse<HomeLayoutEntity>>(SuccessResponse(layout));
  when(useCase()).thenAnswer((_) async => SuccessResponse(layout));
  viewModel.doEvent(HomeRequested());
  await Future<void>.delayed(Duration.zero);
}
