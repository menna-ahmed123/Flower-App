import 'package:flower_app/core/utils/commerce_widgets/product_grid.dart';
import 'package:flower_app/features/commerce/domain/models/product_dummy_data.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ProductGrid(dummyProducts: dummyProducts));
  }
}