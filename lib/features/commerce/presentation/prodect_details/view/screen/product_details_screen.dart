import 'package:flower_app/core/widgets/app_button.dart';
import 'package:flower_app/features/commerce/domain/entities/product_details_entity.dart';
import 'package:flower_app/features/commerce/presentation/prodect_details/view/widgets/product_details_body.dart';
import 'package:flower_app/features/commerce/presentation/prodect_details/view_model/product_details_state.dart';
import 'package:flower_app/features/commerce/presentation/prodect_details/view_model/product_details_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/auth/auth_extension.dart';

// The route already creates the cubit AND fires GetProductDetailsEvent
// (see productDetailsBranch), so this screen just reads the state —
// no BlocProvider, no initState, no event dispatch here.
class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product details')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<ProductDetailsViewModel, ProductDetailsState>(
                builder: (context, state) {
                  final requestState = state.productDetailsState;

                  if (requestState.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (requestState.errorMessage.isNotEmpty) {
                    return Center(child: Text(requestState.errorMessage));
                  }

                  final ProductDetailsEntity? product = requestState.data;

                  if (product == null) {
                    return const SizedBox.shrink();
                  }

                  return ProductDetailsBody(product: product,);
                },
              ),
            ), AppButton(
              text: "Add to cart",
              onPressed: () async {
                await context.requireAuth(
                  action: () async {
                    // TODO: actual add-to-cart action
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
