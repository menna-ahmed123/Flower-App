import 'dart:developer' as developer;

import 'package:flower_app/app/router/app_routes.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/commerce/domain/constants/home_section_types.dart';
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
  const HomeSectionList({
    super.key,
    required this.sections,
    required this.addresses,
    this.selectedAddress,
    this.onAddressSelected,
    this.onAddNewAddress,
  });

  final List<HomeSectionEntity> sections;
  final List<AddressEntity> addresses;
  final AddressEntity? selectedAddress;

  final ValueChanged<AddressEntity>? onAddressSelected;

  final VoidCallback? onAddNewAddress;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: HomeHeader(
            addresses: addresses,
            selectedAddress: selectedAddress,
            onAddressSelected: onAddressSelected,
            onAddNewAddress: onAddNewAddress,
          ),
        ),

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
      HomeSectionTypes.banner => HomeBanner(
        section: section,
        onDeepLink: onDeepLink,
      ),
      HomeSectionTypes.categoryRail || HomeSectionTypes.categories =>
        CategoryRail(section: section, onDeepLink: onDeepLink),
      HomeSectionTypes.productRail ||
      HomeSectionTypes.bestSeller ||
      HomeSectionTypes.productsCarousel => ProductRail(
        section: section,
        onDeepLink: onDeepLink,
      ),
      HomeSectionTypes.occasionRail || HomeSectionTypes.occasions =>
        OccasionRail(section: section, onDeepLink: onDeepLink),
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
  final location = mapHomeDeepLink(deepLink);
  if (location.isEmpty) return;

  if (location == AppRoutesName.category) {
    context.go(location);
    return;
  }

  context.push(location);
}

String mapHomeDeepLink(String deepLink) {
  final uri = Uri.tryParse(deepLink);
  final target = _deepLinkTarget(deepLink, uri);
  if (target.isEmpty) return '';

  if (target.contains('categor')) {
    return AppRoutesName.category;
  }

  if (target.contains('occasion')) {
    return AppRoutesName.occasion;
  }

  if (target.contains('product_details') || target.contains('products/')) {
    final productId = _productId(uri);
    if (productId != null) {
      return AppRoutesName.productDetails.replaceFirst(':productId', productId);
    }

    return AppRoutesName.bestSeller;
  }

  if (target.contains('product') || target.contains('best')) {
    return AppRoutesName.bestSeller;
  }

  return '';
}

/// Custom-scheme links such as `flowerapp://categories` keep the screen name
/// in the host. Path-only links such as `/categories` keep it in the path.
String _deepLinkTarget(String deepLink, Uri? uri) {
  if (uri == null) return deepLink.toLowerCase();
  if (uri.scheme == 'http' || uri.scheme == 'https') return '';
  if (!uri.hasScheme) return deepLink.toLowerCase();

  final location = '${uri.host}${uri.path}'.toLowerCase();
  final query = uri.queryParameters.values.join(' ').toLowerCase();
  if (query.isEmpty) return location;
  return '$location $query';
}

String? _productId(Uri? uri) {
  if (uri == null) return null;

  final fromQuery =
      uri.queryParameters['productId'] ?? uri.queryParameters['id'];
  if (fromQuery != null && fromQuery.isNotEmpty && !_isRouteWord(fromQuery)) {
    return fromQuery;
  }

  if (uri.pathSegments.isEmpty) return null;

  final last = uri.pathSegments.last;
  if (last.isEmpty || _isRouteWord(last)) return null;
  return last;
}

bool _isRouteWord(String value) {
  final normalized = value.toLowerCase();
  return normalized.contains('product') ||
      normalized.contains('categor') ||
      normalized.contains('occasion') ||
      normalized.contains('best');
}
