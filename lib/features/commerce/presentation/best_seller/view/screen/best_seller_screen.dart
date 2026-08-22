import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/utils/commerce_widgets/commerce_app_bar.dart';
import 'package:flower_app/core/utils/commerce_widgets/product_grid.dart';
import 'package:flower_app/features/commerce/domain/entities/product_entity.dart';
import 'package:flower_app/features/commerce/presentation/best_seller/view_model/best_seller_event.dart';
import 'package:flower_app/features/commerce/presentation/best_seller/view_model/best_seller_state.dart';
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
  late final BestSellerViewModel bestSellViewModel;

  @override
  void initState() {
    super.initState();
    bestSellViewModel = context.read<BestSellerViewModel>();
    bestSellViewModel.doEvent(BestSeller());
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
                title: "Best seller",
                des: "Bloom with our exquisite best sellers",
              ),
            ),
      
            Expanded(
              child: BlocBuilder<BestSellerViewModel, BestSellerState>(
                builder: (context, state) {
                  final productState = state.bestSellState;
      
                  if (productState.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: context.colors.pink,
                      ),
                    );
                  }
      
                  if (productState.errorMessage.isNotEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
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
                              productState.errorMessage,
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
                                bestSellViewModel.doEvent(BestSeller());
                              },
                              child: const Text(AppString.retry),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
      
                  final List<ProductEntity> products = productState.data ?? [];
      
                  if (products.isEmpty) {
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
                            'No products found',
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
      
                   return ProductGrid(products: products); 
                  
                },
        
              ),
            ),
          ],
        ),
      ),
    );
  }
}
