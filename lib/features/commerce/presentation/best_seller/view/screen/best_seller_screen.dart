import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/navigation/product_navigation.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/utils/pagination/pagination_grid_view.dart';
import 'package:flower_app/core/utils/pagination/pagination_state.dart';
import 'package:flower_app/core/widgets/app_shimmer/best_seller_shimmer.dart';
import 'package:flower_app/features/auth/core/auth_extension.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_event.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_view_model.dart';
import 'package:flower_app/features/commerce/core/widgets/commerce_app_bar.dart';
import 'package:flower_app/features/commerce/core/widgets/product_card.dart';
import 'package:flower_app/features/commerce/domain/entities/product_entity.dart';
import 'package:flower_app/features/commerce/presentation/best_seller/view_model/best_seller_event.dart';
import 'package:flower_app/features/commerce/presentation/best_seller/view_model/best_seller_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BestSellerScreen extends StatefulWidget {
  const BestSellerScreen({super.key});
  @override
  State<BestSellerScreen> createState() => _BestSellerScreenState();
}

class _BestSellerScreenState extends State<BestSellerScreen> {
  late final BestSellerViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<BestSellerViewModel>();
    _viewModel.doEvent(BestSeller());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 70.h,
              child: CommerceAppBar(
                title: AppString.bestSellers,
                des: AppString.desSell,
              ),
            ),
            Expanded(
              child: ListenableBuilder(
                listenable: _viewModel.productsPaginationController,
                builder: (context, _) {
                  final paginationState =
                      _viewModel.productsPaginationController.state;

                  // Show shimmer on initial load
                  if (paginationState.status == PaginationStatus.loading &&
                      paginationState.items.isEmpty) {
                    return const BestSellerShimmer();
                  }

                  // Show error on initial load failure
                  if (paginationState.status == PaginationStatus.error &&
                      paginationState.items.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: context.colors.error,
                              size: 60,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              paginationState.errorMessage ??
                                  AppString.somethingWrong,
                              style: TextStyle(
                                fontSize: 16,
                                color: context.colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: context.colors.pink,
                                foregroundColor: context.colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: () {
                                _viewModel.productsPaginationController.retry();
                              },
                              child: const Text(AppString.retry),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Empty state
                  if (paginationState.items.isEmpty &&
                      paginationState.status == PaginationStatus.success) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            color: context.colors.grey.shade600,
                            size: 60,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            AppString.notFound,
                            style: TextStyle(
                              fontSize: 16,
                              color: context.colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return PaginationGridView<ProductEntity>(
                    controller: _viewModel.productsPaginationController,
                    padding: EdgeInsets.all(16.w),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 12.h,
                      childAspectRatio: 0.55,
                    ),
                    itemBuilder: (context, product, index) {
                      return ProductCard(
                        productId: product.id,
                        imageUrl: product.imageUrl,
                        name: product.name,
                        price: product.discountedPrice > 0
                            ? product.discountedPrice.toStringAsFixed(2)
                            : 'N/A',
                        oldPrice: product.price != product.discountedPrice
                            ? product.price?.toStringAsFixed(2)
                            : null,
                        discount: product.discountPercent != null
                            ? '${product.discountPercent!.toStringAsFixed(0)}%'
                            : null,
                        onAddToCart: () => _addToCart(context, product.id),
                        onTap: () =>
                            navigateToProductDetails(context, product.id),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addToCart(BuildContext context, String productId) {
    return context.requireAuth(
      action: () {
        return context.read<CartViewModel>().doEvent(
          AddCartItemEvent(productId: productId),
        );
      },
    );
  }
}
