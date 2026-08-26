import 'package:flower_app/app/router/app_routes.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

void navigateToProductDetails(BuildContext context, String productId) {
  if (productId.isEmpty) return;

  context.push(
    AppRoutesName.productDetails.replaceFirst(':productId', productId),
  );
}
