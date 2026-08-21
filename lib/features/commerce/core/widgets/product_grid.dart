import 'package:flower_app/features/commerce/core/widgets/commerce_widgets/widgets/product_card.dart';
import 'package:flower_app/features/commerce/domain/models/product_request.dart';
import 'package:flutter/material.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key, required this.dummyProducts});
  final List<Product> dummyProducts;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
  padding: const EdgeInsets.all(16),
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 12,
    mainAxisSpacing: 12,
childAspectRatio: 0.6,  ),
  itemCount: dummyProducts.length,
  itemBuilder: (context, index) {
    final product = dummyProducts[index];

    return ProductCard(
      imageUrl: product.imageUrl,
      name: product.name,
      price: product.price,
      oldPrice: product.oldPrice,
      discount: product.discount,
      onAddToCart: () {  },
      onTap: () {  },

    );
  },
);
  }
}