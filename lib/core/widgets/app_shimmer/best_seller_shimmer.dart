import 'package:flower_app/core/widgets/app_shimmer/product_grid_shimmer.dart';
import 'package:flower_app/core/widgets/app_shimmer/shimmer_base.dart';
import 'package:flutter/material.dart';

/// Shimmer skeleton for the Best Seller screen.
class BestSellerShimmer extends StatelessWidget {
  const BestSellerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppShimmerEffect(child: ProductGridShimmer());
  }
}
