import 'package:flower_app/features/commerce/data/models/home_layout_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../home/home_test_support.dart';

void main() {
  test('parses a list of sections as data', () {
    final response = HomeLayoutResponse.fromJson({
      'data': [
        _jsonSection('product_rail', 'p', 2),
        _jsonSection('category_rail', 'c', 1),
      ],
    });
    final entity = response.toDomain();
    expect(entity.sections.map((s) => s.type).toList(), [
      'category_rail',
      'product_rail',
    ]);
  });

  test('parses nested sections and skips disabled ones', () {
    final response = HomeLayoutResponse.fromJson({
      'data': {
        'sections': [
          _jsonSection('banner', 'b', 1),
          _jsonSection('occasion_rail', 'o', 2, enabled: false),
        ],
      },
    });
    final entity = response.toDomain();
    expect(entity.sections.map((s) => s.type).toList(), ['banner']);
  });

  test('parses empty data as no sections', () {
    final response = HomeLayoutResponse.fromJson({'data': []});
    expect(response.toDomain().sections, isEmpty);
  });

  test('reads success as isSuccess from the real API envelope', () {
    final response = HomeLayoutResponse.fromJson({
      'success': true,
      'statusCode': 200,
      'data': [_jsonSection('banner', 'b', 1)],
    });
    expect(response.isSuccess, isTrue);
    expect(response.toDomain().sections.single.type, 'banner');
  });

  test('uses payload deepLink as view-all when viewAll is missing', () {
    final dto = sectionDto(
      type: 'category_rail',
      id: 'c',
      payload: const {'deepLink': '/categories'},
    );
    expect(dto.toDomain().viewAllDeepLink, '/categories');
  });

  test('keeps unknown enabled types for the renderer to ignore', () {
    final dto = sectionDto(type: 'unknown_type', id: 'u', order: 1);
    expect(dto.toDomain().type, 'unknown_type');
  });
}

Map<String, dynamic> _jsonSection(
  String type,
  String id,
  int order, {
  bool enabled = true,
}) {
  return {
    'type': type,
    'id': id,
    'title': type,
    'order': order,
    'enabled': enabled,
    'payload': const <String, dynamic>{},
  };
}
