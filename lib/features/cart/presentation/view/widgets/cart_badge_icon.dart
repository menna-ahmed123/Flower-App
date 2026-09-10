import 'package:flower_app/core/constants/app_icons.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartBadgeIcon extends StatelessWidget {
  const CartBadgeIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final count = context.select<CartViewModel, int>(
      (viewModel) => viewModel.state.itemCount,
    );
    return Badge(
      isLabelVisible: count > 0,
      backgroundColor: context.colors.pink,
      label: Text('$count'),
      child: const Icon(AppIcons.shoppingCart),
    );
  }
}
