import 'package:flower_app/app/router/app_routes.dart';
import 'package:flower_app/features/commerce/domain/entities/home_layout_entity.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/home_banner.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/home_section_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../../home/home_test_support.dart';

void main() {
  test('maps backend deep links onto existing routes', () {
    expect(mapHomeDeepLink('/categories'), AppRoutesName.category);
    expect(
      mapHomeDeepLink('/products?collection=summer'),
      AppRoutesName.bestSeller,
    );
    expect(mapHomeDeepLink('/occasions'), AppRoutesName.occasion);
    expect(mapHomeDeepLink('/product_details'), AppRoutesName.productDetails);
  });

  testWidgets('renders sections in API order and skips unknown types', (
    tester,
  ) async {
    await pumpThemed(tester, HomeSectionList(sections: _orderedSections()));
    expect(find.byType(HomeBanner), findsOneWidget);
    expect(find.text('Best seller'), findsOneWidget);
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Mystery'), findsNothing);
  });

  testWidgets('View All uses existing category route', (tester) async {
    final router = _viewAllRouter();
    await pumpRouted(tester, router);
    await tester.tap(find.text('View All'));
    await tester.pump();
    expect(
      router.routeInformationProvider.value.uri.path,
      AppRoutesName.category,
    );
  });
}

List<HomeSectionEntity> _orderedSections() {
  return [
    sectionEntity(type: 'banner', id: 'b', title: 'Hero'),
    sectionEntity(type: 'unknown_type', id: 'u', title: 'Mystery'),
    sectionEntity(type: 'product_rail', id: 'p', title: 'Best seller'),
    sectionEntity(
      type: 'category_rail',
      id: 'c',
      title: 'Categories',
      viewAllDeepLink: '/categories',
      items: [railItem('Flowers')],
    ),
  ];
}

GoRouter _viewAllRouter() {
  return GoRouter(
    initialLocation: AppRoutesName.home,
    routes: [
      GoRoute(
        path: AppRoutesName.home,
        builder: (context, state) {
          return Scaffold(body: HomeSectionList(sections: _orderedSections()));
        },
      ),
      GoRoute(
        path: AppRoutesName.category,
        builder: (context, state) => const Scaffold(body: Text('Category')),
      ),
    ],
  );
}
