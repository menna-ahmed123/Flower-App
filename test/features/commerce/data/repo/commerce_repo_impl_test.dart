import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/network/safe_call.dart';
import 'package:flower_app/features/commerce/data/data_sources/commerce_remote_data_source.dart';
import 'package:flower_app/features/commerce/data/models/home_layout_response.dart';
import 'package:flower_app/features/commerce/data/repo/commerce_repo_impl.dart';
import 'package:flower_app/features/commerce/domain/entities/home_layout_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../home/home_test_support.dart';
import 'commerce_repo_impl_test.mocks.dart';

@GenerateMocks([CommerceRemoteDataSource])
void main() {
  late MockCommerceRemoteDataSource remote;
  late CommerceRepoImpl repo;

  setUp(() {
    remote = MockCommerceRemoteDataSource();
    repo = CommerceRepoImpl(remote, SafeCall());
  });

  test('maps a successful layout response to domain', () async {
    when(remote.getHomeLayout()).thenAnswer((_) async => _response());
    final result = await repo.getHomeLayout();
    expect(result, isA<SuccessResponse<HomeLayoutEntity>>());
    final data = (result as SuccessResponse<HomeLayoutEntity>).data;
    expect(data.sections.map((s) => s.type), ['category_rail']);
  });

  test('returns ErrorResponse when isSuccess is false', () async {
    when(remote.getHomeLayout()).thenAnswer((_) async {
      return HomeLayoutResponse(
        isSuccess: false,
        statusCode: 400,
        message: 'bad layout',
        data: const [],
      );
    });
    final result = await repo.getHomeLayout();
    expect(result, isA<ErrorResponse<HomeLayoutEntity>>());
    expect(
      (result as ErrorResponse<HomeLayoutEntity>).errorMessage,
      'bad layout',
    );
  });

  test('returns ErrorResponse when the data source throws', () async {
    when(remote.getHomeLayout()).thenThrow(Exception('network'));
    final result = await repo.getHomeLayout();
    expect(result, isA<ErrorResponse<HomeLayoutEntity>>());
  });
}

HomeLayoutResponse _response() {
  return HomeLayoutResponse(
    isSuccess: true,
    statusCode: 200,
    message: 'ok',
    data: [
      sectionDto(type: 'category_rail', id: 'c', title: 'Categories', order: 1),
      sectionDto(type: 'banner', id: 'b', order: 2, enabled: false),
    ],
  );
}
