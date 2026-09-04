import 'dart:developer' as developer;

import 'package:flower_app/app/router/app_routes.dart';
import 'package:flower_app/features/commerce/domain/entities/home_layout_entity.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/category_rail.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/home_banner.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/home_header.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/occasion_rail.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/product_rail.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeSectionList extends StatelessWidget {
  const HomeSectionList({super.key, required this.sections, this.onQuery});

  final List<HomeSectionEntity> sections;
  final ValueChanged<String>? onQuery;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: HomeHeader(onQuery: onQuery)),
        for (final section in sections)
          SliverToBoxAdapter(child: HomeSectionView(section: section)),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
      ],
    );
  }
}

class HomeSectionView extends StatelessWidget {
  const HomeSectionView({super.key, required this.section});

  final HomeSectionEntity section;

  @override
  Widget build(BuildContext context) {
    return _section((link) => openHomeDeepLink(context, link));
  }

  Widget _section(ValueChanged<String> onDeepLink) {
    return switch (section.type) {
      'banner' => HomeBanner(section: section, onDeepLink: onDeepLink),
      'category_rail' || 'Categories' => CategoryRail(
        section: section,
        onDeepLink: onDeepLink,
      ),
      'product_rail' || 'BestSeller' || 'ProductsCarousel' => ProductRail(
        section: section,
        onDeepLink: onDeepLink,
      ),
      'occasion_rail' || 'Occasions' => OccasionRail(
        section: section,
        onDeepLink: onDeepLink,
      ),
      _ => _unknownSection(section.type),
    };
  }
}

Widget _unknownSection(String type) {
  if (kDebugMode) {
    developer.log('Unknown home section type: $type', name: 'Home');
  }
  return const SizedBox.shrink();
}

void openHomeDeepLink(BuildContext context, String deepLink) {
  if (deepLink.isEmpty) return;
  final location = mapHomeDeepLink(deepLink);
  if (location == AppRoutesName.category) {
    context.go(location);
    return;
  }
  context.push(location);
}

String mapHomeDeepLink(String deepLink) {
  final uri = Uri.tryParse(deepLink);
  final path = uri?.path.toLowerCase() ?? deepLink;
  if (path.contains('categor')) return AppRoutesName.category;
  if (path.contains('occasion')) return AppRoutesName.occasion;
  if (path.contains('product_details') || path.contains('/products/')) {
    final productId = uri?.queryParameters['productId'] ??
        uri?.queryParameters['id'] ??
        (uri != null && uri.pathSegments.isNotEmpty
            ? uri.pathSegments.last
            : null);
    if (productId != null && productId.isNotEmpty) {
      return AppRoutesName.productDetails.replaceFirst(
        ':productId',
        productId,
      );
    }
    return AppRoutesName.bestSeller;
  }
  if (path.contains('product') || path.contains('best')) {
    return AppRoutesName.bestSeller;
  }
  return deepLink;
}
