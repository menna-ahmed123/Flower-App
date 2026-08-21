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
  const HomeSectionList({super.key, required this.sections});

  final List<HomeSectionEntity> sections;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: HomeHeader()),
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
      'category_rail' => CategoryRail(section: section, onDeepLink: onDeepLink),
      'product_rail' => ProductRail(section: section, onDeepLink: onDeepLink),
      'occasion_rail' => OccasionRail(section: section, onDeepLink: onDeepLink),
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
  final path = Uri.tryParse(deepLink)?.path.toLowerCase() ?? deepLink;
  if (path.contains('categor')) return AppRoutesName.category;
  if (path.contains('occasion')) return AppRoutesName.occasion;
  if (path.contains('product_details') || path.contains('/products/')) {
    return AppRoutesName.productDetails;
  }
  if (path.contains('product') || path.contains('best')) {
    return AppRoutesName.bestSeller;
  }
  return deepLink;
}
