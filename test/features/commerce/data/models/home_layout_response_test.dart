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
